import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final bool isTitle;
  final bool isSubtitle;
  final bool isBody;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
  })  : isTitle = false,
        isSubtitle = false,
        isBody = false;

  const CustomText.title(
    this.text, {
    super.key,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.bold,
    this.color = AppConstants.textColor,
    this.textAlign,
  })  : isTitle = true,
        isSubtitle = false,
        isBody = false;

  const CustomText.subtitle(
    this.text, {
    super.key,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w500,
    this.color = AppConstants.textLightColor,
    this.textAlign,
  })  : isTitle = false,
        isSubtitle = true,
        isBody = false;

  const CustomText.body(
    this.text, {
    super.key,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.color = AppConstants.textColor,
    this.textAlign,
  })  : isTitle = false,
        isSubtitle = false,
        isBody = true;

  @override
  Widget build(BuildContext context) {
    double finalFontSize = fontSize ?? 16.0;
    FontWeight finalFontWeight = fontWeight ?? FontWeight.normal;
    Color finalColor = color ?? AppConstants.textColor;

    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: finalFontSize,
        fontWeight: finalFontWeight,
        color: finalColor,
      ),
    );
  }
}
