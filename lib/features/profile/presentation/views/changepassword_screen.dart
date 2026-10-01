import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/components/custom_btn_default.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/helper/user_storage_helper.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/repo/auth_repo.dart';

class ChangepasswordScreen extends StatefulWidget {
  final UserModel? user;
  const ChangepasswordScreen({super.key, this.user});

  @override
  State<ChangepasswordScreen> createState() => _ChangepasswordScreenState();
}

class _ChangepasswordScreenState extends State<ChangepasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isOldSecure = true;
  bool isNewSecure = true;
  bool isConfirmSecure = true;
  bool isLoading = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasUserImage = widget.user?.imagePath != null &&
        widget.user!.imagePath!.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
                child: Image(
                  image: hasUserImage
                      ? UserStorageHelper.getImageProvider(widget.user!.imagePath)
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
                    CustomTextField(
                      controller: oldPasswordController,
                      hint: context.tr('old_password'),
                      prefixIconPath: AppSvgs.Iconpro,
                      suffixIconPath:
                          isOldSecure ? AppSvgs.lock : AppSvgs.unlock,
                      onSuffixPressed: () {
                        setState(() {
                          isOldSecure = !isOldSecure;
                        });
                      },
                      obscureText: isOldSecure,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextField(
                      controller: newPasswordController,
                      hint: context.tr('new_password'),
                      prefixIconPath: AppSvgs.Iconpro,
                      suffixIconPath:
                          isNewSecure ? AppSvgs.lock : AppSvgs.unlock,
                      onSuffixPressed: () {
                        setState(() {
                          isNewSecure = !isNewSecure;
                        });
                      },
                      obscureText: isNewSecure,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextField(
                      controller: confirmPasswordController,
                      hint: context.tr('confirm_password'),
                      prefixIconPath: AppSvgs.Iconpro,
                      suffixIconPath:
                          isConfirmSecure ? AppSvgs.lock : AppSvgs.unlock,
                      onSuffixPressed: () {
                        setState(() {
                          isConfirmSecure = !isConfirmSecure;
                        });
                      },
                      obscureText: isConfirmSecure,
                    ),
                    SizedBox(height: 25.h),
                    if (!isLoading)
                      CustomBtn(
                        text: context.tr('save'),
                        onPressed: () async {
                          final oldPass = oldPasswordController.text;
                          final newPass = newPasswordController.text;
                          final confirmPass = confirmPasswordController.text;

                          if (oldPass.isEmpty ||
                              newPass.isEmpty ||
                              confirmPass.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr('fill_all_fields'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (newPass != confirmPass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr('passwords_not_match'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          AuthRepo repo = AuthRepo();
                          var result = await repo.changePassword(
                            oldPassword: oldPass,
                            newPassword: newPass,
                          );

                          if (!mounted) return;

                          result.fold(
                            (errorMsg) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    errorMsg,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            (msg) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.tr('password_changed_success'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                              Navigator.pop(context);
                            },
                          );

                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    if (isLoading) const CircularProgressIndicator(),
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
