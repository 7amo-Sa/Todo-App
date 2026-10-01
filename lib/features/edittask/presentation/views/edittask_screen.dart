import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/components/custom_btn_default.dart';
import '../../../../core/helper/user_storage_helper.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/data/models/user_model.dart';

class EdittaskScreen extends StatefulWidget {
  const EdittaskScreen({
    super.key,
    required this.title,
    required this.description,
    required this.selectedGroup,
    required this.selectedDate,
    required this.selectedTime,
    this.user,
    this.imagePath,
  });

  final String title;
  final String description;
  final String? selectedGroup;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final UserModel? user;
  final String? imagePath;

  @override
  State<EdittaskScreen> createState() => _EdittaskScreenState();
}

class _EdittaskScreenState extends State<EdittaskScreen> {
  late String title;
  late String description;
  String? selectedGroup;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isDone = false;
  bool isGroupDropdownOpen = false;
  String? activeImagePath;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    description = widget.description;
    selectedGroup = widget.selectedGroup ?? 'Home';
    selectedDate = widget.selectedDate ?? DateTime(2022, 6, 30);
    selectedTime = widget.selectedTime ?? const TimeOfDay(hour: 22, minute: 0);
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
        if (isDone) return;
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

  void _goBack() {
    Navigator.pop(context, {
      'action': isDone ? 'done' : 'update',
      'title': title,
      'description': description,
      'group': selectedGroup,
      'isDone': isDone,
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasUserImage =
        activeImagePath != null && activeImagePath!.trim().isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: _goBack,
                child: SvgPicture.asset(
                  AppSvgs.ArrowBack,
                  width: 16.w,
                  height: 16.w,
                ),
              ),
              Expanded(
                child: Text(
                  'Edit Task',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontFamily: 'Lexend_Deca',
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 32.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'action': 'delete'});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppSvgs.Trush,
                        width: 16.w,
                        height: 16.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Delete',
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),

                  // IMAGE + STATUS HEADER
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image(
                            image: hasUserImage
                                ? UserStorageHelper.getImageProvider(
                                    activeImagePath)
                                : AssetImage(AppImages.flag),
                            width: 70.w,
                            height: 70.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isDone ? 'Done' : 'In Progress',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              isDone
                                  ? 'Congrats!'
                                  : "Believe you can, and you're halfway there.",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  // Group Selector Field
                  GestureDetector(
                    onTap: () {
                      if (isDone) return;
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

                  if (isGroupDropdownOpen && !isDone) ...[
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

                  // Title Field
                  TextFormField(
                    initialValue: title,
                    readOnly: isDone,
                    onChanged: (val) => title = val,
                    decoration: InputDecoration(
                      hintText: 'Title',
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
                    initialValue: description,
                    readOnly: isDone,
                    onChanged: (val) => description = val,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Description',
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

                  // Date & Time Box
                  GestureDetector(
                    onTap: () async {
                      if (isDone) return;
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );
                        setState(() {
                          selectedDate = date;
                          if (time != null) selectedTime = time;
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
                                : '30 June, 2022  10:00 pm',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),

                  if (!isDone) ...[
                    // Mark as Done Button
                    CustomBtn(
                      text: 'Mark as Done',
                      onPressed: () {
                        setState(() {
                          isDone = true;
                        });
                      },
                    ),

                    SizedBox(height: 15.h),

                    // Outlined Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: () {
                          _goBack();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          side: BorderSide(
                              color: AppColors.primaryColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
