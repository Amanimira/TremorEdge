import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:tremor_ring_app/services/emergency_service.dart';
import 'package:tremor_ring_app/utils/colors.dart';

/// SOS Button with Long Press activation + Countdown confirmation
/// ✅ Prevents accidental activation
/// ✅ Provides clear feedback to user
/// ✅ 5-second countdown with visual/haptic feedback
/// ✅ Large touch target (72dp) for trembling hands
class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pressController;
  late AnimationController _countdownController;
  
  int _countdownSeconds = 5;
  bool _isCountingDown = false;
  bool _sosActivated = false;
  bool _isPressing = false;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for breathing effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Press animation
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Countdown animation
    _countdownController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  /// Start long press sequence
  void _onPressDown(LongPressStartDetails details) {
    if (_sosActivated || _isCountingDown) return;
    
    setState(() => _isPressing = true);
    _pressController.forward();
    Vibration.vibrate(duration: 100); // Light haptic feedback
  }

  /// Cancel on release before 2 seconds
  void _onPressCancel() {
    if (_sosActivated || _isCountingDown) return;
    
    setState(() => _isPressing = false);
    _pressController.reverse();
  }

  /// Start countdown after long press (2+ seconds)
  void _startCountdown() {
    if (_sosActivated || _isCountingDown) return;
    if (!mounted) return;
    
    setState(() {
      _isCountingDown = true;
      _countdownSeconds = 5;
      _isPressing = false;
    });

    // Strong haptic feedback
    Vibration.vibrate(duration: 200);
    _pressController.reverse();

    // Start countdown animation
    _countdownController.reset();
    _countdownController.forward();

    // Update countdown every second
    int secondsRemaining = 5;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_isCountingDown) return false;
      
      secondsRemaining--;
      setState(() => _countdownSeconds = secondsRemaining);
      
      // Haptic feedback on each second
      Vibration.vibrate(duration: 100);
      
      if (secondsRemaining == 0) {
        _activateSOS();
        return false;
      }
      return true;
    });
  }

  /// Activate SOS and call emergency service
  void _activateSOS() {
    if (!mounted) return;
    
    setState(() => _sosActivated = true);
    
    // Heavy haptic feedback pattern
    _playSuccessPattern();
    
    // Call emergency service
    context.read<EmergencyService>().quickEmergencyCall();
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Emergency services contacted!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Cancel SOS before activation
  void _cancelSOS() {
    if (!mounted) return;
    
    setState(() {
      _isCountingDown = false;
      _sosActivated = false;
      _countdownSeconds = 5;
    });
    
    _countdownController.reset();
    
    // Light haptic feedback
    Vibration.vibrate(duration: 50);
  }

  /// Play success haptic pattern
  Future<void> _playSuccessPattern() async {
    await Vibration.vibrate(duration: 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 100);
  }

  @override
  Widget build(BuildContext context) {
    // Show countdown overlay if counting down
    if (_isCountingDown) {
      return _buildCountdownOverlay();
    }

    // Show SOS button with pulse animation
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, right: 20),
      child: ScaleTransition(
        scale: Tween(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        ),
        child: GestureDetector(
          onLongPressStart: _onPressDown,
          onLongPressEnd: (_) => _onPressCancel(),
          onLongPressUp: _startCountdown,
          onLongPressMoveUpdate: (details) {
            // Optional: Handle movement during long press
          },
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 0.95).animate(
              CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
            ),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.5),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                  if (_isPressing)
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 12,
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onLongPress: _startCountdown,
                  customBorder: const CircleBorder(),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emergency,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Countdown overlay with large numbers and cancel button
  Widget _buildCountdownOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: 0,
      child: GestureDetector(
        onTap: () {}, // Prevent interaction outside
        child: Container(
          color: Colors.black.withValues(alpha: 0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large countdown number
              ScaleTransition(
                scale: Tween(begin: 0.8, end: 1.2).animate(
                  CurvedAnimation(
                    parent: _countdownController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Text(
                  _countdownSeconds.toString(),
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Warning message
              const Text(
                '⚠️ EMERGENCY ALERT',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Emergency services will be contacted in a few seconds.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              
              // Cancel button
              SizedBox(
                width: 240,
                height: 68,
                child: ElevatedButton.icon(
                  onPressed: _cancelSOS,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                    elevation: 8,
                  ),
                  icon: const Icon(
                    Icons.check_circle,
                    size: 32,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'I\'M OKAY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              
              // Additional instructions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Tap the green button above or wait ${_countdownSeconds}s',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
