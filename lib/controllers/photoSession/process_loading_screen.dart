import 'dart:async';
import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class ProcessingLoadingScreen extends StatefulWidget {
  final bool isVisible;
  
  const ProcessingLoadingScreen({
    Key? key,
    required this.isVisible,
  }) : super(key: key);

  @override
  _ProcessingLoadingScreenState createState() => _ProcessingLoadingScreenState();
}

class _ProcessingLoadingScreenState extends State<ProcessingLoadingScreen> {
  Timer? _textTimer;
  
  int _currentTextIndex = 0;
  final List<String> _loadingTexts = [
    "Removing Background...",
    "Setting Up Light...",
    "Processing Photo...",
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(ProcessingLoadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Start timer when widget becomes visible
    if (widget.isVisible && !oldWidget.isVisible) {
      _currentTextIndex = 0;
      _startTimer();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _stopTimer(); // Cancel existing timer if any
    
    if (widget.isVisible) {
      _textTimer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
        if (mounted && _currentTextIndex < _loadingTexts.length - 1) {
          setState(() {
            _currentTextIndex++;
          });
        }
        // Stay on the last message until response comes
      });
    }
  }

  void _stopTimer() {
    _textTimer?.cancel();
    _textTimer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return SizedBox.shrink();
    
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple sparkle icons (static)
              Image.asset(
            "assets/images/preprocessing.gif",
            height: 60,
          ),
            
            SizedBox(height: 60),
            
            // Text that changes periodically
            Text(
              _loadingTexts[_currentTextIndex],
              style: CustomTextTheme.regular20.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}