import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helper/user_storage_helper.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/data/models/user_model.dart';

class UpdateprofileScreen extends StatelessWidget {
  final UserModel user;

  const UpdateprofileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: user.username ?? '');

    final hasUserImage =
        user.imagePath != null && user.imagePath!.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
                child: Image(
                  image: hasUserImage
                      ? UserStorageHelper.getImageProvider(user.imagePath)
                      : AssetImage(AppImages.flag),
                  width: double.infinity,
                  height: 298.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    TextFormField(
                      controller: controller,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: context.tr('username'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide(
                            color: AppColors.gray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide(
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
