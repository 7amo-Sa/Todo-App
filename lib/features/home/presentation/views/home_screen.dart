import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/components/custom_svg.dart';
import '../../../../core/helper/user_storage_helper.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_paddings.dart';
import '../../../addtask/data/models/task_model.dart';
import '../../../addtask/presentation/views/addtask_screen.dart';
import '../../../edittask/presentation/views/edittask_screen.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/repo/home_repo.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  String? errorMsg;
  List<TaskModel>? tasks;

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  Future<void> getTasks() async {
    setState(() {
      errorMsg = null;
      tasks = null;
      isLoading = true;
    });

    HomeRepo repo = HomeRepo();
    var result = await repo.getTasks();

    if (!mounted) return;

    result.fold(
      (String e) {
        setState(() {
          errorMsg = e;
        });
      },
      (List<TaskModel> t) {
        setState(() {
          tasks = t;
        });
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: widget.user),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage:
                    UserStorageHelper.getImageProvider(widget.user.imagePath),
                radius: 25.r,
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('hello'),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.user.username ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16.sp,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: AppPaddings.defaultPadding,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMsg != null
                ? Center(child: Text(errorMsg!))
                : tasks != null && tasks!.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(height: 30.h),
                          Row(
                            children: [
                              Text(
                                context.tr('tasks'),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                padding: REdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '${tasks!.length}',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final task = tasks![index];
                                return GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EdittaskScreen(
                                          user: widget.user,
                                          title: task.title ?? '',
                                          description: task.description ?? '',
                                          selectedGroup: null,
                                          selectedDate: null,
                                          selectedTime: null,
                                        ),
                                      ),
                                    );

                                    if (!mounted) return;
                                    if (result != null && result is Map) {
                                      if (result['action'] == 'delete') {
                                        setState(() {
                                          tasks?.removeAt(index);
                                        });
                                      } else if (result['action'] == 'update' ||
                                          result['action'] == 'done') {
                                        setState(() {
                                          tasks?[index] = TaskModel(
                                            title: result['title'] ?? task.title,
                                            description: result['description'] ??
                                                task.description,
                                          );
                                        });
                                      } else {
                                        getTasks();
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: AppColors.primaryLight,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 4),
                                          blurRadius: 4.r,
                                          spreadRadius: 0,
                                          color: Colors.black.withValues(
                                            alpha: 0.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: REdgeInsets.all(13),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task.title ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                  color: AppColors.gray,
                                                ),
                                              ),
                                              SizedBox(height: 13.h),
                                              Text(
                                                task.description ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14.sp,
                                                  color: AppColors.black,
                                                ),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          task.createdAt ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20.h),
                              itemCount: tasks!.length,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr('no_tasks_title'),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300,
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 60.h),
                            CustomSvg(
                              path: AppSvgs.Home,
                              width: 300.w,
                              height: 225.h,
                            ),
                          ],
                        ),
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddtaskScreen(user: widget.user),
            ),
          );

          if (!mounted) return;

          if (result != null && result is Map) {
            if (result['action'] == 'done' || result['action'] == 'update') {
              setState(() {
                tasks ??= [];
                tasks!.insert(
                  0,
                  TaskModel(
                    title: result['title'] ?? '',
                    description: result['description'] ?? '',
                  ),
                );
              });
            } else {
              getTasks();
            }
          }
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        child: CustomSvg(
          path: AppSvgs.addTasks,
        ),
      ),
    );
  }
}
