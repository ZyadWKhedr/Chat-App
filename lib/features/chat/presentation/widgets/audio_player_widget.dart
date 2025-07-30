import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({super.key, required this.url});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _player = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());

    await _player.setUrl(widget.url);

    _player.durationStream.listen((d) {
      if (d != null) {
        setState(() => _duration = d);
      }
    });

    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });

    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    _isPlaying ? _player.pause() : _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlay,
        ),
        Expanded(
          child: Slider(
            value: _position.inMilliseconds.toDouble(),
            max: _duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              _player.seek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Text(
          "${_position.inSeconds}/${_duration.inSeconds}s",
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
