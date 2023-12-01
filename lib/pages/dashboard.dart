import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:my_music_app/controller/dashboardcontroller.dart';
import 'package:my_music_app/functions/localstorage.dart';
import 'package:my_music_app/pages/nowplaying.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/button.dart';
import '../widgets/text_widget.dart';
import 'likedtrack.dart';

class Dashboard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              child: Obx(() => controller.currentPage.value=="Home"?ListView(
                    children: controller.musicFromLocalStorage
                        .map((element) => InkWell(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextWidget(
                                          value:
                                              controller.getTrackName(element),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff335571),
                                          textAlign: TextAlign.start),
                                    ),
                                    InkWell(
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.more_vert,
                                            size: 15,
                                          ),
                                        ),
                                        onTap: () {
                                          // controller.showTrack.value =
                                          //     controller.getTrackName(element);
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
                                                        controller.getTrackName(element),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(0xff335571),
                                                        textAlign: TextAlign.start),
                                                    subtitle: Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: TextWidget(
                                                          value:
                                                          controller.getArtist(element),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(0xff707070),
                                                          textAlign: TextAlign.start),
                                                    ),
                                                  ),
                                                  Expanded(child: ListView(
                                                    children: [
                                                      {
                                                        "title": "Play Track",
                                                        "icon": Icon(Icons.play_arrow_outlined,color: Color(0xff335571),size: 20,),
                                                        "function":(){
                                                          controller.playMusic(element);
                                                          Get.back();
                                                        }
                                                      },
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
                                        }),
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                            value:
                                                controller.getArtist(element),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff707070),
                                            textAlign: TextAlign.start),
                                        controller.currentTrackPath.value ==
                                                controller.getTrackName(element)
                                            ? const SizedBox(
                                                width: 18,
                                                child: MiniMusicVisualizer(
                                                  color: Colors.red,
                                                  width: 4,
                                                  height: 15,
                                                ),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                controller.playMusic(element);
                              },
                              onLongPress: () {},
                            ))
                        .toList(),
                  ):
                  LikeTrack()),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => Container(
            width: Get.width,
            height: controller.currentTrackPath.isNotEmpty ? 150 : 60,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50)),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => Visibility(
                      visible: controller.currentTrackPath.isNotEmpty,
                      child: Column(
                        children: [
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10.0.sp,
                                  left: 20.sp,
                                  right: 20.sp,
                                  top: 10.sp),
                              child: Obx(() => ListTile(
                                    title: TextWidget(
                                        value:
                                            controller.currentTrackPath.value,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff335571),
                                        textAlign: TextAlign.start),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: 8.0.sp),
                                      child: TextWidget(
                                          value: controller.currentArtist.value,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff707070),
                                          textAlign: TextAlign.start),
                                    ),
                                    trailing: controller.isPlaying.isTrue
                                        ? InkWell(
                                            child: Icon(
                                              Icons.pause,
                                              size: 30,
                                              color: Color(0xffE5554D),
                                            ),
                                            onTap: () {
                                              controller.pauseMusic();
                                            },
                                          )
                                        : InkWell(
                                            child: Icon(
                                              Icons.play_arrow_outlined,
                                              size: 30,
                                              color: Color(0xffE5554D),
                                            ),
                                            onTap: () {
                                              controller.resumeMusic();
                                            },
                                          ),
                                  )),
                            ),
                            onTap: () {
                              Get.to(NowPlaying());
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 10.0.sp, left: 20.sp, right: 20.sp),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ["Home", "My Likes", "Discover"]
                          .map(
                            (e) => Obx(() => InkWell(
                                  child: ButtonWidget(
                                      widget: Center(
                                        child: TextWidget(
                                            value: e,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                controller.currentPage.value ==
                                                        e
                                                    ? Colors.white
                                                    : Color(0xff335571),
                                            textAlign: TextAlign.center),
                                      ),
                                      height: 30,
                                      width: 100,
                                      radius: 100,
                                      color: controller.currentPage.value == e
                                          ? 0xff335571
                                          : 0xffFFFFFF,
                                      borderColor:
                                          controller.currentPage.value == e
                                              ? 0xff335571
                                              : 0xffFFFFFF),
                                  onTap: () {
                                    controller.currentPage.value = e;
                                  },
                                )),
                          )
                          .toList()),
                ),
              ],
            ),
          )),
    );
  }
}
