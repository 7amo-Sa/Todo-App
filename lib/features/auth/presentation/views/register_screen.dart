import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/components/custom_btn_default.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_paddings.dart';
import '../../data/repo/auth_repo.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_states.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // image header / picker
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                        ),
                        child: image != null
                            ? Image.file(
                                File(image!.path),
                                width: double.infinity,
                                height: 293.h,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                AppImages.flag,
                                width: double.infinity,
                                height: 293.h,
                                fit: BoxFit.cover,
                              ),
                      ),

                      // pick image btn
                      Padding(
                        padding: REdgeInsets.only(bottom: 10.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedImage = await picker.pickImage(
                              source: ImageSource.gallery,
                            );

                            if (pickedImage != null) {
                              setState(() {
                                image = pickedImage;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black.withValues(alpha: 0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            context.tr('pick_image'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: AppPaddings.defaultPadding,
                    child: Column(
                      children: [
                        SizedBox(height: 23.h),

                        CustomTextField(
                          controller: cubit.email,
                          hint: context.tr('username'),
                          prefixIconPath: AppSvgs.profile,
                        ),

                        SizedBox(height: 10.h),

                        CustomTextField(
                          controller: cubit.password,
                          hint: context.tr('password'),
                          prefixIconPath: AppSvgs.Iconpro,
                          suffixIconPath: cubit.isPasswordSecure
                              ? AppSvgs.lock
                              : AppSvgs.unlock,
                          onSuffixPressed: cubit.changePasswordSecure,
                          obscureText: cubit.isPasswordSecure,
                        ),

                        SizedBox(height: 10.h),

                        CustomTextField(
                          controller: cubit.confirmPassword,
                          hint: context.tr('confirm_password'),
                          prefixIconPath: AppSvgs.Iconpro,
                          suffixIconPath: cubit.isConfirmPasswordSecure
                              ? AppSvgs.lock
                              : AppSvgs.unlock,
                          onSuffixPressed: cubit.changeConfirmPasswordSecure,
                          obscureText: cubit.isConfirmPasswordSecure,
                        ),

                        SizedBox(height: 23.h),

                        if (!isLoading)
                          CustomBtn(
                            text: context.tr('register'),
                            onPressed: () async {
                              final username = cubit.email.text.trim();
                              final password = cubit.password.text;
                              final confirmPassword = cubit.confirmPassword.text;

                              if (username.isEmpty ||
                                  password.isEmpty ||
                                  confirmPassword.isEmpty) {
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

                              if (password != confirmPassword) {
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

                              AuthRepo repo = AuthRepo();

                              setState(() {
                                isLoading = true;
                              });

                              var result = await repo.register(
                                username: username,
                                password: password,
                                imagePath: image?.path,
                              );

                              if (!mounted) return;

                              result.fold(
                                (errorMsg) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        errorMsg,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                (msg) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        msg,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
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

                        SizedBox(height: 40.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr('already_have_account'),
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                context.tr('login'),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
