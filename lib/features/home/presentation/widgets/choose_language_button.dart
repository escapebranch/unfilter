import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/navigation/navigation.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'drawer/drawer_nav_tile.dart';

class ChooseLanguageButton extends ConsumerWidget {
  const ChooseLanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DrawerNavTile(
      title: l10n.chooseLanguageDialogTitle,
      subtitle: l10n.chooseLanguageDialogSubtitle,
      icon: Icons.translate_rounded,
      onTap: () {
        Navigator.pop(context);
        AppRouteFactory.toLanguage(context);
      },
    );
  }
}
