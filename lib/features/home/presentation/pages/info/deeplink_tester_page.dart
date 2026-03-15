import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Note: Ensure these paths match your project structure
import '../../../../../core/widgets/top_shadow_gradient.dart';
import '../../widgets/premium_app_bar.dart';
import '../../../../apps/presentation/widgets/app_details/premium_modal_header.dart';

class DeeplinkTesterPage extends StatefulWidget {
  const DeeplinkTesterPage({super.key});

  @override
  State<DeeplinkTesterPage> createState() => _DeeplinkTesterPageState();
}

class _DeeplinkTesterPageState extends State<DeeplinkTesterPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _fullUrlController = TextEditingController();
  final TextEditingController _schemeController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _fragmentController = TextEditingController();

  Uri? _parsedUri;
  bool? _canLaunch;
  bool? _didLaunch;
  String _statusMessage = 'Enter a deeplink to test it.';

  @override
  void dispose() {
    _scrollController.dispose();
    _fullUrlController.dispose();
    _schemeController.dispose();
    _hostController.dispose();
    _pathController.dispose();
    _queryController.dispose();
    _fragmentController.dispose();
    super.dispose();
  }

  void _parseFullUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri != null && uri.scheme.isNotEmpty) {
      setState(() {
        _schemeController.text = uri.scheme;
        _hostController.text = uri.host;
        _pathController.text = uri.path;
        _queryController.text = uri.query;
        _fragmentController.text = uri.fragment;
      });
    }
  }

  void _clearAll() {
    _fullUrlController.clear();
    _schemeController.clear();
    _hostController.clear();
    _pathController.clear();
    _queryController.clear();
    _fragmentController.clear();
    setState(() {
      _parsedUri = null;
      _canLaunch = null;
      _didLaunch = null;
      _statusMessage = 'Enter a deeplink to test it.';
    });
  }

  String _buildFullUrl() {
    final scheme = _schemeController.text.trim();
    final host = _hostController.text.trim();
    final path = _pathController.text.trim();
    final query = _queryController.text.trim();
    final fragment = _fragmentController.text.trim();

    if (scheme.isEmpty) return '';

    try {
      // Use Uri class to construct valid formatting.
      // If there's no host (opaque URI like mailto:, tel:, sms:),
      // do not prepend a leading '/'. Otherwise, ensure path starts with '/'.
      String? uriPath;
      if (host.isEmpty) {
        uriPath = path.isEmpty
            ? null
            : (path.startsWith('/') ? path.substring(1) : path);
      } else {
        uriPath = path.isEmpty
            ? null
            : (path.startsWith('/') ? path : '/$path');
      }

      final uri = Uri(
        scheme: scheme,
        host: host.isEmpty ? null : host,
        path: uriPath,
        query: query.isEmpty ? null : query,
        fragment: fragment.isEmpty ? null : fragment,
      );
      return uri.toString();
    } catch (e) {
      return '';
    }
  }

  Future<void> _testDeeplink() async {
    final url = _buildFullUrl();
    if (url.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter at least a scheme.';
      });
      return;
    }

    final uri = Uri.tryParse(url);
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

  void _applyExampleLink(String link) {
    _fullUrlController.text = link;
    _parseFullUrl(link);
    Navigator.pop(context);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

  Widget _buildInputCard(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final fullUrl = _buildFullUrl();

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
          Row(
            children: [
              Text(
                'Deep Link Components',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (_schemeController.text.isNotEmpty ||
                  _hostController.text.isNotEmpty ||
                  _fullUrlController.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.clear_rounded,
                          size: 14,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Clear',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.25,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                controller: _fullUrlController,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  hintText: 'Paste full URL here (e.g., myapp://host/path)',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    fontFamily: null,
                  ),
                  prefixIcon: Icon(
                    Icons.content_paste_rounded,
                    size: 20,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  suffixIcon: _fullUrlController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            _parseFullUrl(_fullUrlController.text);
                            _fullUrlController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onChanged: (value) => setState(() {}),
                onSubmitted: (value) {
                  _parseFullUrl(value);
                  _fullUrlController.clear();
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Paste full URL above to auto-fill fields',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          _buildTableField(
            theme: theme,
            label: 'Scheme',
            controller: _schemeController,
            hint: 'e.g. mailto, https',
            icon: Icons.link_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Host',
            controller: _hostController,
            hint: 'e.g. example.com',
            icon: Icons.dns_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Path',
            controller: _pathController,
            hint: 'e.g. /profile',
            icon: Icons.folder_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Query',
            controller: _queryController,
            hint: 'e.g. id=123',
            icon: Icons.help_outline_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Fragment',
            controller: _fragmentController,
            hint: 'e.g. section1',
            icon: Icons.tag_rounded,
          ),
          if (fullUrl.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fullUrl,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _testDeeplink,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[800]!.withValues(alpha: 0.8)
                    : Colors.grey[200]!.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Test Deeplink',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showExampleBottomSheet(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Try Examples',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExampleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (_, controller) {
          final theme = Theme.of(context);
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                PremiumModalHeader(
                  title: "Deep Link Examples",
                  icon: Icons.code_rounded,
                  onClose: () => Navigator.pop(context),
                ),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    children: [
                      _buildDeepLinkCard(
                        context,
                        title: "Compose Email",
                        link: "mailto:user@example.com?subject=Hello",
                        icon: Icons.email_rounded,
                        cardColor: Colors.blueAccent,
                        onUseExample: _applyExampleLink,
                      ),
                      const SizedBox(height: 12),
                      _buildDeepLinkCard(
                        context,
                        title: "Phone Call",
                        link: "tel:+1234567890",
                        icon: Icons.phone_rounded,
                        cardColor: Colors.green,
                        onUseExample: _applyExampleLink,
                      ),
                      const SizedBox(height: 12),
                      _buildDeepLinkCard(
                        context,
                        title: "Send SMS",
                        link: "sms:+1234567890?body=Hi",
                        icon: Icons.message_rounded,
                        cardColor: Colors.orange,
                        onUseExample: _applyExampleLink,
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'More configurations coming soon!',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeepLinkCard(
    BuildContext context, {
    required String title,
    required String link,
    required IconData icon,
    required Color cardColor,
    required Function(String) onUseExample,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: cardColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  link,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onUseExample(link),
            icon: Icon(
              Icons.subdirectory_arrow_left_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableField({
    required ThemeData theme,
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.25,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: TextField(
              controller: controller,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.primary.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ],
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
        children: [
          Icon(statusIcon, size: 22, color: statusColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_statusMessage, style: theme.textTheme.bodyMedium),
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
          style: theme.textTheme.bodyMedium,
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
          if (uri.query.isNotEmpty) _buildDetailRow(theme, 'Query', uri.query),
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
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
