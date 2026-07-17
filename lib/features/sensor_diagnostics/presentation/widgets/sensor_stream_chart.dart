import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/sensor_utils.dart';

class LiveSensorStreamWidget extends StatefulWidget {
  final int sensorType;
  final String unit;

  const LiveSensorStreamWidget({
    super.key,
    required this.sensorType,
    required this.unit,
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
  bool _isWaitingForData = false;
  Timer? _waitingTimer;

  // Stats for 1D environmental sensors
  double? _minVal;
  double? _maxVal;
  double _sumVal = 0;
  int _sampleCount = 0;

  // Step counter specific state
  int _stepCount = 0;
  final List<int> _stepHistory = List.filled(20, 0);

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

  void _subscribe() {
    try {
      _waitingTimer = Timer(const Duration(milliseconds: 1500), () {
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
          if (!mounted) return;
          final map = event as Map;
          final List<double> values = List<double>.from(map['values'] as List);
          
          setState(() {
            _currentValues = values;
            _history.add(values);
            if (_history.length > 100) {
              _history.removeAt(0);
            }

            // Calculate min, max, avg for 1D sensors
            if (values.isNotEmpty) {
              final val = values.first;
              _minVal = _minVal == null ? val : math.min(_minVal!, val);
              _maxVal = _maxVal == null ? val : math.max(_maxVal!, val);
              _sumVal += val;
              _sampleCount++;

              // Pedometer logic
              if (widget.sensorType == 19) { // TYPE_STEP_COUNTER
                _stepCount = val.toInt();
                _stepHistory.add(_stepCount);
                if (_stepHistory.length > 20) _stepHistory.removeAt(0);
              } else if (widget.sensorType == 18) { // TYPE_STEP_DETECTOR
                _stepCount += 1;
                _stepHistory.add(_stepCount);
                if (_stepHistory.length > 20) _stepHistory.removeAt(0);
              }
            }

            _error = null;
            _isWaitingForData = false;
          });
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$_error',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final category = getSensorCategory(widget.sensorType);

    if (_currentValues.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isWaitingForData)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(Icons.directions_walk_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.3), size: 36),
              const SizedBox(height: 12),
              Text(
                category == SensorCategory.pedometer
                    ? 'Awaiting step data...\n(Move your device to trigger step events)'
                    : (_isWaitingForData
                        ? 'Awaiting sensor data...\n(Interact with device if needed)'
                        : 'Connecting to sensor...'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    switch (category) {
      case SensorCategory.pedometer:
        return _buildPedometerView(theme);
      case SensorCategory.proximity:
        return _buildProximityView(theme);
      case SensorCategory.environment1D:
        return _buildEnvironmentalView(theme);
      case SensorCategory.motion3D:
      default:
        return _buildMotion3DView(theme);
    }
  }

  // 1. Pedometer View: Step count badge, histogram, movement tip
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
        // Step Activity Bar Chart
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
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Note: Step sensors only fire events when movement is detected.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  // 2. Proximity View: NEAR vs FAR state badge + distance graph
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

  // 3. Environmental View: Min/Max/Avg Badges + Area Gradient Line Chart
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

  // 4. 3D Motion View: Legend badges for X, Y, Z + Vector Magnitude + Smooth line chart
  Widget _buildMotion3DView(ThemeData theme) {
    double magnitude = 0;
    if (_currentValues.length >= 3) {
      magnitude = math.sqrt(
        _currentValues[0] * _currentValues[0] +
        _currentValues[1] * _currentValues[1] +
        _currentValues[2] * _currentValues[2]
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              ..._currentValues.asMap().entries.map((entry) {
                final idx = entry.key;
                final val = entry.value;
                
                String label = 'Value';
                Color color = theme.colorScheme.primary;

                if (_currentValues.length == 3) {
                  if (idx == 0) {
                    label = 'X Axis';
                    color = theme.colorScheme.primary;
                  } else if (idx == 1) {
                    label = 'Y Axis';
                    color = theme.colorScheme.primary.withValues(alpha: 0.6);
                  } else {
                    label = 'Z Axis';
                    color = theme.colorScheme.primary.withValues(alpha: 0.3);
                  }
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 4,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
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
                              fontSize: 13,
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
                        text: 'Mag: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      TextSpan(
                        text: '${magnitude.toStringAsFixed(3)} ${widget.unit}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
      height: 140,
      width: double.infinity,
      child: RepaintBoundary(
        child: LineChart(
          LineChartData(
            minY: _getMinY(),
            maxY: _getMaxY(),
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: _getLineBarsData(theme, fillGradient: fillGradient),
          ),
        ),
      ),
    );
  }

  double? _getMinY() {
    if (_history.isEmpty) return null;
    double minVal = double.infinity;
    for (final point in _history) {
      for (final val in point) {
        if (val < minVal) minVal = val;
      }
    }
    return minVal - (minVal.abs() * 0.1 + 0.1);
  }

  double? _getMaxY() {
    if (_history.isEmpty) return null;
    double maxVal = double.negativeInfinity;
    for (final point in _history) {
      for (final val in point) {
        if (val > maxVal) maxVal = val;
      }
    }
    return maxVal + (maxVal.abs() * 0.1 + 0.1);
  }

  List<LineChartBarData> _getLineBarsData(ThemeData theme, {bool fillGradient = false}) {
    if (_history.isEmpty) return [];

    final primaryColor = theme.colorScheme.primary;
    final numLines = _currentValues.length;

    return List.generate(numLines, (lineIdx) {
      final List<FlSpot> spots = [];
      for (int i = 0; i < _history.length; i++) {
        if (lineIdx < _history[i].length) {
          spots.add(FlSpot(i.toDouble(), _history[i][lineIdx]));
        }
      }

      Color color;
      List<int>? dashArray;
      if (numLines == 3) {
        if (lineIdx == 0) {
          color = primaryColor;
          dashArray = null;
        } else if (lineIdx == 1) {
          color = primaryColor.withValues(alpha: 0.6);
          dashArray = [5, 5];
        } else {
          color = primaryColor.withValues(alpha: 0.3);
          dashArray = [2, 4];
        }
      } else {
        color = primaryColor;
        dashArray = null;
      }

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        curveSmoothness: 0.35,
        preventCurveOverShooting: true,
        barWidth: 1.5,
        color: color,
        dashArray: dashArray,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: fillGradient,
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.25),
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
