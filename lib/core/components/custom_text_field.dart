import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/app_colors.dart';
import 'custom_svg.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.prefixIconPath,
    required this.controller,
    this.onSuffixPressed,
    this.suffixIconPath,
    this.obscureText = false,
    this.maxLines,
  });

  final String hint;

  final String prefixIconPath;
  final TextEditingController controller;
  final void Function()? onSuffixPressed;
  final String? suffixIconPath;
  final bool obscureText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.black,
        fontWeight: FontWeight.w300,
      ),
      obscureText: obscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: REdgeInsets.all(16.0),
          child: CustomSvg(path: prefixIconPath,),
        ),
        suffixIcon: suffixIconPath != null
            ? IconButton(
          onPressed: onSuffixPressed,
          icon: SvgPicture.asset(suffixIconPath!),
        )
            : null,
        hintText: hint,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: 14.sp,
          color: AppColors.gray,
        ),
        fillColor: Colors.white,
        filled: true,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: AppColors.gray),
        ),
      ),
    );
  }
}