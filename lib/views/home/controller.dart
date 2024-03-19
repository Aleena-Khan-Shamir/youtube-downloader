import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeController extends GetxController {
  final TextEditingController textController = TextEditingController();
  RxBool isShow = false.obs;
  final formKey = GlobalKey<FormState>();
  changeIndex() {
    isShow.value = !isShow.value;
    update();
    log('${isShow.value}');
  }

  RxBool isDownload = false.obs;
  changedownload() {
    isDownload.value = !isDownload.value;
    update();
    log('${isDownload.value}');
  }

  late String thumbnailUrl = '';
  late String title = '';
  late Duration? duration = const Duration();
  Future<void> fetchVideoThumbnail() async {
    isShow.value = true;
    var ytExplode = YoutubeExplode();
    var video = await ytExplode.videos.get(textController);
    thumbnailUrl = video.thumbnails.highResUrl;
    title = video.title;
    duration = video.duration;
    update();
    isShow.value = false;
  }

  RxDouble downloadProgress = 0.0.obs;
  Future<void> downloadVideo(String videoUrl) async {
    isDownload.value = true;
    try {
      var ytExplode = YoutubeExplode();

      var video = await ytExplode.videos.get(videoUrl);
      var manifest = await ytExplode.videos.streamsClient.getManifest(video.id);
      var videoStream = manifest.muxed.withHighestBitrate();
      var totalSize = videoStream.size.totalBytes.toDouble();
      var downloadedBytes = 0;
      var videoStreamData1 = <int>[];
      await for (var data in ytExplode.videos.streamsClient.get(videoStream)) {
        videoStreamData1.addAll(data);
        downloadedBytes += data.length;
        downloadProgress.value = downloadedBytes / totalSize;
      }
      await saveVideo(videoStreamData1, video.title);
      isDownload.value = false;
    } catch (error) {
      log('downloading error: $error');
    }
  }

  Future<void> saveVideo(List<int> videoStream, String videoTitle) async {
    try {
      final savePath = '/storage/emulated/0/Download/$videoTitle.mp4';

      final file = File(savePath);
      await file.writeAsBytes(videoStream);
      Get.snackbar('Success ', 'Download in your gallery');
      log('Video saved at: $savePath');
    } catch (error) {
      log('Error: $error');
    }
  }
}
