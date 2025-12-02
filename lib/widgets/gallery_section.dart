import 'package:carthagoguide/widgets/gallery_images.dart';
import 'package:carthagoguide/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';

class GallerySectionWidget extends StatelessWidget {
  final AppTheme theme;
  final List<String> galleryImages;

  const GallerySectionWidget({
    super.key,
    required this.theme,
    required this.galleryImages,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Get the screen width for responsive layout logic
    final screenWidth = MediaQuery.of(context).size.width;

    // 2. Determine the number of columns based on screen size
    // For large screens (e.g., tablets/desktop), we can use a more complex layout.
    // Let's define a breakpoint, for example, 600.0.
    final isLargeScreen = screenWidth > 600.0;

    // We will use a Column instead of a ListView.separated inside a SizedBox
    // to allow the content to take the necessary vertical space, making it responsive
    // to the number of images and the available screen height.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Takes only the space needed
      children: [
        SectionTitleWidget(title: "Galerie", theme: theme),
        const SizedBox(height: 15), // Add separation after title

        // Use a Column builder or a loop to generate the image rows
        ...List.generate((galleryImages.length / (isLargeScreen ? 4 : 3)).ceil(), (index) {
          final startIndex = index * (isLargeScreen ? 4 : 3);

          // Layout logic for Mobile (2+1 format):
          if (!isLargeScreen) {
            final image1 = galleryImages.length > startIndex
                ? galleryImages[startIndex]
                : null;
            final image2 = galleryImages.length > startIndex + 1
                ? galleryImages[startIndex + 1]
                : null;
            final image3 = galleryImages.length > startIndex + 2
                ? galleryImages[startIndex + 2]
                : null;

            return Padding(
              padding: EdgeInsets.only(bottom: index == (galleryImages.length / 3).ceil() - 1 ? 0 : 15),
              child: Column(
                children: [
                  // Image 1 (Full Width)
                  if (image1 != null)
                    GalleryImageWidget(
                      theme: theme,
                      imgUrl: image1,
                      aspectRatio: 2.0,
                    ),

                  // Image 2 & 3 (Half Width)
                  if (image2 != null || image3 != null)
                    const SizedBox(height: 15),

                  if (image2 != null || image3 != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (image2 != null)
                          Expanded(
                            child: GalleryImageWidget(
                              theme: theme,
                              imgUrl: image2,
                              aspectRatio: 1.0,
                            ),
                          ),
                        if (image2 != null && image3 != null)
                          const SizedBox(width: 15),
                        if (image3 != null)
                          Expanded(
                            child: GalleryImageWidget(
                              theme: theme,
                              imgUrl: image3,
                              aspectRatio: 1.0,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            );
          }

          // Layout logic for Large Screens (e.g., 2x2 grid, or simple 4-image row):
          else {
            final image4 = galleryImages.length > startIndex + 3
                ? galleryImages[startIndex + 3]
                : null;

            return Padding(
              padding: EdgeInsets.only(bottom: index == (galleryImages.length / 4).ceil() - 1 ? 0 : 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 3; i++)
                    if (galleryImages.length > startIndex + i)
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GalleryImageWidget(
                                theme: theme,
                                imgUrl: galleryImages[startIndex + i],
                                aspectRatio: 1.0,
                              ),
                            ),
                            if (i < 3 && galleryImages.length > startIndex + i + 1)
                              const SizedBox(width: 15),
                          ],
                        ),
                      ),
                ],
              ),
            );
          }
        }),
      ],
    );
  }
}