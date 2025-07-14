// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';

class HoverIconContainer extends StatefulWidget {
  final Color iconBgColor;
  final Color iconColor;
  final Widget child;

  const HoverIconContainer({
    Key? key,
    required this.iconBgColor,
    required this.iconColor,
    required this.child,
  }) : super(key: key);

  @override
  State<HoverIconContainer> createState() => _HoverIconContainerState();
}

class _HoverIconContainerState extends State<HoverIconContainer> {
  bool _isHovered = false;

  void _onEnter(PointerEvent event) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isHovered ? widget.iconBgColor.withOpacity(0.7) : widget.iconBgColor;
    final iconColor = _isHovered ? widget.iconColor : widget.iconColor;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.iconBgColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: IconTheme(
          data: IconThemeData(color: iconColor),
          child: widget.child,
        ),
      ),
    );
  }
}
