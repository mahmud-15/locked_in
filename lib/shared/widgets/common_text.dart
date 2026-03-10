import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;

  const CommonText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize?.sp ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}
