// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../constants.dart/colors.dart';

// class VideoPostWidget extends StatefulWidget {
//   final String title;
//   final String subtitle;
//   final String imageUrl;
//   final String timeAgo;
//   final String duration;
//   final String videoId;

//   const VideoPostWidget({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.imageUrl,
//     required this.timeAgo,
//     required this.duration,
//     required this.videoId,
//   });

//   @override
//   _VideoPostWidgetState createState() => _VideoPostWidgetState();
// }

// class _VideoPostWidgetState extends State<VideoPostWidget> {
//   late YoutubePlayerController _controller;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.primaryBlue,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Video • ${widget.timeAgo}",
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   widget.title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   widget.subtitle,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           _isPlaying
//               ? YoutubePlayer(
//                   controller: _controller,
//                   showVideoProgressIndicator: true,
//                   progressIndicatorColor: Colors.red,
//                   progressColors: const ProgressBarColors(
//                     playedColor: Colors.red,
//                     handleColor: Colors.redAccent,
//                   ),
//                   onReady: () {
//                     _controller.addListener(() {});
//                   },
//                 )
//               : Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(8),
//                         bottomRight: Radius.circular(8),
//                       ),
//                       child: Image.asset(
//                         widget.imageUrl,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.play_circle_fill,
//                         color: Colors.white,
//                         size: 50,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPlaying = true;
//                         });
//                       },
//                     ),
//                     Positioned(
//                       bottom: 8,
//                       right: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.7),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           widget.duration,
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 12),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
