import 'package:flutter/material.dart';
import 'dart:ui' as ui show ImageFilter;

class BottomNavigation extends StatelessWidget {
  final Function()? onBack;
  final Function()? onNext;
  final IconData? iconBack;
  final IconData? iconNext;

  const BottomNavigation({
    Key? key,
    this.onBack,
    this.onNext,
    this.iconBack,
    this.iconNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: Container(
          height: 60,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          color: Color(0xFF040404).withOpacity(0.7),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 4.0,
              sigmaY: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        iconBack ?? Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    onTap: onBack,
                  ),
                ),

                //
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        iconNext ?? Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    onTap: onNext,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
