import 'package:practical/helper/home_model.dart';

import '../../../../helper/all.dart';

class PostController extends GetxController {
  int? id;
  final dio = Dio();
  HomeModel? homeModel;
  RxBool isResponse = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      id = Get.arguments['id'];
      postApi();
    }
    super.onInit();
  }

  void postApi() async {
    try {
      var response = await dio.get('https://jsonplaceholder.typicode.com/posts/${id.toString()}');
      homeModel = HomeModel.fromJson(response.data);
      isResponse.value = true;
      update();
    } catch (e) {
      print('----------------->>>>>>is error');
    }
  }
}
