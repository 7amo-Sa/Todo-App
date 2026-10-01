import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/helper/user_storage_helper.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/data/models/user_model.dart';
import 'changepassword_screen.dart';
import 'language_screen.dart';
import 'updateprofile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              AppSvgs.ArrowBack,
              width: 16.w,
              height: 16.w,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage:
                          UserStorageHelper.getImageProvider(user.imagePath),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('hello'),
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          user.username ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppSvgs.profile,
                        width: 28.w,
                        height: 28.h,
                      ),
                      SizedBox(width: 25.w),
                      Text(
                        context.tr('profile'),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateprofileScreen(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset(AppSvgs.ArrowUP),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppSvgs.lock,
                        width: 28.w,
                        height: 28.h,
                      ),
                      SizedBox(width: 25.w),
                      Text(
                        context.tr('change_password'),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangepasswordScreen(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset(AppSvgs.ArrowUP),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppSvgs.SettingIcon,
                        width: 28.w,
                        height: 28.h,
                      ),
                      SizedBox(width: 25.w),
                      Text(
                        context.tr('settings'),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LanguageScreen(),
                            ),
                          );
                        },
                        child: SvgPicture.asset(AppSvgs.ArrowUP),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
