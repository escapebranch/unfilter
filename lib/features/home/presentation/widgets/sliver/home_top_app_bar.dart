import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';

import '../../providers/smart_scan_hint_provider.dart';
import '../scan_button.dart';
import '../settings_menu.dart';
import '../smart_scan_popover.dart';

class HomeTopAppBar extends ConsumerWidget {
  final int appCount;

  final double transitionProgress;

  const HomeTopAppBar({
    super.key,
    required this.appCount,
    required this.transitionProgress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final showSmartScanHint = ref.watch(smartScanHintProvider);

    return SafeArea(
      bottom: false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _buildTitleLogoTransition(context, theme)),
                const ScanButton(),
                const SizedBox(width: 4),
                const SettingsMenu(),
              ],
            ),
          ),
          if (showSmartScanHint)
            Positioned(
              top: 48,
              right: 20,
              child: TapRegion(
                groupId: 'smart_scan_popover',
                onTapOutside: (_) {
                  ref.read(smartScanHintProvider.notifier).dismiss();
                },
                child: RepaintBoundary(
                  child: SmartScanPopover(
                    pointerOffsetFromRight: _calculatePointerOffset(context),
                    onTap: () {
                      ref.read(smartScanHintProvider.notifier).dismiss();
                      ScanButton.showScanOptions(context, ref);
                    },
                    onDismiss: () {
                      ref.read(smartScanHintProvider.notifier).dismiss();
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _calculatePointerOffset(BuildContext context) {
    try {
      final renderBox = ScanButton.scanButtonKey.currentContext?.findRenderObject()
          as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final buttonPosition = renderBox.localToGlobal(Offset.zero);
        final scanButtonCenterX = buttonPosition.dx + (renderBox.size.width / 2);
        final screenWidth = MediaQuery.of(context).size.width;
        final popoverRightX = screenWidth - 20.0;
        final offset = popoverRightX - scanButtonCenterX;
        return offset.clamp(16.0, 180.0);
      }
    } catch (_) {
      // Fallback to static offset if render box is not ready
    }
    return 48.0;
  }

  Widget _buildTitleLogoTransition(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Transform.translate(
          offset: Offset(0, -10 * transitionProgress),
          child: Opacity(
            opacity: (1 - transitionProgress).clamp(0.0, 1.0),
            child: Text(
              l10n.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Transform.translate(
          offset: Offset(0, 10 * (1 - transitionProgress)),
          child: Opacity(
            opacity: transitionProgress.clamp(0.0, 1.0),
            child: Row(
              children: [
                _buildLogoIcon(theme, isDark),
                const SizedBox(width: 8),
                _buildAppCountBadge(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoIcon(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.onSurface),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(
        isDark
            ? 'assets/icons/white-unfilter-nobg.png'
            : 'assets/icons/black-unfilter-nobg.png',
        height: 20,
        cacheHeight: 60, // Optimize load dimensions 
      ),
    );
  }

  Widget _buildAppCountBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.install_mobile,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '$appCount',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
