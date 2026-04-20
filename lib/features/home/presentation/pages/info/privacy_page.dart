import 'package:flutter/material.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';

import '../../widgets/external_link_tile.dart';
import '../../widgets/github_cta_card.dart';
import '../../widgets/premium_app_bar.dart';
import '../../../../../core/widgets/top_shadow_gradient.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(theme),
                      const SizedBox(height: 16),
                      _buildIntroText(theme),
                      const SizedBox(height: 24),
                      ExternalLinkTile(
                        label: l10n.privacyPolicyTitle,
                        value: l10n.commonOpenLabel,
                        url: 'https://unfilter-web.vercel.app/privacy',
                      ),
                      ExternalLinkTile(
                        label: l10n.privacyTermsAndConditionsTitle,
                        value: l10n.commonOpenLabel,
                        url: 'https://unfilter-web.vercel.app/terms',
                      ),
                      const SizedBox(height: 48),
                      _PolicySection(
                        title: l10n.privacySectionLocalProcessingTitle,
                        content: l10n.privacySectionLocalProcessingContent,
                        icon: Icons.phonelink_lock_rounded,
                      ),
                      _PolicySection(
                        title: l10n.privacySectionMinimalPermissionsTitle,
                        content: l10n.privacySectionMinimalPermissionsContent,
                        icon: Icons.verified_user_rounded,
                      ),
                      _PolicySection(
                        title: l10n.privacySectionNoTrackingTitle,
                        content: l10n.privacySectionNoTrackingContent,
                        icon: Icons.do_not_disturb_on_rounded,
                      ),
                      _PolicySection(
                        title: l10n.privacySectionLimitedNetworkingTitle,
                        content: l10n.privacySectionLimitedNetworkingContent,
                        icon: Icons.wifi_rounded,
                      ),
                      const SizedBox(height: 20),
                      const GithubCtaCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const TopShadowGradient(),
          PremiumAppBar(
            title: l10n.privacyPolicyTitle,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.privacyHeader,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -1.0,
      ),
    );
  }

  Widget _buildIntroText(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.privacyIntro,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        height: 1.6,
        fontSize: 16,
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _PolicySection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconContainer(theme),
          const SizedBox(width: 20),
          Expanded(child: _buildContent(theme)),
        ],
      ),
    );
  }

  Widget _buildIconContainer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Icon(icon, color: theme.colorScheme.primary, size: 24),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
