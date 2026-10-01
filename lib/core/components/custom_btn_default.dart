import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({super.key, required this.text, required this.onPressed});

  final String text ;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor,
              blurRadius: 10,
              offset: Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: REdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 19.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}