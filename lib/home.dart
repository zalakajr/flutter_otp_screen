import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:do_app/components/otbbutton.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  String currentText = '';
  TextEditingController otpController = TextEditingController();

  final String correctOtp = '1234'; // Replace with your correct OTP
  List<String> emojis = [
    '😐',
    '😟',
    '😕',
    '😧',
    '😁'
  ]; // Emojis for transitions
  String currentEmoji = '😐';
  bool isOtpCorrect = false;
  bool isOtpIncorrect = false; // Flag for incorrect OTP

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void validateOtp(String value) {
    setState(() {
      if (value == correctOtp) {
        // Correct OTP
        isOtpCorrect = true;
        isOtpIncorrect = false;
        currentEmoji = '😁'; // Transition to happy emoji
      } else {
        // Incorrect OTP
        isOtpCorrect = false;
        isOtpIncorrect = true; // Set incorrect flag
        currentEmoji = '😡'; // Display angry emoji

        // Trigger shake animation
        _animationController.forward(from: 0);
      }
    });
  }

  void handleKeyPress(String value) {
    setState(() {
      if (value == 'CANCEL') {
        currentText = '';
        otpController.clear();
        currentEmoji = '😐'; // Reset to neutral emoji
        isOtpCorrect = false;
        isOtpIncorrect = false;
      } else if (currentText.length < 4) {
        currentText += value;
        otpController.text = currentText;

        // Updating emoji for each entered character
        if (currentText.length < emojis.length) {
          currentEmoji = emojis[currentText.length];
        }

        // Validating OTP when fully entered
        if (currentText.length == 4) {
          validateOtp(currentText);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(), // Pushing content to the center
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              currentEmoji,
              key: ValueKey<String>(currentEmoji),
              style: const TextStyle(fontSize: 100),
            ),
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // Shake animation logic
                double offset = TweenSequence([
                  TweenSequenceItem(
                      tween: Tween(begin: 0.0, end: -10.0), weight: 1),
                  TweenSequenceItem(
                      tween: Tween(begin: -10.0, end: 10.0), weight: 2),
                  TweenSequenceItem(
                      tween: Tween(begin: 10.0, end: 0.0), weight: 1),
                ]).evaluate(_animationController);

                return Transform.translate(
                  offset: Offset(
                      isOtpIncorrect ? offset : 0, 0), // Applying shake animation
                  child: child,
                );
              },
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                controller: otpController,
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                    if (currentText.length <= emojis.length) {
                      currentEmoji = emojis[currentText.length];
                    }
                  });
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(16),
                  fieldHeight: 80,
                  fieldWidth: 70,
                  activeColor: isOtpCorrect
                      ? Colors.green // Green for correct OTP
                      : (isOtpIncorrect
                          ? Colors.red // Red for incorrect OTP
                          : Colors.blue), // Default color
                  selectedColor: isOtpCorrect
                      ? Colors.green // Green for correct OTP
                      : (isOtpIncorrect
                          ? Colors.red // Red for incorrect OTP
                          : Colors.blue), // Default color
                  inactiveColor: isOtpCorrect
                      ? Colors.green // Green for correct OTP
                      : (isOtpIncorrect
                          ? Colors.red // Red for incorrect OTP
                          : Colors.grey), // Default color
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: OtpButton(onKeyPressed: handleKeyPress),
          ),
        ],
      ),
    );
  }
}
