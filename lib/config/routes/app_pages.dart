import 'package:get/get.dart';
import 'package:youtube_downloader/views/home/index.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
        name: '/home', page: () => const HomeView(), binding: HomeBindings())
  ];
}
