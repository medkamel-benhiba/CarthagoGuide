import 'dart:async';
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/models/hotel.dart';
import 'package:CarthagoGuide/providers/hotel_provider.dart';
import 'package:CarthagoGuide/widgets/descriptionWithTTS.dart';
import 'package:CarthagoGuide/widgets/hotels/contact_section.dart';
import 'package:CarthagoGuide/widgets/hotels/detail_action_button.dart';
import 'package:CarthagoGuide/widgets/hotels/facility_item.dart';
import 'package:CarthagoGuide/widgets/hotels/gallery_section_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailsScreen({super.key, required this.hotel});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  VideoPlayerController? _videoController;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _showVideo = true;
  bool _isLoading = true;
  bool _isVideoInitializing = false;
  PageController? _imagePageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHotelDetails();

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  Future<void> _loadHotelDetails() async {
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    await hotelProvider.fetchHotelDetail(widget.hotel.slug);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      final hotelDetail = hotelProvider.selectedHotel;
      final videoLink = hotelDetail?.videoLink;

      if (videoLink != null && videoLink.isNotEmpty) {
        _initializeVideo(videoLink);
      }
    }
  }

  void _initializeVideo(String videoUrl) {
    if (_videoController != null) {
      _videoController!.dispose();
    }

    setState(() {
      _isVideoInitializing = true;
    });

    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _isVideoInitializing = false;
              });
              _videoController?.play();
              _videoController?.setLooping(true);
              _videoController?.setVolume(0.0);
            }
          })
          .catchError((e) {
            debugPrint("Error initializing network video: $e");
            if (mounted) {
              setState(() {
                _isVideoInitializing = false;
              });
            }
          });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _imagePageController?.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  String _stripHtmlTags(String htmlText) {
    if (htmlText.isEmpty) return '';
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true);
    String plainText = htmlText.replaceAll(exp, '');
    plainText = plainText
        .replaceAll(RegExp(r'&[a-z]+;'), ' ')
        .replaceAll('\r\n', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .replaceAll(' ', ' ')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();
    return plainText;
  }

  String _buildStarRating(int rating) {
    int count = rating.clamp(1, 5);
    return List.generate(count, (_) => '★').join() +
        List.generate(5 - count, (_) => '☆').join();
  }

  String _getTtsLanguageCode(String localeCode) {
    switch (localeCode.toLowerCase()) {
      case 'ar':
        return 'ar-SA';
      case 'en':
        return 'en-US';
      case 'fr':
        return 'fr-FR';
      case 'ru':
        return 'ru-RU';
      case 'ko':
        return 'ko-KR';
      case 'zh':
        return 'zh-CN';
      case 'ja':
        return 'ja-JP';
      default:
        return 'en-US';
    }
  }

  Future<void> _speakDescription(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      setState(() {
        _isSpeaking = true;
      });

      final locale = context.locale;
      final ttsLanguageCode = _getTtsLanguageCode(locale.languageCode);

      try {
        await _flutterTts.setLanguage(ttsLanguageCode);
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setVolume(1.0);
        await _flutterTts.setPitch(1.0);

        await _flutterTts.speak(text);
      } catch (e) {
        debugPrint("TTS Error: $e");
        if (mounted) {
          setState(() {
            _isSpeaking = false;
          });
        }
      }
    }
  }

  void _onGalleryImageTap(int imageIndex, List<String> images) {
    setState(() {
      _showVideo = false;
      _currentImageIndex = imageIndex;

      if (_videoController?.value.isInitialized == true &&
          _videoController!.value.isPlaying) {
        _videoController?.pause();
      }

      if (_imagePageController == null) {
        _imagePageController = PageController(initialPage: imageIndex);
      } else {
        _imagePageController!.jumpToPage(imageIndex);
      }
    });
  }

  void _onPlayVideoTap() {
    setState(() {
      _showVideo = true;
      if (_videoController?.value.isInitialized == true) {
        _videoController?.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final locale = context.locale;

    return Scaffold(
      backgroundColor: theme.background,
      body: Consumer<HotelProvider>(
        builder: (context, hotelProvider, _) {
          if (_isLoading || hotelProvider.isLoadingDetail) {
            return Center(
              child: CircularProgressIndicator(color: theme.primary),
            );
          }
          if (hotelProvider.errorDetail != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: theme.text.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hotelProvider.errorDetail!,
                    style: TextStyle(color: theme.text, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadHotelDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                    ),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            );
          }

          final hotelDetail = hotelProvider.selectedHotel;

          final name = hotelDetail != null
              ? hotelDetail.getName(locale)
              : widget.hotel.getName(locale);

          final description = hotelDetail != null
              ? hotelDetail.getDescription(locale)
              : widget.hotel.getDescription(locale);

          final destinationName = widget.hotel.getDestinationName(locale);

          final address = hotelDetail != null
              ? hotelDetail.getAddress(locale)
              : widget.hotel.getAddress(locale);

          final categoryCode = widget.hotel.categoryCode;

          final email = hotelDetail?.email ?? widget.hotel.email;
          final phone = hotelDetail?.phone ?? widget.hotel.phone;
          final images = hotelDetail?.images ?? widget.hotel.images ?? [];
          final videoLink = hotelDetail?.videoLink;

          return Stack(
            children: [
              Container(
                height: size.height * 0.45,
                color: Colors.black,
                child: _showVideo && videoLink != null && videoLink.isNotEmpty
                    ? _videoController != null &&
                              _videoController!.value.isInitialized
                          ? FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            )
                          : Center(
                              child: _isVideoInitializing
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.video_library,
                                      size: 60,
                                      color: Colors.white54,
                                    ),
                            )
                    : images.isNotEmpty
                    ? Stack(
                        children: [
                          PageView.builder(
                            controller: _imagePageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: images[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                              );
                            },
                          ),
                          if (images.length > 1)
                            Positioned(
                              bottom: 60,
                              left: 300,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.photo_library_outlined,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${_currentImageIndex + 1} / ${images.length}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    : const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
              ),

              // Back button and video toggle
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DetailActionButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          hotelProvider.clearSelectedHotel();
                          Navigator.pop(context);
                        },
                      ),
                      if (!_showVideo &&
                          videoLink != null &&
                          videoLink.isNotEmpty)
                        DetailActionButton(
                          icon: Icons.play_circle_outline,
                          onTap: _onPlayVideoTap,
                        ),
                    ],
                  ),
                ),
              ),

              // Content
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size.height * 0.60,
                  decoration: BoxDecoration(
                    color: theme.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: theme.text,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Star rating
                        Text(
                          _buildStarRating(categoryCode?.toInt() ?? 0),
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 22,
                            letterSpacing: 4.0,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Destination
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: theme.text,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              destinationName ?? "",
                              style: TextStyle(color: theme.text, fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Gallery
                        GallerySection(
                          theme: theme,
                          galleryImages: images,
                          onImageTap: (index) =>
                              _onGalleryImageTap(index, images),
                        ),

                        const SizedBox(height: 30),

                        // Amenities
                        Text(
                          'details.amenities'.tr(),
                          style: TextStyle(
                            color: theme.text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FacilityItem(
                              icon: Icons.wifi,
                              label: 'details.wifi'.tr(),
                            ),
                            FacilityItem(
                              icon: FontAwesomeIcons.bath,
                              label: 'details.spa'.tr(),
                            ),
                            FacilityItem(
                              icon: FontAwesomeIcons.utensils,
                              label: 'details.restaurant'.tr(),
                            ),
                            FacilityItem(
                              icon: Icons.pool,
                              label: 'details.pool'.tr(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Description
                        DescriptionWithTts(
                          theme: theme,
                          description: description ?? "",
                          isSpeaking: _isSpeaking,
                          onSpeakToggle: () => _speakDescription(
                            _stripHtmlTags(description ?? ""),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Contact Information
                        ContactSection(
                          theme: theme,
                          email: email,
                          phone: phone,
                          address: address ?? "",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
