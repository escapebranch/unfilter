import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';

class SmartScanPopover extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final double pointerOffsetFromRight;

  const SmartScanPopover({
    super.key,
    required this.onTap,
    required this.onDismiss,
    this.pointerOffsetFromRight = 48.0,
  });

  @override
  State<SmartScanPopover> createState() => _SmartScanPopoverState();
}

class _SmartScanPopoverState extends State<SmartScanPopover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  static const double _pointerWidth = 12.0;
  static const double _pointerHeight = 6.0;
  static const double _borderRadius = 14.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleDismiss() async {
    await _animController.reverse();
    widget.onDismiss();
  }

  void _handleTap() async {
    await _animController.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final popoverColor = isDark
        ? const Color(0xFF1E1E1E).withValues(alpha: 0.96)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.96);
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.12);

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        alignment: Alignment.topRight,
        child: Material(
          color: Colors.transparent,
          child: CustomPaint(
            painter: _UnifiedPopoverPainter(
              color: popoverColor,
              borderColor: borderColor,
              pointerOffsetFromRight: widget.pointerOffsetFromRight,
              pointerWidth: _pointerWidth,
              pointerHeight: _pointerHeight,
              borderRadius: _borderRadius,
              isDark: isDark,
            ),
            child: ClipPath(
              clipper: _UnifiedPopoverClipper(
                pointerOffsetFromRight: widget.pointerOffsetFromRight,
                pointerWidth: _pointerWidth,
                pointerHeight: _pointerHeight,
                borderRadius: _borderRadius,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: InkWell(
                  onTap: _handleTap,
                  splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                  highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      10,
                      6 + _pointerHeight,
                      8,
                      6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 13,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.smartScanHintTitle,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: -0.2,
                              ),
                            ),
                            Text(
                              l10n.smartScanHintSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10.5,
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _handleDismiss,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Path _buildUnifiedPopoverPath(
  Size size,
  double pointerOffsetFromRight,
  double pointerWidth,
  double pointerHeight,
  double borderRadius,
) {
  final path = Path();
  final topY = pointerHeight;
  final bodyBottom = size.height;
  final rightX = size.width;
  final leftX = 0.0;
  final r = borderRadius.clamp(0.0, (size.height - pointerHeight) / 2);

  final pointerX = (size.width - pointerOffsetFromRight).clamp(
    r + pointerWidth / 2,
    rightX - r - pointerWidth / 2,
  );
  final pLeftX = pointerX - pointerWidth / 2;
  final pRightX = pointerX + pointerWidth / 2;

  path.moveTo(leftX + r, topY);
  path.lineTo(pLeftX, topY);
  path.lineTo(pointerX, 0);
  path.lineTo(pRightX, topY);
  path.lineTo(rightX - r, topY);
  path.arcToPoint(Offset(rightX, topY + r), radius: Radius.circular(r));
  path.lineTo(rightX, bodyBottom - r);
  path.arcToPoint(Offset(rightX - r, bodyBottom), radius: Radius.circular(r));
  path.lineTo(leftX + r, bodyBottom);
  path.arcToPoint(Offset(leftX, bodyBottom - r), radius: Radius.circular(r));
  path.lineTo(leftX, topY + r);
  path.arcToPoint(Offset(leftX + r, topY), radius: Radius.circular(r));
  path.close();

  return path;
}

class _UnifiedPopoverClipper extends CustomClipper<Path> {
  final double pointerOffsetFromRight;
  final double pointerWidth;
  final double pointerHeight;
  final double borderRadius;

  const _UnifiedPopoverClipper({
    required this.pointerOffsetFromRight,
    required this.pointerWidth,
    required this.pointerHeight,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    return _buildUnifiedPopoverPath(
      size,
      pointerOffsetFromRight,
      pointerWidth,
      pointerHeight,
      borderRadius,
    );
  }

  @override
  bool shouldReclip(_UnifiedPopoverClipper oldClipper) {
    return oldClipper.pointerOffsetFromRight != pointerOffsetFromRight ||
        oldClipper.pointerWidth != pointerWidth ||
        oldClipper.pointerHeight != pointerHeight ||
        oldClipper.borderRadius != borderRadius;
  }
}

class _UnifiedPopoverPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double pointerOffsetFromRight;
  final double pointerWidth;
  final double pointerHeight;
  final double borderRadius;
  final bool isDark;

  const _UnifiedPopoverPainter({
    required this.color,
    required this.borderColor,
    required this.pointerOffsetFromRight,
    required this.pointerWidth,
    required this.pointerHeight,
    required this.borderRadius,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildUnifiedPopoverPath(
      size,
      pointerOffsetFromRight,
      pointerWidth,
      pointerHeight,
      borderRadius,
    );

    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
      8.0,
      true,
    );

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_UnifiedPopoverPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.pointerOffsetFromRight != pointerOffsetFromRight ||
        oldDelegate.pointerWidth != pointerWidth ||
        oldDelegate.pointerHeight != pointerHeight ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.isDark != isDark;
  }
}
