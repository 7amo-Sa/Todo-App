import 'package:dartz/dartz.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../../../addtask/data/models/task_model.dart';


class HomeRepo {
  ApiHelper apiHelper = ApiHelper();

  Future<Either<String, List<TaskModel>>> getTasks() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.myTasks,
        isPrivate: true,
      );

      var jsonResponse =
      response.data as Map<String, dynamic>;

      List<TaskModel> tasks =
      (jsonResponse['tasks'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();

      return right(tasks);
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }
}