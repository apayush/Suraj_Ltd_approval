import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../../core/utills/app_module_container.dart';
import '../../../../../core/widgets/common_widgets.dart';

class DashboardTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;
  final Gradient? iconGradient;
  final double borderRadius;

  const DashboardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.onTap,
    this.iconGradient,
    this.borderRadius = 14,
  });

  @override
  State<DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  double elevation = 6;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux;

    final tile = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: _hover ? elevation + 6 : elevation,
                offset: Offset(0, _hover ? 10 : 6),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: widget.iconGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: Icon(widget.icon, size: 24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(widget.title ?? '', style: TextStyles.normalBold(context)),
                    const SizedBox(height: 10),
                    AppText(widget.value ?? '', style: TextStyles.normal(context)),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 5),
                      AppText(widget.subtitle ?? '', style: TextStyles.normal(context)),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final interactive = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: widget.onTap,
        onHover: (h) {
          if (isWeb) setState(() => _hover = h);
        },
        child: tile,
      ),
    );

    // Wrap with MouseRegion on web to get cursor pointer
    return MouseRegion(
      cursor: _hover ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 160),
        child: interactive,
      ),
    );
  }
}
