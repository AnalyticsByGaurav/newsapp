import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../blocs/shorts/shorts_bloc.dart';
import '../../blocs/shorts/shorts_event.dart';
import '../../blocs/shorts/shorts_state.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../../domain/entities/short.dart';

class ShortsPage extends StatelessWidget {
  const ShortsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('शॉर्ट्स', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ShortsBloc, ShortsState>(
        builder: (context, state) {
          if (state is ShortsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (state is ShortsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<ShortsBloc>().add(const LoadShortsEvent()),
            );
          }
          if (state is ShortsLoaded) {
            if (state.shorts.isEmpty) {
              return const AppEmptyWidget(
                message: 'कोई शॉर्ट वीडियो उपलब्ध नहीं है।',
                icon: Icons.video_library_outlined,
              );
            }
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: state.shorts.length,
              onPageChanged: (index) {
                if (index >= state.shorts.length - 2 && state.hasMore) {
                  context.read<ShortsBloc>().add(const LoadMoreShortsEvent());
                }
              },
              itemBuilder: (context, index) {
                return _ShortVideoItem(short: state.shorts[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ShortVideoItem extends StatefulWidget {
  final ShortVideo short;

  const _ShortVideoItem({required this.short});

  @override
  State<_ShortVideoItem> createState() => _ShortVideoItemState();
}

class _ShortVideoItemState extends State<_ShortVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.short.videoUrl),
      );
      await _controller!.initialize();
      _controller!.setLooping(true);
      setState(() => _isInitialized = true);
    } catch (_) {}
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('short_${widget.short.slug}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.7) {
          _controller?.play();
          setState(() => _isPlaying = true);
        } else {
          _controller?.pause();
          setState(() => _isPlaying = false);
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
          if (_showControls) _hideControlsAfterDelay();
        },
        onDoubleTap: _togglePlayPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video
            if (_isInitialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (widget.short.thumbnail != null)
              Image.network(
                widget.short.thumbnail!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
              )
            else
              Container(color: Colors.grey[900]),
            // Dark overlay at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.short.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansDevanagari',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.short.duration != null)
                      Text(
                        _formatDuration(widget.short.duration!),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                  ],
                ),
              ),
            ),
            // Play/Pause button overlay
            if (_showControls)
              Center(
                child: AnimatedOpacity(
                  opacity: _showControls ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
