import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double opacity;
  final double blur;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;

  const GlassCard({
    super.key,
    required this.child,
    this.opacity = 0.5,
    this.blur = 20.0,
    this.borderRadius = 20.0,
    this.onTap,
    this.enableHover = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: AppTheme.glassDecoration(
        context: context,
        opacity: widget.opacity,
        blur: widget.blur,
        borderRadius: widget.borderRadius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.onTap == null || !widget.enableHover) {
      return card;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: card,
        ),
      ),
    );
  }
}
