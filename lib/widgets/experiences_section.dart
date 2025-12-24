import 'package:CarthagoGuide/widgets/reel_circle.dart';
import 'package:CarthagoGuide/widgets/section_title.dart';
import 'package:CarthagoGuide/widgets/story_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class ExperiencesReelSection extends StatelessWidget {
  final AppTheme theme;
  final List<Map<String, dynamic>> experiencesReels;

  const ExperiencesReelSection({
    super.key,
    required this.theme,
    required this.experiencesReels,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(title: "home.sections.moments".tr(), theme: theme),
        const SizedBox(height: 15),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: experiencesReels.length,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final reel = experiencesReels[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StoryViewerScreen(
                        // Pass the list of segments (images) for this specific reel
                        segments: reel['segments'] as List<Map<String, dynamic>>,
                        reelTitle: reel['title']!,
                      ),
                    ),
                  );
                },
                child: ReelCircleWidget(
                  theme: theme,
                  title: reel['title']??"",
                  imgUrl: reel['preview_image']??"",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}