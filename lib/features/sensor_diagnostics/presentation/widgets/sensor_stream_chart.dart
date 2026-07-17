import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/sensor_utils.dart';

class LiveSensorStreamWidget extends StatefulWidget {
  final int sensorType;
  final String unit;
  final Map<String, dynamic>? sensorMetadata;

  const LiveSensorStreamWidget({
    super.key,
    required this.sensorType,
    required this.unit,
    this.sensorMetadata,
  });

  @override
  State<LiveSensorStreamWidget> createState() => _LiveSensorStreamWidgetState();
}

class _LiveSensorStreamWidgetState extends State<LiveSensorStreamWidget> {
  static const EventChannel _eventChannel = EventChannel('com.escapebranch.unfilter/sensor_stream');
  StreamSubscription? _subscription;

  final List<List<double>> _history = [];
  List<double> _currentValues = [];
  String? _error;
  bool _isWaitingForData = true;
  Timer? _waitingTimer;

  // Stats for 1D environmental & scalar sensors
  double? _minVal;
  double? _maxVal;
  double _sumVal = 0;
  int _sampleCount = 0;
  int _accuracy = 3; // 0=Unreliable, 1=Low, 2=Medium, 3=High

  // Step counter specific state
  int _stepCount = 0;
  final List<int> _stepHistory = List.filled(20, 0, growable: true);

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  DateTime _lastRenderTime = DateTime.fromMillisecondsSinceEpoch(0);

  void _subscribe() {
    try {
      _waitingTimer = Timer(const Duration(milliseconds: 1200), () {
        if (mounted && _currentValues.isEmpty && _error == null) {
          setState(() {
            _isWaitingForData = true;
          });
        }
      });

      _subscription = _eventChannel
          .receiveBroadcastStream(widget.sensorType)
          .listen(
        (event) {
          if (!mounted || event == null || event is! Map) return;

          final map = event;
          final rawValues = map['values'];
          if (rawValues is! List || rawValues.isEmpty) return;

          final List<double> values = [];
          for (final v in rawValues) {
            if (v == null || v is! num) continue;
            final d = v.toDouble();
            values.add(d.isFinite ? d : 0.0);
          }

          if (values.isEmpty) return;

          final int timestamp = (map['timestamp'] as num?)?.toInt() ?? DateTime.now().microsecondsSinceEpoch * 1000;
          final int accuracy = (map['accuracy'] as num?)?.toInt() ?? 3;

          _processSensorValues(values, timestamp, accuracy);
        },
        onError: (err) {
          if (!mounted) return;
          setState(() {
            _error = err.toString();
            _isWaitingForData = false;
          });
        },
      );
    } catch (e) {
      _error = e.toString();
      _isWaitingForData = false;
    }
  }

  void _processSensorValues(List<double> values, int timestampNs, int accuracy) {
    _currentValues = values;
    _history.add(values);
    if (_history.length > 80) {
      _history.removeAt(0);
    }

    _accuracy = accuracy;
    _error = null;
    _isWaitingForData = false;

    // Calculate min, max, avg for scalar/environmental values
    final val = values.first;
    _minVal = _minVal == null ? val : math.min(_minVal!, val);
    _maxVal = _maxVal == null ? val : math.max(_maxVal!, val);
    _sumVal += val;
    _sampleCount++;

    // Pedometer step tracking logic
    if (widget.sensorType == 19) { // TYPE_STEP_COUNTER
      _stepCount = val.toInt();
      _stepHistory.add(_stepCount);
      if (_stepHistory.length > 20) _stepHistory.removeAt(0);
    } else if (widget.sensorType == 18) { // TYPE_STEP_DETECTOR
      _stepCount += 1;
      _stepHistory.add(_stepCount);
      if (_stepHistory.length > 20) _stepHistory.removeAt(0);
    }

    // Rate-limit UI rebuilds to max 60 FPS (~16ms rate limit) to guarantee smooth performance on low-end devices
    final now = DateTime.now();
    if (now.difference(_lastRenderTime).inMilliseconds >= 16) {
      _lastRenderTime = now;
      if (mounted) {
        setState(() {});
      }
    }
  }


  void _unsubscribe() {
    _waitingTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sensor Initialization / Stream Message',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final category = getSensorCategory(widget.sensorType);

    if (_currentValues.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isWaitingForData)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              else
                Icon(
                  Icons.sensors_rounded,
                  color: theme.colorScheme.primary,
                  size: 40,
                ),
              const SizedBox(height: 16),
              Text(
                'Awaiting Hardware Sensor Stream...',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category == SensorCategory.pedometer
                    ? 'Step counter sensors fire on physical movement. Move device or trigger motion.'
                    : 'On-Change sensors (Light, Temp, Proximity) fire when the physical state changes.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Diagnostic Metrics Bar (Hz, Accuracy, Mode, Test Toggle)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          child: _buildDiagnosticMetricsHeader(theme),
        ),
        const SizedBox(height: 12),

        // Main Chart / Visualization Content
        _buildCategorySpecificView(theme, category),
      ],
    );
  }

  Widget _buildDiagnosticMetricsHeader(ThemeData theme) {
    final accuracyLabel = switch (_accuracy) {
      3 => 'High',
      2 => 'Medium',
      1 => 'Low',
      _ => 'Uncalibrated',
    };

    return Row(
      children: [
        _buildMetricBadge(
          theme,
          label: 'ACCURACY',
          value: accuracyLabel,
          color: _accuracy == 3 ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildMetricBadge(ThemeData theme, {required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySpecificView(ThemeData theme, SensorCategory category) {
    switch (category) {
      case SensorCategory.pedometer:
        return _buildPedometerView(theme);
      case SensorCategory.proximity:
        return _buildProximityView(theme);
      case SensorCategory.environment1D:
        return _buildEnvironmentalView(theme);
      case SensorCategory.motion3D:
      default:
        return _buildMultiAxisView(theme);
    }
  }

  // 1. Pedometer View
  Widget _buildPedometerView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.directions_walk_rounded, color: theme.colorScheme.primary, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUMULATIVE STEPS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_stepCount steps',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_stepHistory.isNotEmpty)
          SizedBox(
            height: 100,
            width: double.infinity,
            child: RepaintBoundary(
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: _stepHistory.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: theme.colorScheme.primary,
                          width: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 2. Proximity View
  Widget _buildProximityView(ThemeData theme) {
    final dist = _currentValues.isNotEmpty ? _currentValues.first : 0.0;
    final isNear = dist < 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isNear 
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isNear ? Icons.sensors_rounded : Icons.sensors_off_rounded,
                  color: isNear ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROXIMITY STATE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isNear ? 'NEAR (Object Detected)' : 'FAR (${dist.toStringAsFixed(1)} cm)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isNear ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLineGraph(theme, fillGradient: true),
      ],
    );
  }

  // 3. Environmental View
  Widget _buildEnvironmentalView(ThemeData theme) {
    final avg = _sampleCount > 0 ? _sumVal / _sampleCount : 0.0;
    final current = _currentValues.isNotEmpty ? _currentValues.first : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBadge(theme, 'CURRENT', '${current.toStringAsFixed(1)} ${widget.unit}'),
              _buildStatBadge(theme, 'MIN', '${(_minVal ?? 0).toStringAsFixed(1)} ${widget.unit}'),
              _buildStatBadge(theme, 'MAX', '${(_maxVal ?? 0).toStringAsFixed(1)} ${widget.unit}'),
              _buildStatBadge(theme, 'AVG', '${avg.toStringAsFixed(1)} ${widget.unit}'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildLineGraph(theme, fillGradient: true),
      ],
    );
  }

  Widget _buildStatBadge(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // 4. Multi-Axis Dynamic View (Handles 1 to N Series seamlessly)
  Widget _buildMultiAxisView(ThemeData theme) {
    double magnitude = 0;
    if (_currentValues.length >= 3) {
      magnitude = math.sqrt(
        _currentValues.sublist(0, 3).fold(0.0, (acc, val) => acc + (val * val))
      );
    }

    final axisColors = [
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
      theme.colorScheme.secondary,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              ..._currentValues.asMap().entries.map((entry) {
                final idx = entry.key;
                final val = entry.value;
                
                String label = 'Axis $idx';
                final color = axisColors[idx % axisColors.length];

                if (_currentValues.length == 3) {
                  if (idx == 0) label = 'X Axis';
                  if (idx == 1) label = 'Y Axis';
                  if (idx == 2) label = 'Z Axis';
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: '$label: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          TextSpan(
                            text: '${val.toStringAsFixed(3)} ${widget.unit}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              if (_currentValues.length == 3)
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: 'Magnitude: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      TextSpan(
                        text: '${magnitude.toStringAsFixed(3)} ${widget.unit}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildLineGraph(theme),
      ],
    );
  }

  Widget _buildLineGraph(ThemeData theme, {bool fillGradient = false}) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: RepaintBoundary(
        child: LineChart(
          LineChartData(
            minY: _getMinY(),
            maxY: _getMaxY(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
                strokeWidth: 1,
              ),
            ),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: _getLineBarsData(theme, fillGradient: fillGradient),
          ),
        ),
      ),
    );
  }

  double _getMinY() {
    if (_history.isEmpty) return 0.0;
    double minVal = double.infinity;
    for (final point in _history) {
      for (final val in point) {
        if (val.isFinite && val < minVal) minVal = val;
      }
    }
    if (!minVal.isFinite) return 0.0;
    final maxVal = _getMaxY();
    if ((maxVal - minVal).abs() < 0.001) {
      return minVal - 1.0; // Prevent flat zero-height span crash
    }
    return minVal - (minVal.abs() * 0.1 + 0.1);
  }

  double _getMaxY() {
    if (_history.isEmpty) return 1.0;
    double maxVal = double.negativeInfinity;
    for (final point in _history) {
      for (final val in point) {
        if (val.isFinite && val > maxVal) maxVal = val;
      }
    }
    if (!maxVal.isFinite) return 1.0;
    return maxVal + (maxVal.abs() * 0.1 + 0.1);
  }

  List<LineChartBarData> _getLineBarsData(ThemeData theme, {bool fillGradient = false}) {
    if (_history.isEmpty) return [];

    final numLines = _currentValues.length;
    final axisColors = [
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
      theme.colorScheme.secondary,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    return List.generate(numLines, (lineIdx) {
      final List<FlSpot> spots = [];
      for (int i = 0; i < _history.length; i++) {
        if (lineIdx < _history[i].length) {
          final val = _history[i][lineIdx];
          if (val.isFinite) {
            spots.add(FlSpot(i.toDouble(), val));
          }
        }
      }

      final color = axisColors[lineIdx % axisColors.length];

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        curveSmoothness: 0.3,
        preventCurveOverShooting: true,
        barWidth: 1.8,
        color: color,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: fillGradient && lineIdx == 0,
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );
    });
  }
}

