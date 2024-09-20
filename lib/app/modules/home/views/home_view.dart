import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../getStorageData.dart';
import '../../../../helper/home_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            drawer: SizedBox(
              width: Get.width / 1.3,
              child: Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.person,
                              size: 70,
                            ),
                          ),
                          10.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'verloop web',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              5.verticalSpace,
                              Text(
                                'verloop@gmail.com',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.location_on,
                      ),
                      title: const Text('Location Tracking'),
                      onTap: () {
                        Get.toNamed(Routes.MAP);
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              title: Text(
                'HomeView',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
              ),
            ),
            body: controller.homeList.isNotEmpty
                ? Container(
                    color: Colors.grey.withOpacity(0.05),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: controller.homeList.length < controller.page * controller.perPage
                                    ? controller.homeList.length
                                    : controller.page * controller.perPage,
                                itemBuilder: (context, index) {
                                  HomeModel obj = controller.homeList[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      Get.toNamed(Routes.ITEM, arguments: obj)!.then(
                                        (value) {
                                          print('avavav-productsproducts---------------->>>>>>${GetStorageData().containKey('products')}');
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.h),
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.12),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.r),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: obj.category!.image!,
                                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                  CircularProgressIndicator(value: downloadProgress.progress),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  obj.title!,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  obj.description!,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Visibility(
                                visible: controller.homeList.length > controller.page * controller.perPage,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('ffff----------------->>>>>>${controller.homeList.length}');
                                        print('mmm----------------->>>>>>${controller.page * controller.perPage}');
                                        if (controller.homeList.length > controller.page * controller.perPage) {
                                          controller.page++;
                                        }
                                        controller.update();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 15, bottom: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.6), borderRadius: const BorderRadius.all(Radius.circular(20))),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Next ${controller.page}/${((controller.homeList.length ~/ controller.perPage)) + ((controller.homeList.length % controller.perPage) != 0 ? 1 : 0)}',
                                              style: TextStyle(fontSize: 16.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()));
      },
    );
  }
}
