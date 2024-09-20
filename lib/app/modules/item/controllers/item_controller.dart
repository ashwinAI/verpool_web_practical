import 'package:practical/helper/home_model.dart';

import '../../../../helper/all.dart';

class ItemController extends GetxController {
  final dio = Dio();
  HomeModel? homeModel;
  RxInt pageValue = 1.obs;
  PageController newPageController = PageController();

  @override
  void onInit() {
    if (Get.arguments != null) {
      homeModel = Get.arguments;
      /*   String id = Get.arguments.toString();
      getItem(id);*/
    }
    super.onInit();
  }

  void getItem(String id) async {
    try {
      var response = await dio.get('https://api.escuelajs.co/api/v1/products/$id');
      if (response.data != null) {
        HomeModel model = HomeModel.fromJson(response.data);
        homeModel = model;
      }
    } catch (e) {
      print('error this api');
    }
    update();
  }
}
