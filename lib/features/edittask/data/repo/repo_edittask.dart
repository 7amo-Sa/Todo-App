import 'package:dartz/dartz.dart';

import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';

class EditTaskRepo {
  ApiHelper apiHelper = ApiHelper();

  Future<Either<String, String>> createTask({
    required String title,
    required String description,
  }) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.newTask,
        data: {
          'title': title,
          'description': description,
        },
        isFormData: true,
        isPrivate: true,
      );

      var jsonResponse = response.data as Map<String, dynamic>;

      return right(
        jsonResponse['message']?.toString() ??
            'Task created successfully',
      );
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }

  Future<Either<String, String>> updateTask({
    required int taskId,
    required String title,
    required String description,
  }) async {
    try {
      var response = await apiHelper.putRequest(
        endPoint: '${EndPoints.updateTask}/$taskId',
        data: {
          'title': title,
          'description': description,
        },
        isFormData: true,
        isPrivate: true,
      );

      var jsonResponse = response.data as Map<String, dynamic>;

      return right(
        jsonResponse['message']?.toString() ??
            'Task updated successfully',
      );
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }

  Future<Either<String, String>> deleteTask({
    required int taskId,
  }) async {
    try {
      var response = await apiHelper.deleteRequest(
        endPoint: '${EndPoints.deleteTask}/$taskId',
        isPrivate: true,
      );

      var jsonResponse = response.data as Map<String, dynamic>;

      return right(
        jsonResponse['message']?.toString() ??
            'Task deleted successfully',
      );
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }
}