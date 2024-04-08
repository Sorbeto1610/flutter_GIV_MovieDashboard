import 'dart:ui';
import 'package:flutter/cupertino.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color shadowColor;
  final Offset shadowOffset;

  // Constructor
  ResponsiveText({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.shadowColor,
    required this.shadowOffset,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveFontSize = screenWidth * fontSize / 1000.0;
    Offset responsiveShadowOffset = Offset(
      shadowOffset.dx * responsiveFontSize / 20,
      shadowOffset.dy * responsiveFontSize / 20,
    );

    return Text(
      text,
      style: TextStyle(
        fontSize: responsiveFontSize,
        color: textColor,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: shadowColor,
            offset: responsiveShadowOffset,
          ),
        ],
      ),
    );
  }
}
