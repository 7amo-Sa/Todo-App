import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/components/custom_btn_default.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/helper/my_navigator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_paddings.dart';
import '../../../home/presentation/views/home_screen.dart';
import '../../data/repo/auth_repo.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordSecure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
              ),
              child: Image.asset(
                AppImages.flag,
                width: double.infinity,
                height: 293.h,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: AppPaddings.defaultPadding,
              child: Column(
                children: [
                  SizedBox(height: 23.h),
                  CustomTextField(
                    controller: usernameController,
                    hint: context.tr('username'),
                    prefixIconPath: AppSvgs.profile,
                  ),

                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: passwordController,
                    hint: context.tr('password'),
                    prefixIconPath: AppSvgs.Iconpro,
                    suffixIconPath:
                        isPasswordSecure ? AppSvgs.lock : AppSvgs.unlock,
                    onSuffixPressed: () {
                      setState(() {
                        isPasswordSecure = !isPasswordSecure;
                      });
                    },
                    obscureText: isPasswordSecure,
                  ),

                  SizedBox(height: 23.h),
                  if (!isLoading)
                    CustomBtn(
                      text: context.tr('login'),
                      onPressed: () async {
                        final username = usernameController.text.trim();
                        final password = passwordController.text;

                        if (username.isEmpty || password.isEmpty) {
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

                        AuthRepo repo = AuthRepo();
                        setState(() {
                          isLoading = true;
                        });

                        var result = await repo.login(
                          username: username,
                          password: password,
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
                          (userData) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${context.tr('welcome')} ${userData.username}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: AppColors.primaryColor,
                              ),
                            );
                            MyNavigator.goTo(
                              context,
                              toPage: HomeScreen(user: userData),
                              type: NavigatorType.pushAndRemoveUntil,
                            );
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
                        context.tr('dont_have_account'),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      TextButton(
                        onPressed: () => MyNavigator.goTo(
                          context,
                          toPage: const RegisterScreen(),
                        ),
                        child: Text(
                          context.tr('register'),
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
  }
}
