import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebStoryViewPage extends StatefulWidget {
  final String slug;

  const WebStoryViewPage({super.key, required this.slug});

  @override
  State<WebStoryViewPage> createState() => _WebStoryViewPageState();
}

class _WebStoryViewPageState extends State<WebStoryViewPage>
    with SingleTickerProviderStateMixin {
  int _currentSlide = 0;
  late AnimationController _progressController;
  // In a real app, slides would come from the article/story API
  // For now show a placeholder
  final int _totalSlides = 5;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _startTimer();
  }

  void _startTimer() {
    _progressController.forward(from: 0);
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextSlide();
      }
    });
  }

  void _nextSlide() {
    if (_currentSlide < _totalSlides - 1) {
      setState(() => _currentSlide++);
      _progressController.forward(from: 0);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prevSlide() {
    if (_currentSlide > 0) {
      setState(() => _currentSlide--);
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Slide content (placeholder)
            GestureDetector(
              onTapUp: (details) {
                final width = MediaQuery.of(context).size.width;
                if (details.localPosition.dx < width / 2) {
                  _prevSlide();
                } else {
                  _nextSlide();
                }
              },
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: Text(
                    'स्लाइड ${_currentSlide + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
            // Progress bars
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: List.generate(
                  _totalSlides,
                  (i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SizedBox(
                        height: 3,
                        child: i < _currentSlide
                            ? Container(color: Colors.white)
                            : i == _currentSlide
                                ? AnimatedBuilder(
                                    animation: _progressController,
                                    builder: (_, __) => LinearProgressIndicator(
                                      value: _progressController.value,
                                      backgroundColor: Colors.white38,
                                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : Container(color: Colors.white38),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 20,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
