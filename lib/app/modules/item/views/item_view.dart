import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/item_controller.dart';

class ItemView extends GetView<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemController());
    return GetBuilder<ItemController>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ItemView'),
          centerTitle: true,
        ),
        body: controller.homeModel != null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.10),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.h),
                        margin: const EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.12),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: controller.homeModel!.category!.image!,
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
                                    controller.homeModel!.title!,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    controller.homeModel!.description!,
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
                      GestureDetector(
                        onTap: () {},
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: 230.h,
                              width: Get.width,
                              child: PageView(
                                controller: controller.newPageController,
                                children: List.generate(
                                  controller.homeModel!.images!.length,
                                  (index) => Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: controller.homeModel!.images![index],
                                        fit: BoxFit.cover,
                                        height: 230.h,
                                        width: Get.width,
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                      BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 6.5, sigmaY: 6.5),
                                        child: Container(
                                          height: 230.h,
                                          width: Get.width,
                                          color: Colors.black.withOpacity(0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 230.h,
                              width: Get.width,
                              child: PageView(
                                controller: controller.newPageController,
                                onPageChanged: (value) {
                                  print('avavva----------------->>>>>>${value}');
                                  controller.pageValue.value = value + 1;
                                  controller.update();
                                },
                                children: List.generate(
                                  controller.homeModel!.images!.length,
                                  (index) => CachedNetworkImage(
                                    imageUrl: controller.homeModel!.images![index],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: controller.homeModel!.images!.length > 1,
                              child: Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10, right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    '${controller.pageValue.value}/${controller.homeModel!.images!.length}',
                                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                            /* if (controller.homeModel!.images!.length > 1)
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: SmoothPageIndicator(
                                  controller: controller.newPageController,
                                  count: controller.homeModel!.images!.length,
                                  effect: WormEffect(
                                    dotHeight: 8.h,
                                    dotWidth: 8.h,
                                    spacing: 4.h,
                                    activeDotColor: Colors.yellow,
                                  ), // your preferred effect
                                  onDotClicked: (index) {},
                                ),
                              )*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
