import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class CategoryRowWidget extends StatefulWidget {
  final AppTheme theme;
  final VoidCallback? onDestinationsTap;
  final VoidCallback? onHotelsTap;
  final VoidCallback? onRestaurantsTap;
  final VoidCallback? onCircuitsTap;
  final VoidCallback? onChatBotTap;

  const CategoryRowWidget({
    super.key,
    required this.theme,
    this.onDestinationsTap,
    this.onHotelsTap,
    this.onRestaurantsTap,
    this.onCircuitsTap,
    this.onChatBotTap,
  });

  @override
  State<CategoryRowWidget> createState() => _CategoryRowWidgetState();
}

class _CategoryRowWidgetState extends State<CategoryRowWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _iconController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();

    // Bounce and rotation controller
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    // Pulse/scale controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Glow controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Icon spin controller
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -12.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -12.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_bounceController);

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.08, end: -0.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.08, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_bounceController);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_pulseController);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_pulseController);

    _glowAnimation = Tween<double>(begin: 12.0, end: 20.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_glowController);

    _iconRotation = Tween<double>(begin: 0.0, end: 6.28319)
        .animate(_iconController);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'icon': Icons.hotel,
        'label': 'home.categories.hotels'.tr(),
        'onTap': widget.onHotelsTap,
        'isSpecial': false,
      },
      {
        'icon': Icons.restaurant,
        'label': 'home.categories.restaurants'.tr(),
        'onTap': widget.onRestaurantsTap,
        'isSpecial': false,
      },
      {
        'icon': Icons.smart_toy_outlined,
        'label': 'home.categories.chatbot'.tr(),
        'onTap': widget.onChatBotTap,
        'isSpecial': true,
      },
      {
        'icon': Icons.map,
        'label': 'home.categories.circuits'.tr(),
        'onTap': widget.onCircuitsTap,
        'isSpecial': false,
      },
      {
        'icon': Icons.location_on,
        'label': 'home.categories.destinations'.tr(),
        'onTap': widget.onDestinationsTap,
        'isSpecial': false,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map(
            (cat) => GestureDetector(
          onTap: cat['onTap'] as VoidCallback?,
          child: Column(
            children: [
              cat['isSpecial'] as bool
                  ? AnimatedBuilder(
                animation: Listenable.merge([
                  _bounceController,
                  _pulseController,
                  _glowController,
                  _iconController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          height: 68,
                          width: 68,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.theme.primary,
                                widget.theme.primary.withOpacity(0.7),
                                widget.theme.primary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, _pulseAnimation.value, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: widget.theme.primary.withOpacity(0.5),
                                blurRadius: _glowAnimation.value,
                                spreadRadius: _glowAnimation.value * 0.2,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: widget.theme.primary.withOpacity(0.3),
                                blurRadius: _glowAnimation.value * 1.5,
                                spreadRadius: _glowAnimation.value * 0.3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Animated gradient overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.3 * _pulseAnimation.value),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Transform.rotate(
                                  angle: _iconRotation.value,
                                  child: Icon(
                                    cat['icon'] as IconData,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.6),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'AI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: widget.theme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  cat['icon'] as IconData,
                  color: widget.theme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat['label'] as String,
                style: TextStyle(
                  color: cat['isSpecial'] as bool
                      ? widget.theme.primary
                      : widget.theme.text.withOpacity(0.8),
                  fontSize: cat['isSpecial'] as bool ? 13 : 12,
                  fontWeight: cat['isSpecial'] as bool
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}