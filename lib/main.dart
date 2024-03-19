import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/config/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Youtube downloader',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/home',
      getPages: AppPages.pages,
    );
  }
}
