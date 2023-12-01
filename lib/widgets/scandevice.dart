import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:my_music_app/controller/splashscreencontroller.dart';
import 'package:my_music_app/widgets/text_widget.dart';

import '../pages/dashboard.dart';
class ScanBluetoothDevice extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    // controller.checkIfUserHasPermission();
    BluetoothDevice _device;
    controller.scanDevice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(30.0.sp),
          child: Column(
            children: [
              SizedBox(
                height: 20.sp,
              ),
              Align(
                alignment: Alignment.center,
                child: ImageFade(
                  // whenever the image changes, it will be loaded, and then faded in:
                  image: AssetImage(
                    controller.imageString.value,
                  ),
                  height: 200,
                  width: 200,
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
                        color: Colors.white30, size: 80.0),
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
                  value: controller.description.value,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(controller.currentColor.value),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 50.sp,
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedContainer(
            width: Get.width,
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: EdgeInsets.all(30.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          value: "Discover Nearby Devices",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(controller.currentColor.value),
                          textAlign: TextAlign.center),
                      InkWell(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              TextWidget(
                                  value: "Scan Again",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffE5554D),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        onTap: (){
                          controller.scanDevice();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  TextWidget(
                      value: "Find nearby devices with Bluetooth turned on.",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(controller.currentColor.value),
                      textAlign: TextAlign.start),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: controller.bluetoothManager.scanResults,
                      initialData: [],
                      builder: (c, snapshot) => ListView(
                        padding: EdgeInsets.all(0.0.sp),
                        children: snapshot.data
                            !.map((d) => ListTile(
                          title: TextWidget(
                              value: d.name ?? '',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(controller.currentColor.value),
                              textAlign: TextAlign.start),
                          subtitle: TextWidget(
                                      value: d.address ?? '',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          const Color(0xff707070),
                                      textAlign: TextAlign.start),
                          onTap: (){
                            controller.bluetoothManager.connect(d);
                            Get.off(Dashboard());
                          },
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
