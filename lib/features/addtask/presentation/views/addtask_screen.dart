import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/components/custom_btn_default.dart';
import '../../../../core/helper/user_storage_helper.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../edittask/presentation/views/edittask_screen.dart';

class AddtaskScreen extends StatefulWidget {
  final UserModel? user;
  final String? imagePath;

  const AddtaskScreen({super.key, this.user, this.imagePath});

  @override
  State<AddtaskScreen> createState() => _AddtaskScreenState();
}

class _AddtaskScreenState extends State<AddtaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedGroup;
  bool isGroupDropdownOpen = false;
  String? activeImagePath;

  @override
  void initState() {
    super.initState();
    _resolveUserImage();
  }

  Future<void> _resolveUserImage() async {
    if (widget.imagePath != null && widget.imagePath!.trim().isNotEmpty) {
      setState(() {
        activeImagePath = widget.imagePath;
      });
      return;
    }
    if (widget.user?.imagePath != null && widget.user!.imagePath!.trim().isNotEmpty) {
      setState(() {
        activeImagePath = widget.user!.imagePath;
      });
      return;
    }
    final savedPath = await UserStorageHelper.getLastSavedUserImage();
    if (savedPath != null && savedPath.trim().isNotEmpty && mounted) {
      setState(() {
        activeImagePath = savedPath;
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _getGroupIcon(String group) {
    switch (group) {
      case 'Home':
        return SvgPicture.asset(
          AppSvgs.Group,
          width: 24.w,
          height: 24.h,
        );
      case 'Personal':
        return SvgPicture.asset(
          AppSvgs.Group1,
          width: 24.w,
          height: 24.h,
        );
      case 'Work':
        return SvgPicture.asset(
          AppSvgs.eee,
          width: 24.w,
          height: 24.h,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGroupOption(String group) {
    final isSelected = selectedGroup == group;
    return InkWell(
      onTap: () {
        setState(() {
          selectedGroup = group;
          isGroupDropdownOpen = false;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            _getGroupIcon(group),
            SizedBox(width: 12.w),
            Text(
              group,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasUserImage =
        activeImagePath != null && activeImagePath!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                'Add Task',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),

                // Top Image Card with user profile picture
                SizedBox(
                  width: 250.w,
                  height: 200.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: Image(
                      image: hasUserImage
                          ? UserStorageHelper.getImageProvider(activeImagePath)
                          : AssetImage(AppImages.flag),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // Title Field
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle:
                        TextStyle(color: AppColors.gray, fontSize: 14.sp),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 16.h),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(
                          color: AppColors.gray.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                // Description Field
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle:
                        TextStyle(color: AppColors.gray, fontSize: 14.sp),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 16.h),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(
                          color: AppColors.gray.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                // Group Dropdown Field
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isGroupDropdownOpen = !isGroupDropdownOpen;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                          color: AppColors.gray.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        if (selectedGroup != null) ...[
                          _getGroupIcon(selectedGroup!),
                          SizedBox(width: 10.w),
                          Text(
                            selectedGroup!,
                            style: TextStyle(
                                fontSize: 14.sp, color: Colors.black),
                          ),
                        ] else
                          Text(
                            'Group',
                            style: TextStyle(
                                fontSize: 14.sp, color: AppColors.gray),
                          ),
                        const Spacer(),
                        SvgPicture.asset(
                          AppSvgs.Arrow,
                          width: 16.w,
                          height: 16.h,
                        ),
                      ],
                    ),
                  ),
                ),

                if (isGroupDropdownOpen) ...[
                  SizedBox(height: 5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildGroupOption('Home'),
                        _buildGroupOption('Personal'),
                        _buildGroupOption('Work'),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 15.h),

                // Date & Time Picker Row
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        selectedDate = date;
                        selectedTime = time;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                          color: AppColors.gray.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppSvgs.Calender,
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          selectedDate != null && selectedTime != null
                              ? '${selectedDate!.day} ${_getMonthName(selectedDate!.month)}, ${selectedDate!.year}   ${selectedTime!.format(context)}'
                              : 'End Time',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: selectedDate != null
                                ? Colors.black
                                : AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // Add Task Button -> Navigates to EdittaskScreen as in prototype
                CustomBtn(
                  text: 'Add Task',
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter task title'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EdittaskScreen(
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          selectedGroup: selectedGroup,
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                          user: widget.user,
                          imagePath: activeImagePath,
                        ),
                      ),
                    );

                    if (!mounted) return;

                    if (result != null && result is Map) {
                      if (result['action'] == 'done') {
                        Navigator.pop(context, result);
                      } else if (result['action'] == 'update') {
                        setState(() {
                          if (result['title'] != null) {
                            titleController.text = result['title'];
                          }
                          if (result['description'] != null) {
                            descriptionController.text = result['description'];
                          }
                          if (result['group'] != null) {
                            selectedGroup = result['group'];
                          }
                        });
                      } else if (result['action'] == 'delete') {
                        titleController.clear();
                        descriptionController.clear();
                        setState(() {
                          selectedDate = null;
                          selectedTime = null;
                          selectedGroup = null;
                        });
                      }
                    }
                  },
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
