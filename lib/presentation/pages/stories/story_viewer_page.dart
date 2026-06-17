import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/story.dart';
import '../../../domain/repositories/news_repository.dart';

class WebStoryViewPage extends StatefulWidget {
  final String slug;

  const WebStoryViewPage({super.key, required this.slug});

  @override
  State<WebStoryViewPage> createState() => _WebStoryViewPageState();
}

class _WebStoryViewPageState extends State<WebStoryViewPage>
    with SingleTickerProviderStateMixin {
  List<StorySlide> _slides = [];
  int _current = 0;
  bool _loading = true;
  String? _error;
  bool _paused = false;

  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _progress = AnimationController(vsync: this);
    _progress.addStatusListener((s) {
      if (s == AnimationStatus.completed) _goNext();
    });
    _load();
  }

  Future<void> _load() async {
    try {
      final story = await sl<NewsRepository>().getStoryDetail(widget.slug);
      if (!mounted) return;
      if (story.slides.isEmpty) {
        setState(() { _error = 'कोई स्लाइड नहीं मिली।'; _loading = false; });
        return;
      }
      setState(() { _slides = story.slides; _loading = false; });
      _startSlide(0);
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'लोड नहीं हो सका।'; _loading = false; });
    }
  }

  void _startSlide(int index) {
    if (index < 0 || index >= _slides.length) return;
    _progress.stop();
    _progress.duration = Duration(seconds: _slides[index].duration.clamp(3, 30));
    _progress.forward(from: 0);
  }

  void _goNext() {
    if (_current < _slides.length - 1) {
      setState(() => _current++);
      _startSlide(_current);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goPrev() {
    if (_current > 0) {
      setState(() => _current--);
      _startSlide(_current);
    } else {
      _progress.forward(from: 0);
    }
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _progress.stop();
    } else {
      _progress.forward();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Color _hex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'ff$hex';
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return const Color(0xFF1a1208);
    }
  }

  List<Color> _slideColors(StorySlide slide) {
    if (slide.bgGradient != null) {
      final m = RegExp(r'#([0-9a-fA-F]{6})')
          .allMatches(slide.bgGradient!)
          .toList();
      if (m.length >= 2) {
        return [_hex('#${m[0].group(1)}'), _hex('#${m[1].group(1)}')];
      }
    }
    final base = _hex(slide.bgColor);
    return [base, const Color(0xFFc0392b)];
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (_error != null || _slides.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 48),
              const SizedBox(height: 12),
              Text(_error ?? 'कोई स्लाइड नहीं',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('वापस जाएं',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final slide = _slides[_current];
    final colors = _slideColors(slide);
    final textColor = _hex(slide.textColor);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background gradient ──────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
              ),
            ),

            // ── Slide image ──────────────────────────────────────
            if (slide.imgUrl != null && slide.imgUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: slide.imgUrl!,
                fit: BoxFit.cover,
                memCacheWidth: 720,
                memCacheHeight: 1280,
                fadeInDuration: const Duration(milliseconds: 200),
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),

            // ── Dim overlay ──────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent, Colors.black54],
                  stops: [0, 0.4, 1],
                ),
              ),
            ),

            // ── Tap zones ────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _goPrev,
                    onLongPress: _togglePause,
                    onLongPressUp: _togglePause,
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _goNext,
                    onLongPress: _togglePause,
                    onLongPressUp: _togglePause,
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),

            // ── Progress bars ────────────────────────────────────
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: List.generate(_slides.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SizedBox(
                        height: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: i < _current
                              ? Container(color: Colors.white)
                              : i == _current
                                  ? AnimatedBuilder(
                                      animation: _progress,
                                      builder: (_, __) => LinearProgressIndicator(
                                        value: _progress.value,
                                        backgroundColor: Colors.white38,
                                        valueColor:
                                            const AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    )
                                  : Container(color: Colors.white38),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ── Close button ─────────────────────────────────────
            Positioned(
              top: 18,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),

            // ── Pause indicator ───────────────────────────────────
            if (_paused)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pause, color: Colors.white, size: 36),
                ),
              ),

            // ── Text + CTA at bottom ──────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (slide.displayText.isNotEmpty)
                      Text(
                        slide.displayText,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansDevanagari',
                          height: 1.4,
                          shadows: const [
                            Shadow(color: Colors.black87, blurRadius: 8),
                          ],
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (slide.ctaText?.isNotEmpty == true &&
                        slide.ctaUrl?.isNotEmpty == true) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final uri = Uri.tryParse(slide.ctaUrl!);
                          if (uri != null) await launchUrl(uri);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: _hex(slide.ctaColor),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            slide.ctaText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'NotoSansDevanagari',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
