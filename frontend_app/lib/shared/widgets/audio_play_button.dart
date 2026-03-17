import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/theme/theme.dart';

/// Two-state audio button:
/// 1. 🔊 (volume icon) — idle, tap to play
/// 2. ⏹ (stop icon) — playing, tap to stop & reset
class AudioPlayButton extends StatefulWidget {
  final String audioKey;
  final int surah;
  final double size;

  const AudioPlayButton({
    super.key,
    required this.audioKey,
    required this.surah,
    this.size = 48,
  });

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    // When audio finishes naturally → reset to idle
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (mounted) setState(() => _isPlaying = false);
      }
    });
  }

  Future<void> _play() async {
    try {
      setState(() { _loading = true; _hasError = false; });

      final url = ApiConstants.audioUrl(
        surah: widget.surah,
        audioKey: widget.audioKey,
      );
      await _player.setUrl(url);
      setState(() { _loading = false; _isPlaying = true; });

      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {
      if (mounted) setState(() { _loading = false; _hasError = true; _isPlaying = false; });
    }
  }

  Future<void> _stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
    if (mounted) setState(() => _isPlaying = false);
  }

  Future<void> _onTap() async {
    if (_loading) return;

    if (_isPlaying) {
      await _stop();
    } else {
      await _play();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    if (_loading) {
      icon = Icons.volume_up_outlined; // placeholder while loading
      iconColor = AppColors.accentPrimary;
    } else if (_hasError) {
      icon = Icons.volume_off_outlined;
      iconColor = AppColors.errorDefault;
    } else if (_isPlaying) {
      icon = Icons.stop;
      iconColor = AppColors.accentPrimary;
    } else {
      icon = Icons.volume_up_outlined;
      iconColor = AppColors.accentPrimary;
    }

    return Semantics(
      label: _isPlaying ? 'Остановить воспроизведение' : 'Прослушать произношение',
      child: IconButton(
        onPressed: _loading ? null : _onTap,
        icon: _loading
            ? SizedBox(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accentPrimary,
                ),
              )
            : Icon(icon, color: iconColor),
        iconSize: widget.size * 0.5,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surfaceElevated,
          fixedSize: Size(widget.size, widget.size),
        ),
      ),
    );
  }
}
