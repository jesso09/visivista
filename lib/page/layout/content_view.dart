import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visivista/api/content_api.dart';
import 'package:visivista/model/content.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/style/color_palete.dart';

//for hosted
class ContentView extends StatefulWidget {
  const ContentView({super.key, required this.id});

  final int id;

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  VideoPlayerController? controller;
  late bool isPlaying = false;
  ContentApi contentApi = ContentApi();
  Content? content;
  late Future<Content> dataContent;
  String image = "";
  String video = "";
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

  void initContent() {
    dataContent = contentApi.getContent(widget.id);
    dataContent.then((value) {
      if (mounted) {
        setState(() {
          content = value;
          if (content?.video != null) {
            video = '${baseUrl}content/video/${content?.video}';
            controller = VideoPlayerController.networkUrl(
              Uri.parse(video),
              httpHeaders: {
                'Authorization': 'Bearer ${GlobalItem.userToken}',
              },
            )..initialize().then((_) {
                setState(() {
                  controller!.addListener(videoEndListener);
                });
              });
            GlobalItem.contentFilePath = video;
            GlobalItem.contentType = "video";
          } else if (content?.photo != null) {
            image = '${baseUrl}content/photo/${content?.photo}';
            GlobalItem.contentFilePath = image;
            GlobalItem.contentType = "image";
          }
        });
      }
    });
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
    return content != null
        ? SizedBox(
            height: 400,
            width: 400,
            child: Center(
              child: content?.video != null
                  ? controller != null && controller!.value.isInitialized
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
                      child: Image.network(
                        image,
                        headers: {
                          'Authorization': 'Bearer ${GlobalItem.userToken}',
                        },
                      ),
                    ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: ColorPalette.sandyBrown,
            ),
          );
  }
}

//for localhost
// class ContentView extends StatefulWidget {
//   const ContentView({super.key, required this.id});

//   final int id;

//   @override
//   State<ContentView> createState() => _ContentViewState();
// }

// class _ContentViewState extends State<ContentView> {
//   VideoPlayerController? controller;
//   late bool isPlaying = false;
//   ContentApi contentApi = ContentApi();
//   Content? content;
//   late Future<Content> dataContent;
//   String image = "";
//   String video = "";
//   String baseUrl = GlobalApi.getBaseUrl();

//   @override
//   void initState() {
//     super.initState();
//     initContent();
//   }

//   @override
//   void dispose() {
//     controller?.removeListener(videoEndListener);
//     controller?.pause();
//     controller?.dispose();
//     super.dispose();
//   }

//   void initContent() {
//     dataContent = contentApi.getContent(widget.id);
//     dataContent.then((value) {
//       if (mounted) {
//         setState(() {
//           content = value;
//           if (content?.video != null) {
//             video = "assets/test/vid.mp4";
//             controller = VideoPlayerController.asset(video)
//               ..initialize().then((_) {
//                 setState(() {
//                   controller!.addListener(videoEndListener);
//                 });
//               });
//           } else if (content?.photo != null) {
//             image = '${baseUrl}photo/${content?.photo}';
//           }
//         });
//       }
//     });
//   }

//   void togglePlay() {
//     setState(() {
//       if (controller != null && controller!.value.isPlaying) {
//         controller!.pause();
//       } else {
//         controller!.play();
//       }
//       isPlaying = controller != null && controller!.value.isPlaying;
//     });
//   }

//   void videoEndListener() {
//     if (controller != null &&
//         controller!.value.position == controller!.value.duration) {
//       setState(() {
//         controller!.seekTo(const Duration(seconds: 0));
//         controller!.pause();
//         isPlaying = false;
//       });
//     }
//   }

//   Widget contentPlay() => controller!.value.isPlaying
//       ? Container()
//       : Container(
//           alignment: Alignment.center,
//           color: ColorPalette.black.withOpacity(.26),
//           child: const Icon(
//             Icons.play_arrow,
//             size: 80,
//             color: ColorPalette.white,
//           ));

//   @override
//   Widget build(BuildContext context) {
//     return content != null
//         ? SizedBox(
//             height: 400,
//             width: 400,
//             child: Center(
//               child: content?.video != null
//                   ? controller != null && controller!.value.isInitialized
//                       ? GestureDetector(
//                           onTap: () {
//                             togglePlay();
//                           },
//                           child: AspectRatio(
//                             aspectRatio: controller!.value.aspectRatio,
//                             child: Stack(
//                               children: [
//                                 VideoPlayer(controller!),
//                                 contentPlay(),
//                                 Positioned(
//                                   left: 0,
//                                   right: 0,
//                                   bottom: 0,
//                                   child: VideoProgressIndicator(
//                                     controller!,
//                                     allowScrubbing: true,
//                                     padding: const EdgeInsets.all(8),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       : const CircularProgressIndicator(
//                           color: ColorPalette.sandyBrown,
//                         )
//                   : SizedBox(
//                       height: 400,
//                       width: 400,
//                       child: Image.network(image),
//                     ),
//             ),
//           )
//         : const Center(
//             child: CircularProgressIndicator(
//               color: ColorPalette.sandyBrown,
//             ),
//           );
//   }
// }
