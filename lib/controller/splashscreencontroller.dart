import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:get/get.dart';

class SplashScreenController {
  RxString error = "".obs;
  RxString imageString = "assets/ellipse1.png".obs;
  RxString contentTitle = "Harmony Hub".obs;
  RxString contentAbout = "Discover. Listen. Enjoy.".obs;
  RxString callForAction = "Power Up".obs;
  RxString description =
      "Explore new music, listen to your favorites, and enjoy the ultimate music experience with our app"
          .obs;
  RxInt currentColor = 0xff335571.obs;
  RxInt currentSecColor = 0xffB3C6D7.obs;
  RxInt currentPage = 0.obs;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  displayPage() {
    switch (currentPage.value) {
      case 0:
        imageString.value = "ellipse1.png";
        contentTitle.value = "Harmony Hub";
        contentAbout.value = "Discover. Listen. Enjoy.";
        callForAction.value = "Power Up";
        description.value =
            "Explore new music, listen to your favorites, and enjoy the ultimate music experience with our app";
        currentColor.value = 0xff335571;
        currentSecColor.value = 0xffB3C6D7;
        break;
      case 1:
        imageString.value = "assets/Ellipse -1.png";
        contentTitle.value = "Rhythmic Beats";
        contentAbout.value = "Your Gateway to the World of Music";
        callForAction.value = "Speakers Ready";
        description.value =
            "Step into a world of endless musical possibilities with our app.";
        currentColor.value = 0xff858688;
        currentSecColor.value = 0xff000000;
        break;
      case 2:
        imageString.value = "assets/Ellipse -2.png";
        contentTitle.value = "TuneWave";
        contentAbout.value = "Where Sound Meets Soul";
        callForAction.value = "Song Picked";
        description.value =
            "Let the power of music touch your soul as you embark on a musical adventure with us.";
        currentColor.value = 0xff555D52;
        currentSecColor.value = 0xffC8D0C2;
        break;
      case 3:
        imageString.value = "assets/Ellipse -3.png";
        contentTitle.value = "SoundSculpt";
        contentAbout.value = "Elevate Your Audio Experience";
        callForAction.value = "Listen";
        description.value =
            " Elevate your audio experience like never before with our curated collection of tracks and playlists.";
        currentColor.value = 0xffE5554D;
        currentSecColor.value = 0xffE2B9B2;
        break;
      case 4:
        imageString.value = "assets/ellipse1.png";
        contentTitle.value = "SonicBlend";
        contentAbout.value = "";
        callForAction.value = "";
        description.value =
            "Implies the mixing and blending of sounds in a harmonious way.";
        currentColor.value = 0xff335571;
        currentSecColor.value = 0xff335571;
        break;
    }
  }

   Future<Stream> scanDevice() async {
    //scan
  bluetoothManager
        .startScan(timeout: const Duration(seconds: 4))
        .then((value) => {

    });

     final result = bluetoothManager.scanResults;

     return result;
  }
}
