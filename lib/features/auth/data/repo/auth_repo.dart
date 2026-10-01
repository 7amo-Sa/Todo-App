import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper/user_storage_helper.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../models/user_model.dart';

class AuthRepo {
  ApiHelper apiHelper = ApiHelper();

  Future<Either<String, UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      var jsonResponse = response.data as Map<String, dynamic>;
      accessToken = jsonResponse['access_token'];
      refreshToken = jsonResponse['refresh_token'];

      UserModel userModel = UserModel.fromJson(jsonResponse['user']);
      if (userModel.imagePath == null || userModel.imagePath!.isEmpty) {
        String? localImage = await UserStorageHelper.getUserImage(username);
        if (localImage != null && localImage.isNotEmpty) {
          userModel.imagePath = localImage;
        }
      }
      return right(userModel);
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }

  Future<Either<String, String>> register({
    required String username,
    required String password,
    String? imagePath,
  }) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.register,
        data: {
          'username': username,
          'password': password,
          if (imagePath != null)
            'image': await MultipartFile.fromFile(imagePath),
        },
      );
      if (imagePath != null && imagePath.isNotEmpty) {
        await UserStorageHelper.saveUserImage(username, imagePath);
      }
      var jsonResponse = response.data as Map<String, dynamic>;
      return right(jsonResponse['message'] ?? 'Registered successfully');
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }

  Future<Either<String, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.changePassword,
        isPrivate: true,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      var jsonResponse = response.data as Map<String, dynamic>;
      return right(jsonResponse['message'] ?? 'Password changed successfully');
    } catch (e) {
      return left(apiHelper.handleException(e));
    }
  }
}
