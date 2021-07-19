import 'dart:ui' as ui show ImageFilter;

import 'package:flutter/material.dart';

class ItemFilter extends StatelessWidget {
  final String title;
  final bool active;
  final Function() onTap;

  const ItemFilter({
    Key? key,
    required this.title,
    this.active = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: ClipRect(
        child: Material(
          color: Color(0xFF040404).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: active
                ? BorderSide(
                    color: Colors.white,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 4.0,
              sigmaY: 4.0,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
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
