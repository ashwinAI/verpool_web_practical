import '../../../../getStorageData.dart';
import '../../../../helper/all.dart';
import '../../../../helper/home_model.dart';

class HomeController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final dio = Dio();
  List<HomeModel> homeList = [];

  int page = 1; // default page to 0
  int perPage = 25; // per page items you want to show

  @override
  void onInit() {
    keyFind();
    super.onInit();
  }

  keyFind() async {
    print('alalalallaa----------------->>>>>>${GetStorageData().containKey('products')}');
    if (GetStorageData().containKey('products')) {
      List abc = await GetStorageData().readObject('products');
      abc.forEach(
        (element) {
          homeList.add(HomeModel.fromJson(element));
        },
      );
      print('abc lengthhhh----------------->>>>>>${abc.length}');
      update();
    } else {
      homeApi();
    }
  }

  void homeApi() async {
    try {
      var response = await dio.get('https://api.escuelajs.co/api/v1/products');
      if (response.data != null) {
        for (int i = 0; i < response.data!.length; i++) {
          homeList.add(HomeModel.fromJson(response.data[i]));
        }
        saveProducts(homeList);
      }
      update();
    } catch (e) {
      print('error this api');
    }
  }

  saveProducts(List<HomeModel> products) async {
    await GetStorageData().saveObject('products', products);
    print('-productsproducts---------------->>>>>>${GetStorageData().containKey('products')}');
  }
}
