import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/navigation/navigation.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../home/presentation/widgets/dialog_header.dart';
import '../../../../core/providers/logging_provider.dart';
import '../../../../common/widgets/snackbar_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class ReportIssueModal extends ConsumerWidget {
  const ReportIssueModal({super.key});

  static void show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.reportIssue,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return const ReportIssueModal();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5 * anim1.value,
            sigmaY: 5 * anim1.value,
          ),
          child: FadeTransition(
            opacity: anim1,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleReportBug(BuildContext context) async {
    final uri = Uri.parse('https://github.com/r4khul/unfilter/issues');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleExportLogs(BuildContext context, WidgetRef ref) async {
    try {
      final l10n = AppLocalizations.of(context);
      final loggingService = ref.read(loggingServiceProvider);
      
      final zipFile = await loggingService.exportLogs();
      
      if (context.mounted) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(zipFile.path)],
            subject: l10n.shareLogs,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.showError(context, 'Failed to export logs: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 340,
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogHeader(
                  theme: theme,
                  icon: Icons.bug_report_outlined,
                  title: l10n.reportIssue,
                  subtitle: l10n.reportIssueSubtitle,
                ),
                const SizedBox(height: 24),
                _ReportOptionTile(
                  title: l10n.reportBug,
                  description: l10n.reportBugSubtitle,
                  iconWidget: SvgPicture.asset(
                    'assets/vectors/icon_github.svg',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      isDark ? const Color(0xFF64B5F6) : const Color(0xFF1976D2),
                      BlendMode.srcIn,
                    ),
                  ),
                  color: isDark
                      ? const Color(0xFF64B5F6)
                      : const Color(0xFF1976D2),
                  onTap: () {
                    Navigator.pop(context);
                    _handleReportBug(context);
                  },
                ),
                const SizedBox(height: 12),
                _ReportOptionTile(
                  title: l10n.viewLogs,
                  description: l10n.viewLogsSubtitle,
                  icon: Icons.article_outlined,
                  color: isDark
                      ? const Color(0xFF81C784)
                      : const Color(0xFF388E3C),
                  onTap: () {
                    Navigator.pop(context);
                    AppRouteFactory.toLogs(context);
                  },
                ),
                const SizedBox(height: 12),
                _ReportOptionTile(
                  title: l10n.exportLogs,
                  description: l10n.exportLogsSubtitle,
                  icon: Icons.folder_zip_outlined,
                  color: isDark
                      ? const Color(0xFFFFB74D)
                      : const Color(0xFFF57C00),
                  onTap: () {
                    Navigator.pop(context);
                    _handleExportLogs(context, ref);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportOptionTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final Widget? iconWidget;
  final Color color;
  final VoidCallback onTap;

  const _ReportOptionTile({
    required this.title,
    required this.description,
    this.icon,
    this.iconWidget,
    required this.color,
    required this.onTap,
  }) : assert(icon != null || iconWidget != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: iconWidget ?? Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
