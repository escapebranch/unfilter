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
      _schemeController.text = uri.scheme;
      _hostController.text = uri.host;
      _pathController.text = uri.path;
      _queryController.text = uri.query;
      _fragmentController.text = uri.fragment;
      setState(() {});
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

    if (scheme.isEmpty && host.isEmpty) return '';

    final buffer = StringBuffer();
    if (scheme.isNotEmpty) {
      buffer.write(scheme);
      if (!scheme.endsWith('://')) {
        buffer.write('://');
      }
    }
    if (host.isNotEmpty) {
      buffer.write(host);
    }
    if (path.isNotEmpty) {
      if (!path.startsWith('/')) {
        buffer.write('/');
      }
      buffer.write(path);
    }
    if (query.isNotEmpty) {
      buffer.write('?');
      buffer.write(query);
    }
    if (fragment.isNotEmpty) {
      buffer.write('#');
      buffer.write(fragment);
    }
    return buffer.toString();
  }

  Future<void> _testDeeplink() async {
    final url = _buildFullUrl();

    if (url.isEmpty) {
      setState(() {
        _parsedUri = null;
        _canLaunch = false;
        _didLaunch = false;
        _statusMessage = 'Please enter a deeplink URI.';
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
      'Test whether your device can resolve a deep link, and inspect how the URI is parsed.',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        height: 1.5,
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
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                prefixIcon: Icon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.primary.withValues(alpha: 0.7),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.url,
            ),
          ),
        ),
      ],
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
            child: TextField(
              controller: _fullUrlController,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                hintText:
                    'Paste full URL here (e.g., myapp://host/path?query=value)',
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
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
          const SizedBox(height: 8),
          Text(
            'Paste a full URL above to auto-fill the fields below',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          _buildTableField(
            theme: theme,
            label: 'Scheme',
            controller: _schemeController,
            hint: 'e.g. myapp, https, mailto',
            icon: Icons.link_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Host',
            controller: _hostController,
            hint: 'e.g. example.com, screen',
            icon: Icons.dns_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Path',
            controller: _pathController,
            hint: 'e.g. /home/profile',
            icon: Icons.folder_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Query',
            controller: _queryController,
            hint: 'e.g. id=123&type=test',
            icon: Icons.help_outline_rounded,
          ),
          const SizedBox(height: 12),
          _buildTableField(
            theme: theme,
            label: 'Fragment',
            controller: _fragmentController,
            hint: 'e.g. section',
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
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
          if (uri.query.isNotEmpty) _buildDetailRow(theme, 'Query', uri.query),
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
