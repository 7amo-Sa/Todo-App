import 'package:dartz/dartz.dart';

import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';

class AddTaskRepo {
  ApiHelper apiHelper = ApiHelper();

  Future<Either<String, String>> addTask({
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
        isPrivate: true,
      );
      var jsonResponse =
      response.data as Map<String, dynamic>;

      return right(jsonResponse['message']);
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }
}