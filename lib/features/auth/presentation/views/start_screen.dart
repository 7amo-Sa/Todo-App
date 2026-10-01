import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/components/custom_btn_default.dart';
import '../../../../core/components/custom_svg.dart';
import '../../../../core/helper/my_navigator.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_paddings.dart';
import 'login_screen.dart';

class LetStartScreen extends StatelessWidget {
  const LetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPaddings.defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 12.0),
              child: CustomSvg(
                path: AppSvgs.Onboarding2,
                width: double.infinity,
                height: 342.h,
              ),
            ),
            Text(
              'Welcome To\nDo It !',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 24.sp,
                color: AppColors.black,
              ),

              textAlign: TextAlign.center,
            ),

            Text(
              "Ready to conquer your tasks? Let's Do It together.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: AppColors.gray,
              ),
              textAlign: TextAlign.center,
            ),

            CustomBtn(
                text: "Let's Start",
                onPressed: () {
                  MyNavigator.goTo(context, toPage: LoginScreen());
                }
            ),
          ],
        ),
      ),
    );
  }
}