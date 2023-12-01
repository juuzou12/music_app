
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


class DashboardController {
  RxList musicFromLocalStorage = [].obs;

  DashboardController(){
    fetchMusic();
  }
  Future<void> fetchMusic() async {
    if (GetPlatform.isAndroid) {
      await searchForMusic(Directory('/storage/emulated/0/Music')); // Start from the primary external storage on Android
    } else if (GetPlatform.isIOS) {
      await searchForMusic(await getApplicationDocumentsDirectory()); // Start from the app's document directory on iOS
    }
  }
  Future<void> searchForMusic(Directory directory) async {
    try {
      List<FileSystemEntity> entities = directory.listSync();

      for (var entity in entities) {
        if (entity is File) {
          if (isMusicFile(entity.path)) {
            if(entity.path.toLowerCase() != '/storage/emulated/0/android/data'.toLowerCase()){
              musicFromLocalStorage.add(entity);
            }
          }
        } else if (entity is Directory) {
          // Recursively search in subdirectories
          await searchForMusic(entity);
        }
      }
    } catch (e) {
      print('Error while searching: $e');
    }
  }
  bool isMusicFile(String filePath) {
    // You can define your own criteria to identify music files here
    // For example, check if the file has a common music file extension like .mp3, .wav, .flac, etc.
    return filePath.toLowerCase().endsWith('.mp3')||
        filePath.toLowerCase().endsWith('.wav') ||
        filePath.toLowerCase().endsWith('.flac');
  }

  String getTrackName(File musicFile) {
    return musicFile.uri.pathSegments.last;
  }
  Future<Uint8List?> getAlbumArt(File filePath) async {
    final Uint8List? bytes = await filePath.readAsBytes();
    return bytes;
  }

  String getArtist(File musicFile){
    if(getTrackName(musicFile).contains("-")){
      return  getTrackName(musicFile).substring(0,getTrackName(musicFile).indexOf("-"));
    }
    return "Unknown Artist";
  }
  final AudioPlayer audioPlayer = AudioPlayer();
  RxString currentTrackPath = "".obs; // Keep track of the currently playing track
  RxString showTrack = "".obs; // Keep track of the currently playing track
  RxString currentArtist = "".obs; // Keep track of the currently playing track
  RxBool isPlaying = false.obs;
  RxString currentPath = "".obs;
  RxString currentPage = "Home".obs;
  RxDouble  progress = 0.0.obs;
  RxDouble  timeOfTrack = 0.0.obs;
  RxString trackDuration = "0.0".obs;
  RxString currentTrackTime = "0.0".obs;
  // Play a specific music file
  Future<void> playMusic(File filePath) async {
    if (filePath == currentTrackPath) {
      // If the same track is already playing, pause or resume it
      if (audioPlayer.state == PlayerState.paused) {
        await audioPlayer.resume();
      } else if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.pause();
      }
    } else {
      // Play a new track
      await audioPlayer.stop();
      final result = await audioPlayer.play(DeviceFileSource(filePath.path),).then((value) {
        currentTrackPath.value = getTrackName(filePath);
        currentArtist.value = getArtist(filePath);
        currentPath.value = filePath.path;
        isPlaying.value= true;
        showTrackTimer();
      }); // Use filePath as the source
    }
  }


  // Pause the currently playing track
  Future<void> pauseMusic() async {
    await audioPlayer.pause();
    isPlaying.value= false;
  }

  // Resume the currently paused track
  Future<void> resumeMusic() async {
    await audioPlayer.resume();
    isPlaying.value= true;
  }

  // Stop the currently playing track
  Future<void> stopMusic() async {
    await audioPlayer.stop();
    isPlaying.value= false;
  }

  // Dispose of the audio player when it's no longer needed
  void dispose() {
    audioPlayer.dispose();
  }
  String t="";
  void showTrackTimer() {
    audioPlayer.onDurationChanged.listen((Duration duration) {
      timeOfTrack.value = duration.inSeconds.toDouble();
      trackDuration.value = formatDuration(duration);
    }).onError((error, stackTrace) {
      print(error.toString());
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      progress.value = position.inSeconds.toDouble() / timeOfTrack.value;
      currentTrackTime.value = formatDuration(position);
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }
  String formatDuration(Duration? duration) {
    int minutes = duration!.inMinutes;
    int seconds = duration.inSeconds - (minutes * 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  String formatDurationRemaining(Duration? duration) {
    int minutes = duration!.inMinutes;
    int seconds = duration.inSeconds - (minutes * 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
