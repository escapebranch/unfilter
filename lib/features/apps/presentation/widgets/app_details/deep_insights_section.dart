library;

import 'package:flutter/material.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../../../domain/entities/device_app.dart';
import 'common_widgets.dart';
import 'constants.dart';
import 'utils.dart';

class DeepInsightsSection extends StatelessWidget {
  final DeviceApp app;

  const DeepInsightsSection({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.deepInsightsTitle),
        const SizedBox(height: AppDetailsSpacing.standard),
        Container(
          padding: const EdgeInsets.all(AppDetailsSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDetailsBorderRadius.xl),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 
                AppDetailsOpacity.mediumLight,
              ),
            ),
          ),
          child: Column(
            children: [
              ..._buildDetailItems(l10n),
              const SizedBox(height: AppDetailsSpacing.xl),
              _buildComponentCounts(theme, l10n),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailItems(AppLocalizations l10n) {
    final items = <Widget>[];

    if (app.installerStore != 'Unknown') {
      items.add(
        DetailItem(
          label: l10n.installerLabel,
          value: formatInstallerName(app.installerStore),
          showDivider: true,
        ),
      );
    }

    if (app.techVersions.isNotEmpty) {
      for (final entry in app.techVersions.entries) {
        items.add(
          DetailItem(
            label: l10n.techVersionLabel(entry.key),
            value: entry.value,
            showDivider: true,
          ),
        );
      }
    }

    if (app.kotlinVersion != null && !app.techVersions.containsKey('Kotlin')) {
      items.add(
        DetailItem(
          label: l10n.kotlinVersionLabel,
          value: app.kotlinVersion!,
          showDivider: true,
        ),
      );
    }

    items.add(
      DetailItem(
        label: l10n.minSdkLabel,
        value: "${app.minSdkVersion} (${getSdkVersionName(app.minSdkVersion)})",
        showDivider: true,
      ),
    );

    items.add(
      DetailItem(
        label: l10n.targetSdkLabel,
        value:
            "${app.targetSdkVersion} (${getSdkVersionName(app.targetSdkVersion)})",
        showDivider: true,
      ),
    );

    if (app.signingSha1 != null) {
      items.add(
        DetailItem(
          label: l10n.signatureSha1Label,
          value: app.signingSha1!,
          showDivider: true,
        ),
      );
    }

    if (app.splitApks.isNotEmpty) {
      items.add(
        DetailItem(
          label: l10n.splitApksLabel,
          value: l10n.splitApksValue(app.splitApks.length),
          showDivider: true,
        ),
      );
    }

    items.add(
      DetailItem(
        label: l10n.appSizeLabel,
        value: formatBytes(app.size),
        showDivider: true,
      ),
    );

    items.add(
      DetailItem(label: l10n.apkPathLabel, value: app.apkPath, showDivider: true),
    );

    items.add(DetailItem(label: l10n.dataDirLabel, value: app.dataDir));

    return items;
  }

  Widget _buildComponentCounts(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            _ComponentCount(label: l10n.activitiesLabel, count: app.activitiesCount),
            const SizedBox(width: AppDetailsSpacing.md),
            _ComponentCount(label: l10n.servicesLabel, count: app.servicesCount),
          ],
        ),
        const SizedBox(height: AppDetailsSpacing.md),
        Row(
          children: [
            _ComponentCount(label: l10n.receiversLabel, count: app.receiversCount),
            const SizedBox(width: AppDetailsSpacing.md),
            _ComponentCount(label: l10n.providersLabel, count: app.providersCount),
          ],
        ),
      ],
    );
  }
}

class _ComponentCount extends StatelessWidget {
  final String label;
  final int count;

  const _ComponentCount({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDetailsSpacing.standard,
          horizontal: AppDetailsSpacing.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 
            AppDetailsOpacity.standard,
          ),
          borderRadius: BorderRadius.circular(AppDetailsBorderRadius.md),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDetailsSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
