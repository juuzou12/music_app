import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:my_music_app/controller/dashboardcontroller.dart';
import 'package:sqflite/sqflite.dart';

import '../functions/localstorage.dart';
import '../widgets/text_widget.dart';

class NowPlaying extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(child: const Icon(Icons.navigate_before_outlined,size: 40,color: Color(0xff335571),),
        onTap: (){
          Get.back();
        },),
        actions:  [
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.more_vert,color: Color(0xff335571)),
            ),
            onTap: (){
              Get.bottomSheet(Container(
                width: Get.width,
                height: 300,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: TextWidget(
                            value:
                            controller.getTrackName(File(controller.currentTrackPath.value)),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff335571),
                            textAlign: TextAlign.start),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextWidget(
                              value:
                              controller.getArtist(File(controller.currentTrackPath.value)),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff707070),
                              textAlign: TextAlign.start),
                        ),
                      ),
                      Expanded(child: ListView(
                        children: [
                          {
                            "title": "Like",
                            "icon": Icon(Icons.favorite_border,color: Color(0xff335571),size: 20,),
                            "function":()async{


                            }
                          },
                          {
                            "title": "Add to playlist",
                            "icon": Icon(Icons.playlist_add_sharp,color: Color(0xff335571),size: 20,),
                            "function":(){

                            }
                          },
                          {
                            "title": "Add to queue",
                            "icon": Icon(Icons.queue_music_outlined,color: Color(0xff335571),size: 20,),
                            "function":(){

                            }
                          },
                        ].map((e) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            child: Row(
                              children: [
                                (e['icon'])as Widget,
                                const SizedBox(width: 10,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextWidget(
                                      value:e['title'].toString(),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff335571),
                                      textAlign: TextAlign.start),
                                )],
                            ),
                            onTap: (e["function"] as void Function()?),
                          ),
                        )).toList(),
                      ))
                    ],
                  ),
                ),
              ));
            },
          )
        ],
      ),
      body: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 200,
              child: ImageFade(
                // whenever the image changes, it will be loaded, and then faded in:
                image: const AssetImage(
                  "assets/ellipse1.png",
                ),

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
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Padding(
            padding:  EdgeInsets.all(15.0.sp),
            child: TextWidget(
                value: controller.currentTrackPath.value,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff335571),
                textAlign: TextAlign.center),
          ),
          SizedBox(
            height: 10.sp,
          ),
          TextWidget(
              value: controller.currentArtist.value,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xff707070),
              textAlign: TextAlign.center),
          SizedBox(
            height: 50.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.skip_previous_outlined,
                size: 30,
                color: Color(0xffE5554D),
              ),
              Obx(
                    () => controller.isPlaying.isTrue
                    ? InkWell(
                  child: const Icon(
                    Icons.pause,
                    size: 60,
                    color: Color(0xffE5554D),
                  ),
                  onTap: () {
                    controller.pauseMusic();
                  },
                )
                    : InkWell(
                  child: const Icon(
                    Icons.play_arrow_outlined,
                    size: 60,
                    color: Color(0xffE5554D),
                  ),
                  onTap: () {
                    controller.resumeMusic();
                  },
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.skip_next_outlined,
                  size: 30,
                  color: Color(0xffE5554D),
                ),
                onTap: () {
                  controller.showTrackTimer();
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                Obx(() => TextWidget(
                    value: controller.currentTrackTime.value,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff707070),
                    textAlign: TextAlign.center)),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child: Obx(() => LinearProgressIndicator(
                        value: controller.progress.value.isInfinite?0.0:
                        controller.progress.value,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(100),
                        backgroundColor: Color(0xffF1F1F1),
                      )),
                    )),
                Obx(() => TextWidget(
                    value: controller.trackDuration.value,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff707070),
                    textAlign: TextAlign.center)),
              ],
            ),
          ),
          Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: Get.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30.0.sp,top: 30.sp,bottom: 20),
                      child:  const TextWidget(
                          value: "Playing Next",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff335571),
                          textAlign: TextAlign.center),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(10.sp),
                        children: controller.musicFromLocalStorage
                            .skip(controller.musicFromLocalStorage.indexWhere(
                                (element) =>
                            controller
                                .getTrackName(element)
                                .toString() ==
                                controller.currentTrackPath.value) +
                            1)
                            .map((element) => InkWell(
                          child: ListTile(
                            title: TextWidget(
                              value: controller.getTrackName(element),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff335571),
                              textAlign: TextAlign.start,
                            ),
                            subtitle: TextWidget(
                              value: controller.getArtist(element),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff707070),
                              textAlign: TextAlign.start,
                            ),
                            trailing: controller.currentTrackPath.value ==
                                controller.getTrackName(element)
                                ? const SizedBox(
                              width: 18,
                              child: MiniMusicVisualizer(
                                color: Colors.red,
                                width: 4,
                                height: 15,
                              ),
                            )
                                : SizedBox(),
                          ),
                          onTap: () {
                            controller.playMusic(element);
                          },
                          onLongPress: () {},
                        ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              )),
        ],
      )),
    );
  }
}
