import 'package:flutter/material.dart';
import '../../../../common/widgets/section_container.dart';
import '../../../../core/widgets/top_shadow_gradient.dart';
import '../../../home/presentation/widgets/premium_app_bar.dart';
import '../../utils/sensor_utils.dart';
import '../widgets/sensor_specs_grid.dart';
import '../widgets/sensor_stream_chart.dart';

class SensorDetailPage extends StatelessWidget {
  final Map<String, dynamic> sensor;

  const SensorDetailPage({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ScrollController scrollController = ScrollController();
    
    final int type = sensor['type'] as int? ?? -1;
    final String name = sensor['name'] as String? ?? 'Unknown Sensor';
    final String vendor = sensor['vendor'] as String? ?? 'Unknown Vendor';
    final double power = (sensor['power'] as num?)?.toDouble() ?? 0.0;
    final double resolution = (sensor['resolution'] as num?)?.toDouble() ?? 0.0;
    final double maximumRange = (sensor['maximumRange'] as num?)?.toDouble() ?? 0.0;
    final String reportingMode = sensor['reportingMode'] as String? ?? 'continuous';
    final bool isWakeUp = sensor['isWakeUp'] as bool? ?? false;
    final int minDelay = (sensor['minDelay'] as num?)?.toInt() ?? 0;
    final int fifoMaxEventCount = (sensor['fifoMaxEventCount'] as num?)?.toInt() ?? 0;
    
    final unit = getSensorUnit(type);
    final icon = getSensorIcon(type);
    final description = getSensorDescription(type);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 46.0 + (8.0 * 2) + MediaQuery.of(context).padding.top,
                ),
              ),
              // Compact Header Card
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                sliver: SliverToBoxAdapter(
                  child: _buildCompactHeaderCard(theme, icon, name, vendor, description),
                ),
              ),
              // Live Data Section Header
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'LIVE DATA STREAM',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              // Live Data Stream Widget (Tailored per SensorCategory)
              SliverToBoxAdapter(
                child: LiveSensorStreamWidget(
                  sensorType: type,
                  unit: unit,
                  sensorMetadata: sensor,
                ),
              ),
              // Hardware Specs Section Header
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HARDWARE SPECIFICATIONS',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SensorSpecsGrid(
                          power: power,
                          resolution: resolution,
                          maxRange: maximumRange,
                          typeId: type,
                          reportingMode: reportingMode,
                          isWakeUp: isWakeUp,
                          minDelay: minDelay,
                          fifoMaxEventCount: fifoMaxEventCount,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
          const TopShadowGradient(),
          PremiumAppBar(
            title: name,
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeaderCard(ThemeData theme, IconData icon, String name, String vendor, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  vendor,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

