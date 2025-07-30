import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppTextStyles {
  // Headings
  static TextStyle heading1(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.bold,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle heading2(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  // Body
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  // Caption
  static TextStyle caption(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w300,
      color: color ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
    );
  }
}
