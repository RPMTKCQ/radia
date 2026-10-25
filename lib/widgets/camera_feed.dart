import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/direction.dart';
import '../models/intersection.dart';
import '../services/count_timeline.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// One camera = one lane. Plays  assets/videos/cam_0N.mp4  (N = camera number)
/// in a loop and, if  assets/counts/cam_0N.json  exists, feeds that lane's
/// vehicle count to the agent in sync with the video.
/// Without a counts file the lane keeps simulated numbers.
class CameraFeed extends StatefulWidget {
  final Intersection intersection;
  final Dir lane;
  const CameraFeed({super.key, required this.intersection, required this.lane});

  @override
  State<CameraFeed> createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  late final Intersection _x;
  late final Dir _lane;
  VideoPlayerController? _c;
  CountTimeline? _timeline;
  bool _failed = false;
  int _lastSec = -1;
  String? _error;

  int get _cam => _x.cameraNumber(_lane);

  @override
  void initState() {
    super.initState();
    _x = widget.intersection;
    _lane = widget.lane;
    _load();
  }

  void _release() {
    _c?.removeListener(_onTick);
    _c?.dispose();
    _c = null;
    _timeline = null;
    _x.videoDriven.remove(_lane); // back to simulation
  }

  Future<void> _load() async {
    final path = 'assets/videos/cam_0$_cam.mp4';
    final c = VideoPlayerController.asset(path);
    try {
      await c.initialize();
    } catch (e) {
      debugPrint('CameraFeed: could not load $path -> $e');
      await c.dispose();
      if (mounted) {
        setState(() {
          _failed = true;
          _error = '$e';
        });
      }
      return;
    }
    final timeline = await CountTimeline.load('assets/counts/cam_0$_cam.json');
    if (!mounted) {
      await c.dispose();
      return;
    }
    await c.setLooping(true);
    await c.setVolume(0); // muted so autoplay works on web
    await c.play();

    _timeline = timeline;
    c.addListener(_onTick);
    if (timeline != null) {
      _x.videoDriven.add(_lane);
      app.applyCounts(_lane, timeline.at(Duration.zero));
    }
    setState(() => _c = c);
  }

  /// Runs on every video update; only acts once per second.
  void _onTick() {
    final c = _c, t = _timeline;
    if (c == null || t == null || !c.value.isInitialized) return;
    final sec = c.value.position.inSeconds;
    if (sec == _lastSec) return;
    _lastSec = sec;
    app.applyCounts(_lane, t.at(c.value.position));
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(8)),
        child: Text(text,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
      );

  @override
  Widget build(BuildContext context) {
    final c = _c;
    final playing = c != null && c.value.isInitialized;
    final count = _x.counts[_lane] ?? 0;
    final driven = _x.videoDriven.contains(_lane);

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
            Container(
              color: const Color(0xFF111113),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: Text(
                  'No video found.\nAdd assets/videos/cam_0$_cam.mp4\n${_error ?? ''}',
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: Colors.white70)),
            )
          else
            const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 6,
            left: 6,
            child: Row(children: [
              const Icon(Icons.circle, size: 8, color: AppColors.red),
              const SizedBox(width: 4),
              Text(_x.cameraLabel(_lane),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(blurRadius: 4)])),
            ]),
          ),
          Positioned(
              top: 6, right: 6, child: _chip(driven ? 'AI COUNTS' : 'SIMULATED')),
          Positioned(bottom: 6, left: 6, child: _chip('${_lane.label}  $count')),
          if (playing)
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                iconSize: 22,
                onPressed: () =>
                    setState(() => c.value.isPlaying ? c.pause() : c.play()),
                icon: Icon(
                    c.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white70),
              ),
            ),
        ]),
      ),
    );
  }
}
