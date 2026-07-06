library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../../../domain/entities/device_app.dart';
import 'common_widgets.dart';
import 'constants.dart';

class AppInfoSection extends StatelessWidget {
  final DeviceApp app;

  const AppInfoSection({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.appDetailsTitle),
        const SizedBox(height: AppDetailsSpacing.standard),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDetailsSpacing.lg,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDetailsBorderRadius.xl),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(
                alpha: AppDetailsOpacity.mediumLight,
              ),
            ),
          ),
          child: Column(
            children: [
              DetailItem(
                label: l10n.packageLabel,
                value: app.packageName,
                showDivider: true,
              ),
              DetailItem(
                label: l10n.uidLabel,
                value: app.uid.toString(),
                showDivider: true,
              ),
              DetailItem(
                label: l10n.installDateLabel,
                value: DateFormat.yMMMd().format(app.installDate),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
