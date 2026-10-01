import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../localization/language_cubit.dart';

class AnimatedLanguageSwitcher extends StatelessWidget {
  const AnimatedLanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LanguageCubit>().state;
    final isArabic = currentLocale.languageCode == 'ar';

    return Container(
      width: 102.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // AR side
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<LanguageCubit>().changeLanguage('ar');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isArabic
                      ? const Color(0xFF149954)
                      : const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                    topRight: isArabic ? Radius.circular(8.r) : Radius.zero,
                    bottomRight: isArabic ? Radius.circular(8.r) : Radius.zero,
                  ),
                ),
                child: Text(
                  'AR',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isArabic ? Colors.white : const Color(0xFF24252C),
                  ),
                ),
              ),
            ),
          ),

          // EN side
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<LanguageCubit>().changeLanguage('en');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isArabic
                      ? const Color(0xFF149954)
                      : const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                    topLeft: !isArabic ? Radius.circular(8.r) : Radius.zero,
                    bottomLeft: !isArabic ? Radius.circular(8.r) : Radius.zero,
                  ),
                ),
                child: Text(
                  'EN',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: !isArabic ? Colors.white : const Color(0xFF24252C),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
