import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/providers/logging_provider.dart';
import '../../../../core/services/logging_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../common/widgets/snackbar_utils.dart';

class ViewLogsPage extends ConsumerStatefulWidget {
  const ViewLogsPage({super.key});

  @override
  ConsumerState<ViewLogsPage> createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends ConsumerState<ViewLogsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;
  final Set<int> _selectedIndices = {};
  bool _isSelectionMode = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_autoScroll && _scrollController.hasClients && !_isSelectionMode) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedIndices.add(index);
        _isSelectionMode = true;
      }
    });
  }

  void _copySelectedLogs(List<LogEntry> logs) {
    final sortedIndices = _selectedIndices.toList()..sort();
    final selectedLogsText = sortedIndices.map((i) => logs[i].toString()).join('\n');
    
    Clipboard.setData(ClipboardData(text: selectedLogsText));
    setState(() {
      _selectedIndices.clear();
      _isSelectionMode = false;
    });
    SnackBarUtils.showSuccess(context, 'Selected logs copied to clipboard');
  }

  Future<void> _handleReportBug() async {
    final uri = Uri.parse('https://github.com/r4khul/unfilter/issues');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleExportLogs() async {
    try {
      final l10n = AppLocalizations.of(context);
      final loggingService = ref.read(loggingServiceProvider);
      
      final zipFile = await loggingService.exportLogs();
      
      if (mounted) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(zipFile.path)],
            subject: l10n.shareLogs,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Failed to export logs: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final logsAsync = ref.watch(logsProvider);

    // Auto-scroll when new logs arrive
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSelectionMode ? '${_selectedIndices.length} Selected' : l10n.logsTitle,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontFamily: 'UncutSans',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => setState(() {
                  _selectedIndices.clear();
                  _isSelectionMode = false;
                }),
              )
            : const BackButton(),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.copy_all_rounded, size: 20),
              onPressed: () {
                logsAsync.whenData((logs) => _copySelectedLogs(logs));
              },
              tooltip: 'Copy Selected',
            )
          else ...[
            IconButton(
              icon: Icon(
                _autoScroll ? Icons.unfold_more_rounded : Icons.unfold_less_rounded,
                size: 20,
              ),
              onPressed: () => setState(() => _autoScroll = !_autoScroll),
              tooltip: _autoScroll ? 'Disable Auto-scroll' : 'Enable Auto-scroll',
            ),
            PopupMenuButton<String>(
              iconSize: 20,
              onSelected: (value) {
                switch (value) {
                  case 'report':
                    _handleReportBug();
                    break;
                  case 'export':
                    _handleExportLogs();
                    break;
                  case 'clear':
                    ref.read(loggingServiceProvider).clearLogs();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      const Icon(Icons.bug_report_outlined, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.reportBug),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      const Icon(Icons.folder_zip_outlined, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.exportLogs),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Clear Logs',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No logs yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final isSelected = _selectedIndices.contains(index);
              
              return _LogTile(
                log: log,
                isSelected: isSelected,
                isSelectionMode: _isSelectionMode,
                onTap: () {
                  if (_isSelectionMode) {
                    _toggleSelection(index);
                  }
                },
                onLongPress: () => _toggleSelection(index),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final LogEntry log;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _LogTile({
    required this.log,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  Color? _getLogColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (log.level == 'ERROR') {
      return isDark ? Colors.redAccent[100] : Colors.red[700];
    } else if (log.level == 'DEBUG') {
      return isDark ? Colors.blueAccent[100] : Colors.blue[700];
    } else if (log.level == 'INFO') {
      return isDark ? Colors.greenAccent[100] : Colors.green[700];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logColor = _getLogColor(context);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelectionMode) ...[
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              '[${log.formattedTimestamp}] ',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
            Expanded(
              child: Text(
                log.message,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: logColor ?? theme.colorScheme.onSurface,
                  fontSize: 11,
                  fontWeight: log.level == 'ERROR' ? FontWeight.bold : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
