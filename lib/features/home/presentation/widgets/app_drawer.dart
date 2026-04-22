import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';

import '../../../../core/navigation/navigation.dart';
import '../../../update/presentation/providers/update_provider.dart';
import '../../../update/domain/update_service.dart';
import 'drawer/drawer_header.dart';
import 'drawer/drawer_section_header.dart';
import 'drawer/drawer_nav_tile.dart';
import 'drawer/drawer_theme_switcher.dart';
import 'drawer/drawer_open_source_card.dart';
import 'drawer/drawer_sponsor_card.dart';
import 'drawer/drawer_contributors_card.dart';
import 'choose_language_button.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  static const double _maxWidth = 400.0;

  static const double _widthFactor = 0.85;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth > _maxWidth
        ? _maxWidth
        : screenWidth * _widthFactor;

    return Drawer(
      width: drawerWidth,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const AppDrawerHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawerSectionHeader(title: l10n.drawerAppearance),
                    const SizedBox(height: 8),
                    const DrawerThemeSwitcher(),
                    const SizedBox(height: 12),
                    const ChooseLanguageButton(),
                    const SizedBox(height: 32),
                    _buildInsightsSection(context, l10n), 
                    const SizedBox(height: 24),
                    _buildToolsSection(context, l10n),
                    const SizedBox(height: 24),
                    _buildInformationSection(context, ref, l10n),
                    const SizedBox(height: 32),
                    DrawerSectionHeader(title: l10n.drawerCommunity),
                    const SizedBox(height: 12),
                    const DrawerOpenSourceCard(),
                    const SizedBox(height: 12),
                    DrawerSponsorCard(
                      onViewSponsors: () {
                        Navigator.pop(context);
                        AppRouteFactory.toSponsors(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    DrawerContributorsCard(
                      onViewContributors: () {
                        Navigator.pop(context);
                        AppRouteFactory.toContributors(context);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerSectionHeader(title: l10n.drawerInsights),
        const SizedBox(height: 12),
        DrawerNavTile(
          title: l10n.usageStatisticsTitle,
          subtitle: l10n.usageStatisticsSubtitle,
          icon: Icons.pie_chart_outline,
          onTap: () {
            Navigator.pop(context);
            AppRouteFactory.toAnalytics(context);
          },
        ),
        DrawerNavTile(
          title: l10n.storageInsightsTitle,
          subtitle: l10n.storageInsightsSubtitle,
          icon: Icons.sd_storage_rounded,
          onTap: () {
            Navigator.pop(context);
            AppRouteFactory.toStorageInsights(context);
          },
        ),
        DrawerNavTile(
          title: l10n.taskManagerTitle,
          subtitle: l10n.taskManagerSubtitle,
          icon: Icons.memory_rounded,
          onTap: () {
            Navigator.pop(context);
            AppRouteFactory.toTaskManager(context);
          },
        ),
      ],
    );
  }

  Widget _buildToolsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerSectionHeader(title: l10n.drawerTools),
        const SizedBox(height: 12),
        DrawerNavTile(
          title: l10n.deeplinkTesterTitle,
          subtitle: l10n.deeplinkTesterSubtitle,
          icon: Icons.link_rounded,
          onTap: () {
            Navigator.pop(context);
            AppRouteFactory.toDeeplinkTester(context);
          },
        ),
      ],
    );
  }

  Widget _buildInformationSection(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerSectionHeader(title: l10n.drawerInformation),
        const SizedBox(height: 12),
        DrawerNavTile(
          title: l10n.privacySecurityTitle,
          subtitle: l10n.privacySecuritySubtitle,
          icon: Icons.shield_outlined,
          onTap: () {
            Navigator.pop(context);
            AppRouteFactory.toPrivacy(context);
          },
        ),
        _buildUpdateCheckTile(context, ref),
        _buildAboutTile(context, ref, l10n),
        const SizedBox(height: 8),
        _buildReportIssueButton(context, l10n),
      ],
    );
  }

  Widget _buildUpdateCheckTile(BuildContext context, WidgetRef ref) {
    // Temporarily hide update check menu entry (out of scope).
    // Keeping the original implementation in source history but
    // returning an empty widget so it's not visible or callable.
    return const SizedBox.shrink();
  }

  Widget _buildAboutTile(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final versionAsync = ref.watch(currentVersionProvider);
    final updateAsync = ref.watch(updateCheckProvider);
    final isUpdateAvailable =
        updateAsync.asData?.value.status == UpdateStatus.softUpdate;

    return DrawerNavTile(
      title: l10n.drawerAbout,
      subtitle: versionAsync.when(
        data: (v) => 'v${v.toString()}${isUpdateAvailable ? l10n.updateAvailableBadge : ''}',
        loading: () => l10n.checkingVersion,
        error: (_, _) => l10n.versionUnknown,
      ),
      icon: Icons.info_outline,
      onTap: () {
        Navigator.pop(context);
        AppRouteFactory.toAbout(context);
      },
    );
  }

  Widget _buildReportIssueButton(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
          final uri = Uri.parse('https://github.com/r4khul/unfilter/issues');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(16),
        overlayColor: WidgetStateProperty.all(
          theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bug_report_outlined,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.reportIssue,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.open_in_new_rounded,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
