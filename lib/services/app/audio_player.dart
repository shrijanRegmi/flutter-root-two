// class MyAudioPlayer extends ChangeNotifier {
//   AudioCache _cache = AudioCache(prefix: "music/");
//   AudioPlayer _player;
//   AudioPlayer get player => _player;

//   // play audio
//   playAudio() async {
//     _player = await _cache.play("happy.mp3");
//     notifyListeners();
//   }

//   //pause audio
//   pauseAudio() {
//     _player.pause();
//     notifyListeners();
//   }

//   //stop audio
//   stopAudio() {
//     _player.stop();
//     notifyListeners();
//   }

//   //resume audio
//   resumeAudio() {
//     _player.resume();
//     notifyListeners();
//   }
// }
