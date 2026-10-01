import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/components/animated_language_switcher.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                AppSvgs.ArrowBack,
                width: 16.w,
                height: 16.w,
              ),
            ),
            Expanded(
              child: Text(
                context.tr('settings'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: 'Lexend_Deca',
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    context.tr('language'),
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: 'Lexend_Deca',
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const AnimatedLanguageSwitcher(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
