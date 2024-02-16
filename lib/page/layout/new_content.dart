import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/api/base_url.dart';

class NewContent extends StatefulWidget {
  const NewContent({super.key});

  @override
  State<NewContent> createState() => _NewContentState();
}

class _NewContentState extends State<NewContent> {
  VideoPlayerController? controller;
  late bool isPlaying = false;
  String image = "";
  String videoLocal = 'assets/test/vid.mp4';
  String baseUrl = GlobalApi.getBaseUrl();

  @override
  void initState() {
    super.initState();
    initContent();
  }

  @override
  void dispose() {
    controller?.removeListener(videoEndListener);
    controller?.pause();
    controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    initContent();
  }

  void initContent() {
    if (GlobalItem.videoPick != '') {
      setState(() {
        controller = VideoPlayerController.file(File(GlobalItem.videoPick))
          ..initialize().then((_) {
            setState(() {
              controller!.addListener(videoEndListener);
            });
          });
        GlobalItem.imagePick = '';
      });
    }
    if (GlobalItem.imagePick != '') {
      GlobalItem.videoPick = '';
    }
  }

  void togglePlay() {
    setState(() {
      if (controller != null && controller!.value.isPlaying) {
        controller!.pause();
      } else {
        controller!.play();
      }
      isPlaying = controller != null && controller!.value.isPlaying;
    });
  }

  void videoEndListener() {
    if (controller != null &&
        controller!.value.position == controller!.value.duration) {
      setState(() {
        controller!.seekTo(const Duration(seconds: 0));
        controller!.pause();
        isPlaying = false;
      });
    }
  }

  Widget contentPlay() => controller!.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: ColorPalette.black.withOpacity(.26),
          child: const Icon(
            Icons.play_arrow,
            size: 80,
            color: ColorPalette.white,
          ));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Center(
        child: GlobalItem.videoPick != ''
            ? controller!.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      togglePlay();
                    },
                    child: AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(controller!),
                          contentPlay(),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: VideoProgressIndicator(
                              controller!,
                              allowScrubbing: true,
                              padding: const EdgeInsets.all(8),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const CircularProgressIndicator(
                    color: ColorPalette.sandyBrown,
                  )
            : SizedBox(
                height: 400,
                width: 400,
                child: Image.file(File(GlobalItem.imagePick))),
      ),
    );
  }
}
