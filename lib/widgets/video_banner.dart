import 'package:CarthagoGuide/constants/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBanner extends StatefulWidget {
  final AppTheme theme;

  const VideoBanner({
    super.key,
    required this.theme,
  });

  @override
  State<VideoBanner> createState() => _VideoBannerState();
}

class _VideoBannerState extends State<VideoBanner> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/videos/tgt.mp4")
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    // RTL detection (easy_localization compatible)
    final bool isRTL =
        context.locale.languageCode == 'ar';

    return Stack(
      children: [
        // VIDEO
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _controller.value.isInitialized
              ? SizedBox(
            height: 170,
            width: double.infinity,
            child: VideoPlayer(_controller),
          )
              : Container(
            height: 170,
            width: double.infinity,
            color: Colors.black12,
          ),
        ),

        // GRADIENT OVERLAY
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        // TEXT CONTENT (RTL SAFE)
        Positioned(
          bottom: 20,
          left: isRTL ? null : 20,
          right: isRTL ? 20 : null,
          child: Column(
            crossAxisAlignment:
            isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.start,
            children: [
              // FEATURED BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "video.featured".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // TITLE
              Text(
                "video.discover_tunisia".tr(),
                textAlign:
                isRTL ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
