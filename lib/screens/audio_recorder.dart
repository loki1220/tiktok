import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:record/record.dart';

import 'new_sound_player.dart';

class RecorderExample extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RecorderExample> {
  bool showPlayer = false;
  ap.AudioSource? audioSource;
  SoundPlayer? soundPlayer;
  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showPlayer
        ? Container(
            height: 40,
            width: 140,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfffeda7c)),
            child: TextButton(
              onPressed: () {
                // soundPlayer?.togglePlaying(whenFinished: () => setState(() { }), fileName:audioSource );
                setState(() {
                  showPlayer = false;
                });
              },
              child: Icon(Icons.delete),
            ),
          )
        : RecorderExamples(
            onStop: (path) {
              setState(() {
                audioSource = ap.AudioSource.uri(Uri.parse(path));
                showPlayer = true;
              });
            },
          );
  }
}

class RecorderExamples extends StatefulWidget {
  final void Function(String path) onStop;

  const RecorderExamples({required this.onStop});

  @override
  RecorderExamplesState createState() => RecorderExamplesState();
}

class RecorderExamplesState extends State<RecorderExamples> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;
  static String? ashwin;

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: _isRecording ? 170 : 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xfffeda7c)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildPauseResumeControl(),
          const SizedBox(width: 10),
          _buildText(),
          const SizedBox(width: 10),
          _buildRecordStopControl(),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_isRecording || _isPaused) {
      icon = Icon(Icons.stop_circle_outlined, color: Colors.red, size: 25);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: Colors.black, size: 25);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return IconButton(
      icon: icon,
      color: color,
      onPressed: () {
        _isRecording ? _stop() : _start();
      },
    );
  }

  Widget _buildPauseResumeControl() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (!_isPaused) {
      icon = Icon(Icons.pause, color: Colors.black, size: 27);
      color = Colors.black.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: Colors.black, size: 27);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return IconButton(
      icon: icon,
      color: color,
      onPressed: () {
        _isPaused ? _resume() : _pause();
      },
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return Text(
      "AUDIO",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.black, fontSize: 14),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();

    widget.onStop(path!);
    print('this is path gopi $path');

    setState(() {
      _isRecording = false;
      ashwin = path;
    });
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }
}
