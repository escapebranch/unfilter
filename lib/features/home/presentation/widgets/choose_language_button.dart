import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unfilter/core/providers/locale_provider.dart';
import 'package:unfilter/features/home/presentation/widgets/dialog_header.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';

class ChooseLanguageButton extends ConsumerStatefulWidget {
  const ChooseLanguageButton({super.key});

  @override
  ConsumerState<ChooseLanguageButton> createState() => _ChooseLanguageButtonState();
}

class _ChooseLanguageButtonState extends ConsumerState<ChooseLanguageButton> {
  void _showChooseLanguageDialog() {
    final l10n = AppLocalizations.of(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.chooseLanguageDialogTitle,
      barrierColor: Colors.black.withValues(alpha: .5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return _ChooseLanguageDialog();
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showChooseLanguageDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}

class _ChooseLanguageDialog extends ConsumerStatefulWidget {
  const _ChooseLanguageDialog();

  @override
  ConsumerState<_ChooseLanguageDialog> createState() => _ChooseLanguageDialogState();
}

class _ChooseLanguageDialogState extends ConsumerState<_ChooseLanguageDialog> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    final currentLocale = ref.read(localeProvider);
    _selectedLanguageCode = currentLocale?.languageCode ?? 'en';
  }

  Widget _buildLanguageDropdown(
    ThemeData theme,
    bool isDark,
    List<DropdownMenuEntry<String>> dropdownMenuEntries,
  ) {
    return DropdownMenu<String>(
      width: 260,
      initialSelection: _selectedLanguageCode,
      dropdownMenuEntries: dropdownMenuEntries,
      onSelected: (value) {
        if (value == null) return;
        setState(() {
          _selectedLanguageCode = value;
        });
      },
      enableSearch: true,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      leadingIcon: Icon(
        Icons.language_rounded,
        color: theme.colorScheme.primary,
        size: 18,
      ),
      trailingIcon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      selectedTrailingIcon: Icon(
        Icons.keyboard_arrow_up_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.grey[800]!.withValues(alpha: 0.35)
            : Colors.grey[200]!.withValues(alpha: 0.8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.8),
            width: 1.4,
          ),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          isDark ? const Color(0xFF242424) : Colors.white,
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        elevation: const WidgetStatePropertyAll(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dropdownMenuEntries = <DropdownMenuEntry<String>>[
      DropdownMenuEntry<String>(
        value: 'en',
        label: l10n.languageEnglish,
      ),
      DropdownMenuEntry<String>(
        value: 'ta',
        label: l10n.languageTamil,
      ),
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                  icon: Icons.translate_rounded,
                  title: l10n.chooseLanguageDialogTitle,
                  subtitle: l10n.chooseLanguageDialogSubtitle,
                ),
                const SizedBox(height: 24),
                _buildLanguageDropdown(theme, isDark, dropdownMenuEntries),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: InkWell(
                    onTap: () async{
                      await ref.read(localeProvider.notifier).setLocale(_selectedLanguageCode);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        l10n.confirmButtonLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight:FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}