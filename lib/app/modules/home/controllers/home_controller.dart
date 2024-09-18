import 'dart:async';
import 'dart:math';

import '../../../../databse.dart';
import '../../../../helper/all.dart';
import '../../../../person.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final dio = Dio();
  var lastLifecycleState = Rx<AppLifecycleState>(AppLifecycleState.resumed);

  List<dynamic> homeList = [];
  RxBool isEmpty = false.obs;
  List<Person> allPersonsList = [];
  Timer? timer;

  @override
  Future<void> onInit() async {
    homeApi();
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  void homeApi() async {
    try {
      var response = await dio.get('https://jsonplaceholder.typicode.com/posts');
      if (response.data != null) {
        homeList = response.data;
      }
      localStorageData();
      isEmpty.value = homeList.isEmpty;
      update();
    } catch (e) {
      print('error this api');
    }
  }

  localStorageData() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = database.personDao;
    homeList.forEach(
      (element) async {
        bool isFocused = await personDao.findEntityById(element['id']) == null;
        if (isFocused) {
          final newPerson = Person(element['id'], (30 + Random().nextInt(21)), false, false);
          await personDao.insertPerson(newPerson);
        }
      },
    );
    valueADD();
  }

  valueADD() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = database.personDao;
    await Future.delayed(const Duration(seconds: 1));
    allPersonsList = await personDao.findAllPersons();
    update();
    timerCount();
  }

  timerCount() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (int i = 0; i < allPersonsList.length; i++) {
        if (allPersonsList[i].isScreenVisible && allPersonsList[i].time > 0) {
          allPersonsList[i].time--;
        }
      }
      update();
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    lastLifecycleState.value = state;
    if (state == AppLifecycleState.resumed) {
      if (timer!.isActive) {
        timer!.cancel();
      }
      timerCount();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      onBackgroundWork();
    } else {
      if (timer!.isActive) {
        timer!.cancel();
      }
    }
    if (state == AppLifecycleState.paused) {
      print('App is in background or being closed');
    } else if (state == AppLifecycleState.resumed) {
      print('App is resumed');
    } else if (state == AppLifecycleState.inactive) {
      print('App is inactive');
    } else if (state == AppLifecycleState.detached) {
      print('App is detached (completely closed)');
    }
  }

  onBackgroundWork() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = database.personDao;
    allPersonsList.forEach(
      (element) async {
        final updatedPerson = Person(
          element.id,
          element.time,
          element.isOpen,
          element.isScreenVisible,
        );
        await personDao.updatePerson(updatedPerson);
      },
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
