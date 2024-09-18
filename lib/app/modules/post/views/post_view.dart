import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/post_controller.dart';

class PostView extends GetView<PostController> {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PostController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PostView',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.isResponse.value
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
                margin: EdgeInsets.all(20.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFffffc5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.homeModel!.title!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      controller.homeModel!.body!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
