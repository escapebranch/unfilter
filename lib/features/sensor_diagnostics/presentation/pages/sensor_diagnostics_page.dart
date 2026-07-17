import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unfilter/features/sensor_diagnostics/utils/sensor_utils.dart';
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
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>>? _allSensors;
  String _searchQuery = '';
  SensorCategory? _selectedCategory;
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
    _searchController.dispose();
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
          _allSensors = result.map((e) => Map<String, dynamic>.from(e as Map)).toList();
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

  List<Map<String, dynamic>> get _filteredSensors {
    if (_allSensors == null) return [];
    return _allSensors!.where((sensor) {
      final type = sensor['type'] as int? ?? -1;
      final name = (sensor['name'] as String? ?? '').toLowerCase();
      final vendor = (sensor['vendor'] as String? ?? '').toLowerCase();

      final matchesQuery = _searchQuery.isEmpty ||
          name.contains(_searchQuery.toLowerCase()) ||
          vendor.contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == null || getSensorCategory(type) == _selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();
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
              else ...[
                // Search & Category Filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Column(
                      children: [
                        // Search Input Field
                        TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search hardware sensors...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Category Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildCategoryChip(theme, 'All (${_allSensors?.length ?? 0})', null),
                              _buildCategoryChip(theme, '3D Motion', SensorCategory.motion3D),
                              _buildCategoryChip(theme, 'Environment', SensorCategory.environment1D),
                              _buildCategoryChip(theme, 'Pedometer', SensorCategory.pedometer),
                              _buildCategoryChip(theme, 'Proximity', SensorCategory.proximity),
                              _buildCategoryChip(theme, 'Orientation', SensorCategory.orientation),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_filteredSensors.isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(theme),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final sensor = _filteredSensors[index];
                          return SensorListCard(sensor: sensor);
                        },
                        childCount: _filteredSensors.length,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          const TopShadowGradient(),
          PremiumAppBar(
            title: l10n.sensorDiagnosticsTitle,
            scrollController: _scrollController,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'BETA',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(ThemeData theme, String label, SensorCategory? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = isSelected ? null : category;
          });
        },
        selectedColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        checkmarkColor: theme.colorScheme.primary,
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sensors_off_rounded,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No matching sensors found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search query or category filters.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

