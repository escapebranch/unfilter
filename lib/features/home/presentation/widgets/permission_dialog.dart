import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../../l10n/generated/app_localizations.dart';

class PermissionDialog extends StatefulWidget {
  final VoidCallback onGrantPressed;

  final bool isPermanent;

  const PermissionDialog({
    super.key,
    required this.onGrantPressed,
    this.isPermanent = false,
  });

  @override
  State<PermissionDialog> createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !widget.isPermanent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            _buildBackdrop(theme),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildDialogContent(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackdrop(ThemeData theme) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(color: theme.colorScheme.scrim.withValues(alpha: 0.4)),
    );
  }

  Widget _buildDialogContent(ThemeData theme) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(theme),
          const SizedBox(height: 24),
          _buildTitle(theme),
          const SizedBox(height: 12),
          _buildDescription(theme),
          const SizedBox(height: 32),
          _buildGrantButton(theme),
          const SizedBox(height: 12),
          _buildDismissButton(theme),
        ],
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.security_update_good_rounded,
        size: 32,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    return Text(
      l10n.permissionRequiredTitle,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    return Text(
      '${l10n.permissionDescription1}${l10n.permissionDescription2}${l10n.permissionDescription3}',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGrantButton(ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          widget.onGrantPressed();
        },
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          l10n.grantAccess,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDismissButton(ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(l10n.maybeLater),
    );
  }
}
