import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/widgets/top_shadow_gradient.dart';
import '../../widgets/premium_app_bar.dart';

class DeeplinkTesterPage extends StatefulWidget {
  const DeeplinkTesterPage({super.key});

  @override
  State<DeeplinkTesterPage> createState() => _DeeplinkTesterPageState();
}

class _DeeplinkTesterPageState extends State<DeeplinkTesterPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  Uri? _parsedUri;
  bool? _canLaunch;
  bool? _didLaunch;
  String _statusMessage = 'Enter a deeplink to test it.';

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _testDeeplink() async {
    final raw = _controller.text.trim();

    if (raw.isEmpty) {
      setState(() {
        _parsedUri = null;
        _canLaunch = false;
        _didLaunch = false;
        _statusMessage = 'Please enter a deeplink URI.';
      });
      return;
    }

    final uri = Uri.tryParse(raw);
    if (uri == null || uri.scheme.isEmpty) {
      setState(() {
        _parsedUri = null;
        _canLaunch = false;
        _didLaunch = false;
        _statusMessage = 'Invalid deeplink. Include a valid URI scheme.';
      });
      return;
    }

    final canLaunch = await canLaunchUrl(uri);
    var didLaunch = false;
    var status = canLaunch
        ? 'Deep link can be handled on this device.'
        : 'No app can handle this deep link right now.';

    if (canLaunch) {
      try {
        didLaunch = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (didLaunch) {
          status = 'Deep link launched successfully.';
        } else {
          status = 'Deep link was recognized but failed to launch.';
        }
      } catch (_) {
        didLaunch = false;
        status = 'Failed to launch deep link.';
      }
    }

    if (!mounted) return;

    setState(() {
      _parsedUri = uri;
      _canLaunch = canLaunch;
      _didLaunch = didLaunch;
      _statusMessage = status;
    });
  }

  void _fillExample() {
    setState(() {
      _controller.text = 'mailto:hello@example.com?subject=Deep%20Link%20Test';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntro(theme),
                      const SizedBox(height: 20),
                      _buildInputCard(theme),
                      const SizedBox(height: 16),
                      _buildStatusCard(theme),
                      const SizedBox(height: 16),
                      _buildParsedDetailsCard(theme),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const TopShadowGradient(),
          PremiumAppBar(
            title: 'Deep Link Tester',
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }

  Widget _buildIntro(ThemeData theme) {
    return Text(
      'Paste a deeplink, test whether your device can resolve it, and inspect how the URI is parsed.',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        height: 1.5,
      ),
    );
  }

  Widget _buildInputCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deep Link URI',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'myapp://screen/path?from=test',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.25,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.7),
                ),
              ),
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _testDeeplink(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _testDeeplink,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Test Deeplink'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _fillExample,
                icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                label: const Text('Example'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    final statusIcon = (_didLaunch == true)
        ? Icons.check_circle_rounded
        : (_canLaunch == false)
            ? Icons.error_outline_rounded
            : Icons.info_outline_rounded;

    final statusColor = (_didLaunch == true)
        ? theme.colorScheme.primary
        : (_canLaunch == false)
            ? theme.colorScheme.error
            : theme.colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(statusIcon, size: 22, color: statusColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _statusMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParsedDetailsCard(ThemeData theme) {
    if (_parsedUri == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Text(
          'URI breakdown will appear here after testing.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final uri = _parsedUri!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parsed URI Details',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(theme, 'Scheme', uri.scheme),
          _buildDetailRow(theme, 'Host', uri.host.isEmpty ? '-' : uri.host),
          _buildDetailRow(theme, 'Path', uri.path.isEmpty ? '/' : uri.path),
          _buildDetailRow(
            theme,
            'Query Params',
            '${uri.queryParameters.length}',
          ),
          _buildDetailRow(
            theme,
            'Fragment',
            uri.fragment.isEmpty ? '-' : uri.fragment,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
