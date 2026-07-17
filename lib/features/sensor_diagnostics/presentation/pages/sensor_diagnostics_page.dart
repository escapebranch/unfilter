import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';

import '../../../../core/widgets/top_shadow_gradient.dart';
import '../../../home/presentation/widgets/premium_app_bar.dart';
import '../widgets/sensor_list_card.dart';

class SensorDiagnosticsPage extends StatefulWidget {
  const SensorDiagnosticsPage({super.key});

  @override
  State<SensorDiagnosticsPage> createState() => _SensorDiagnosticsPageState();
}

class _SensorDiagnosticsPageState extends State<SensorDiagnosticsPage> {
  static const MethodChannel _sensorsChannel = MethodChannel('com.escapebranch.unfilter/sensors');
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>>? _sensors;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSensors();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSensors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final List<dynamic>? result = await _sensorsChannel.invokeMethod<List<dynamic>>('getSensorsList');
      if (result != null) {
        setState(() {
          _sensors = result.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to retrieve sensor list: empty response';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading sensors: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 46.0 + (8.0 * 2) + MediaQuery.of(context).padding.top,
                ),
              ),
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              else if (_error != null)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: theme.colorScheme.error,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            onPressed: _loadSensors,
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(l10n.retryLabel),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (_sensors == null || _sensors!.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text('No sensors detected on this device.'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final sensor = _sensors![index];
                        return SensorListCard(sensor: sensor);
                      },
                      childCount: _sensors!.length,
                    ),
                  ),
                ),
            ],
          ),
          const TopShadowGradient(),
          PremiumAppBar(
            title: l10n.sensorDiagnosticsTitle,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}
