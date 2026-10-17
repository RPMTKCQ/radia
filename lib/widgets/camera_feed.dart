import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/direction.dart';
import '../models/intersection.dart';
import '../theme/app_theme.dart';
import 'intersection_painter.dart';

/// "CAM-0X live feed": plays a looping intersection video from assets.
///
/// Looks for `assets/videos/cam_0ID.mp4` first (ID = intersection number),
/// then `assets/videos/intersection.mp4`.
/// If neither exists it falls back to the simulated top-down diagram.
class CameraFeed extends StatefulWidget {
  final Intersection intersection;
  const CameraFeed({super.key, required this.intersection});

  @override
  State<CameraFeed> createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  VideoPlayerController? _c;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(CameraFeed old) {
    super.didUpdateWidget(old);
    if (old.intersection.id != widget.intersection.id) _load();
  }

  Future<void> _load() async {
    final old = _c;
    _c = null;
    _failed = false;
    old?.dispose();

    final id = widget.intersection.id;
    final paths = ['assets/videos/cam_0$id.mp4', 'assets/videos/intersection.mp4'];
    for (final p in paths) {
      final c = VideoPlayerController.asset(p);
      try {
        await c.initialize();
      } catch (_) {
        await c.dispose();
        continue;
      }
      if (!mounted || widget.intersection.id != id) {
        await c.dispose();
        return;
      }
      await c.setLooping(true);
      await c.setVolume(0); // muted so autoplay works on web
      await c.play();
      setState(() => _c = c);
      return;
    }
    if (mounted) setState(() => _failed = true);
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  Widget _countChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(8)),
        child: Text(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
      );

  @override
  Widget build(BuildContext context) {
    final i = widget.intersection;
    final c = _c;
    final playing = c != null && c.value.isInitialized;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 1.55,
        child: Stack(fit: StackFit.expand, children: [
          if (playing)
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: c.value.size.width,
                height: c.value.size.height,
                child: VideoPlayer(c),
              ),
            )
          else if (_failed)
            CustomPaint(painter: IntersectionPainter(i.counts, i.decision))
          else
            const Center(child: CircularProgressIndicator()),

          // Lane counts overlaid on the video
          if (playing) ...[
            Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(child: _countChip('N ${i.counts[Dir.north]}'))),
            Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(child: _countChip('S ${i.counts[Dir.south]}'))),
            Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(child: _countChip('W ${i.counts[Dir.west]}'))),
            Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(child: _countChip('E ${i.counts[Dir.east]}'))),
            Positioned(
              right: 4,
              bottom: 4,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(
                    () => c.value.isPlaying ? c.pause() : c.play()),
                icon: Icon(
                    c.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white70),
              ),
            ),
          ],

          Positioned(
            top: 8,
            left: 8,
            child: Row(children: [
              const Icon(Icons.circle, size: 9, color: AppColors.red),
              const SizedBox(width: 4),
              Text('CAM-0${i.id}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(blurRadius: 4)])),
            ]),
          ),
          if (_failed)
            const Positioned(
              bottom: 6,
              left: 8,
              child: Text('No video found. Showing simulated view.',
                  style: TextStyle(fontSize: 10, color: Colors.white70)),
            ),
        ]),
      ),
    );
  }
}
