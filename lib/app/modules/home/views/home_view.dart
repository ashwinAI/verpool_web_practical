import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../databse.dart';
import '../../../../helper/all.dart';
import '../../../../person.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
            body: controller.homeList.isNotEmpty && controller.allPersonsList.isNotEmpty
                ? Container(
                    color: Colors.grey.withOpacity(0.05),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
                          child: Container(
                            height: MediaQuery.of(context).padding.top + 45.h,
                            width: double.infinity,
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Text(
                                'HomeView',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: controller.homeList.length,
                            itemBuilder: (context, index) {
                              return VisibilityDetector(
                                key: Key('item-asasd$index'),
                                onVisibilityChanged: (VisibilityInfo info) {
                                  controller.allPersonsList[index].isScreenVisible = info.visibleFraction > 0;
                                  controller.update();
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
                                    final personDao = database.personDao;
                                    controller.allPersonsList[index].isOpen = true;
                                    controller.allPersonsList.forEach(
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
                                    Get.toNamed(Routes.POST, arguments: controller.homeList[index])?.then(
                                      (value) async {
                                        controller.allPersonsList = await personDao.findAllPersons();
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.h),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: controller.allPersonsList[index].isOpen ? Colors.white : const Color(0xFFffffc5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.r),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller.homeList[index]['title'],
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10.h),
                                              child: Text(
                                                // '${controller.allPersonsList[index].time == 0 ? '' : controller.allPersonsList[index].time}', // 'aa',
                                                '${controller.allPersonsList[index].time}', // 'aa',
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          controller.homeList[index]['body'],
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : !controller.isEmpty.value
                    ? const Center(child: CircularProgressIndicator())
                    : const Center(child: Text('No data found')));
      },
    );
  }
}
