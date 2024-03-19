import 'package:get/get.dart';
import 'package:youtube_downloader/views/home/controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
