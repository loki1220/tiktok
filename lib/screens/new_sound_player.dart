import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

final _fileName = 'Recording_example.aac';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  bool get isPlaying_audio => _audioPlayer!.isPlaying;
  //bool get abcaudio=> _fileName.isEmpty;
  Future init() async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession();
  }

  Future dispose() async {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future _play(VoidCallback whenFinished, String fileName) async {
    await _audioPlayer!.startPlayer(
      fromURI: fileName,
      whenFinished: whenFinished,
    );
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying(
      {required VoidCallback whenFinished, required fileName}) async {
    if (_audioPlayer!.isStopped) {
      await _play(whenFinished, fileName);
    } else {
      await _stop();
    }
  }
}
