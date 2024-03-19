import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:youtube_downloader/views/home/controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'YOUTUBE\n',
                        style: Theme.of(context).textTheme.titleLarge),
                    TextSpan(
                        text: 'DOWNLOADER',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: const Color(0xffc9184a),
                            fontWeight: FontWeight.bold))
                  ])),
                  const SizedBox(height: 50),
                  Text('Enter Youtube URL',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: controller.textController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter url';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter your link/Url',
                        suffixIcon: IconButton(
                          onPressed: () => controller.textController.clear(),
                          icon: const Icon(Icons.clear_outlined, size: 15),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: size.height * 0.07,
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.changeIndex();
                              controller.fetchVideoThumbnail();
                            }
                          },
                          child: controller.isShow.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Generate Video Content')),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GetBuilder<HomeController>(
                      init: HomeController(),
                      builder: (controller) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.title,
                                maxLines: 3,
                                softWrap: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                                '${controller.duration!.inHours}:${controller.duration!.inMinutes}:${controller.duration!.inSeconds}'),
                          ],
                        );
                      }),
                  const SizedBox(height: 15),
                  Container(
                      height: size.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(15)),
                      child: Obx(
                        () => ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: controller.isShow.value ||
                                    controller.thumbnailUrl.isNotEmpty
                                ? controller.thumbnailUrl.isNotEmpty
                                    ? Image.network(
                                        controller.thumbnailUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Text(
                                                    'Error loading thumbnail'),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.view_comfy_alt_rounded),
                                      SizedBox(height: 10),
                                      Text('Video Preview goes here'),
                                    ],
                                  )),
                      )),
                  const SizedBox(height: 30),
                  SizedBox(
                      height: size.height * 0.07,
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.changedownload();
                                controller.downloadVideo(
                                    controller.textController.text);
                              }
                            },
                            child: controller.isDownload.value
                                ? LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 2500,
                                    percent: 1.0,
                                    center: Text(
                                        '${(controller.downloadProgress.value * 100).toStringAsFixed(2)}%'),
                                    progressColor: const Color(0xffd90429),
                                    backgroundColor: const Color(0xffd90429),
                                  )
                                : const Text('Download Video ')),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
