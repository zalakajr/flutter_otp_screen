import 'package:flutter/material.dart';

class OtpButton extends StatefulWidget {
  final Function(String) onKeyPressed;

  const OtpButton({Key? key, required this.onKeyPressed}) : super(key: key);

  @override
  State<OtpButton> createState() => _OtpButtonState();
}

class _OtpButtonState extends State<OtpButton> {
  final Map<String, bool> _isPressed = {};

  Widget buildButton({
    required String label,
    required BuildContext context,
    Color defaultColor = Colors.white,
    Color highlightColor = Colors.grey,
    VoidCallback? onTap,
  }) {
    bool isCurrentlyPressed = _isPressed[label] ?? false;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed[label] = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed[label] = false;
        });
        if (onTap != null) {
          onTap();
        }
      },
      onTapCancel: () {
        setState(() {
          _isPressed[label] = false;
        });
      },
      child: Container(
        width: 50, 
        height: 50, 
        decoration: BoxDecoration(
          color: isCurrentlyPressed ? highlightColor : defaultColor,
          borderRadius:
              BorderRadius.circular(8), // Reduced radius for smaller buttons
          border: Border.all(color: Colors.black12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16, 
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),

      // Reduced padding
      color: Colors.grey.shade200,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 12, 
        crossAxisSpacing: 12, 
        childAspectRatio: 2, // increase to increase the size of all the buttons
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),

        children: [
          buildButton(
            label: '1',
            context: context,
            onTap: () => widget.onKeyPressed('1'),
          ),
          buildButton(
            label: '2',
            context: context,
            onTap: () => widget.onKeyPressed('2'),
          ),
          buildButton(
            label: '3',
            context: context,
            onTap: () => widget.onKeyPressed('3'),
          ),
          buildButton(
            label: '4',
            context: context,
            onTap: () => widget.onKeyPressed('4'),
          ),
          buildButton(
            label: '5',
            context: context,
            onTap: () => widget.onKeyPressed('5'),
          ),
          buildButton(
            label: '6',
            context: context,
            onTap: () => widget.onKeyPressed('6'),
          ),
          buildButton(
            label: '7',
            context: context,
            onTap: () => widget.onKeyPressed('7'),
          ),
          buildButton(
            label: '8',
            context: context,
            onTap: () => widget.onKeyPressed('8'),
          ),
          buildButton(
            label: '9',
            context: context,
            onTap: () => widget.onKeyPressed('9'),
          ),
          const SizedBox(), // Empty space in the grid
          buildButton(
            label: '0',
            context: context,
            onTap: () => widget.onKeyPressed('0'),
          ),
          buildButton(
            label: 'C',
            context: context,
            defaultColor: Colors.redAccent,
            highlightColor: Colors.red.shade700,
            onTap: () => widget.onKeyPressed('CANCEL'),
          ),
        ],
      ),
    );
  }
}
