import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:my_music_app/widgets/scandevice.dart';
import 'package:my_music_app/widgets/text_widget.dart';

import '../controller/splashscreencontroller.dart';
import '../widgets/button.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      body: Obx(() => controller.currentPage.value!=4?Padding(
        padding: EdgeInsets.all(30.0.sp),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageFade(
                  // whenever the image changes, it will be loaded, and then faded in:
                  image: AssetImage(controller.imageString.value),

                  // slow fade for newly loaded images:
                  duration: const Duration(milliseconds: 400),

                  // if the image is loaded synchronously (ex. from memory), fade in faster:
                  syncDuration: const Duration(milliseconds: 450),

                  // supports most properties of Image:
                  alignment: Alignment.center,
                  fit: BoxFit.cover,

                  // shown behind everything:
                  placeholder: Container(
                    color: const Color(0xffF5F5F7),
                    alignment: Alignment.center,
                    child: const Icon(Icons.photo,
                        color: Colors.white30, size: 128.0),
                  ),

                  // shows progress while loading an image:
                  loadingBuilder: (context, progress, chunkEvent) =>
                      Center(child: CircularProgressIndicator(value: progress)),

                  // displayed when an error occurs:
                  errorBuilder: (context, error) => Container(
                    color: const Color(0xFF6F6D6A),
                    alignment: Alignment.center,
                    child: const Icon(Icons.warning,
                        color: Colors.black26, size: 128.0),
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                TextWidget(
                    value: controller.contentTitle.value,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(controller.currentColor.value),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 20.sp,
                ),
                TextWidget(
                    value: controller.contentAbout.value,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(controller.currentSecColor.value),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 20.sp,
                ),
                TextWidget(
                    value: controller.description.value,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(controller.currentColor.value),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 50.sp,
                ),
                InkWell(
                  child: ButtonWidget(
                      widget: Center(
                        child: TextWidget(
                            value: controller.callForAction.value,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            textAlign: TextAlign.center),
                      ),
                      height: 60,
                      width: 150,
                      radius: 100,
                      color: controller.currentColor.value,
                      borderColor: controller.currentColor.value),
                  onTap: () {
                    if (controller.currentPage.value != 5) {
                      controller.currentPage.value =
                          controller.currentPage.value + 1;
                      controller.displayPage();
                      return;
                    }
                  },
                ),
              ],
            ),
      ):ScanBluetoothDevice()),
    );
  }
}
