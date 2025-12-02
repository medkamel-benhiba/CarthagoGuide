// screens/story_viewer_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';

class StoryViewerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> segments;
  final String reelTitle;

  const StoryViewerScreen({
    super.key,
    required this.segments,
    required this.reelTitle,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late PageController _storySegmentPageController;
  int _currentStorySegmentIndex = 0;
  Timer? _timer;
  double _progress = 0.0;
  Duration _storyDuration = const Duration(seconds:3);

  @override
  void initState() {
    super.initState();
    _storySegmentPageController = PageController(initialPage: _currentStorySegmentIndex);
    _startStoryTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _storySegmentPageController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    _timer?.cancel();
    setState(() {
      _progress = 0.0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) return;

      setState(() {
        _progress += 0.5 / (_storyDuration.inMilliseconds / 50);
        if (_progress >= 1.0) {
          _timer?.cancel();
          _nextStorySegment();
        }
      });
    });
  }

  void _nextStorySegment() {
    // Use widget.segments.length
    if (_currentStorySegmentIndex < widget.segments.length - 1) {
      _currentStorySegmentIndex++;
      _storySegmentPageController.animateToPage(
        _currentStorySegmentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      _startStoryTimer();
    } else {
      // End of this reel's segments. Pop the screen.
      Navigator.of(context).pop();
    }
  }

  void _previousStorySegment() {
    if (_currentStorySegmentIndex > 0) {
      _currentStorySegmentIndex--;
      _storySegmentPageController.animateToPage(
        _currentStorySegmentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      _startStoryTimer();
    } else {
      // First story segment of the reel. Pop the screen.
      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          // Pause timer when screen is touched
          _timer?.cancel();
        },
        onTapUp: (details) {
          if (details.globalPosition.dx < MediaQuery.of(context).size.width / 2) {
            _previousStorySegment();
          } else {
            _nextStorySegment();
          }
          if (_timer == null || !_timer!.isActive) {
            _startStoryTimer();
          }
        },
        child: Stack(
          children: [
            // Story Content (Image)
            PageView.builder(
              controller: _storySegmentPageController,
              itemCount: widget.segments.length,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                if (_currentStorySegmentIndex != index) {
                  _currentStorySegmentIndex = index;
                  _startStoryTimer();
                }
              },
              itemBuilder: (context, index) {
                final segment = widget.segments[index];
                return Center(
                  child: Image.asset(
                    segment['url']!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                );
              },
            ),

            // Progress Indicators
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(widget.segments.length, (index) { // Use segments length
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: LinearProgressIndicator(
                        value: index == _currentStorySegmentIndex ? _progress : (index < _currentStorySegmentIndex ? 1.0 : 0.0),
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Reel Title/User Info
            Positioned(
              top: 65,
              left: 10,
              child: Text(
                widget.reelTitle,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            // Close Button
            Positioned(
              top: 55,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}