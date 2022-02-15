import 'dart:io';

import 'package:flutter/material.dart';
import 'package:odvc/CardItem.dart' as card_item;
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class CardPlayer extends StatefulWidget {
  const CardPlayer({Key? key, required this.card}) : super(key: key);

  final card_item.Card card;

  @override
  State<CardPlayer> createState() => _CardPlayerState();
}

class _CardPlayerState extends State<CardPlayer> with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;
  late AudioCache _audioCache;

  bool get _isPlaying => _audioPlayer.state == PlayerState.PLAYING;
  bool _musicLoaded = false, _musicEnded = false;
  int totalDuration = 0;
  late Future<Uri> _musicLoading;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
    _musicLoading = _audioCache.load("musics/Bar.wav");
    _musicLoading.then(
        (value) => _audioPlayer.setUrl(value.path, isLocal: true).then((value) {
              setState(() {
                _musicLoaded = true;
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: AspectRatio(
                          aspectRatio: 1.0,
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image.asset(widget.card.imagePath))),
                    ),
                    Center(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ColoredBox(
                            color: Colors.black38,
                            child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SingleChildScrollView(
                                    child: Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed aliquam vehicula lorem tincidunt semper. Ut id libero facilisis, tristique dolor id, maximus nisi. Aenean at ipsum ac justo condimentum mattis. Mauris id rutrum urna, et aliquet quam. Vestibulum sem libero, porttitor nec est pellentesque, dignissim laoreet quam. Integer at justo tellus. Proin mollis sit amet odio eu ultricies.\n\nPhasellus luctus, felis id maximus vehicula, lectus ipsum facilisis sem, non maximus ex ligula non elit. Proin euismod bibendum efficitur. Mauris metus magna, rutrum sed tristique non, laoreet et ante. Pellentesque accumsan ullamcorper mi. Fusce et ornare sapien, vel tempus dolor. Integer bibendum elit ac fringilla pulvinar. Phasellus vel neque at massa mollis cursus. Morbi vel nulla at ligula rhoncus ultricies non a elit. Fusce laoreet odio nisi.\n\nVestibulum mollis magna vel sapien interdum, sit amet tincidunt urna volutpat. Vestibulum ut quam velit. Etiam molestie sapien et turpis eleifend, vitae pellentesque est dapibus. Ut a molestie velit. Curabitur vestibulum, ante at ornare lobortis, urna enim bibendum orci, et tristique sem turpis eu magna. Morbi a velit condimentum, laoreet ex in, condimentum quam. Sed iaculis tincidunt massa, non semper ex elementum eget. Nulla varius viverra arcu. Nunc bibendum lectus velit, non eleifend mauris tempus ut. Phasellus eu maximus tellus.\n\nVestibulum at libero sed mauris tempus egestas. Aliquam venenatis magna sapien, scelerisque ullamcorper lectus finibus non. Morbi ac sapien lectus. Aenean neque orci, finibus sed sem vitae, lacinia bibendum lectus. Pellentesque ullamcorper molestie bibendum. Nunc eget massa ex. Quisque ornare ante velit, sit amet venenatis nisi sagittis aliquam. Suspendisse id blandit lacus. Suspendisse sit amet varius massa, eleifend varius mi. Aliquam erat volutpat. Praesent in pretium nisi.\n\nProin aliquet, nulla ac sagittis convallis, mi diam congue neque, id condimentum est justo et lorem. Vestibulum iaculis lobortis orci non iaculis. Phasellus nec viverra nisl. Pellentesque ullamcorper justo vitae libero laoreet, dignissim rhoncus enim aliquet. Etiam porta velit dui. Fusce facilisis magna in erat viverra aliquet. Fusce eros enim, scelerisque vitae justo et, luctus sagittis nulla. Curabitur blandit molestie orci, in euismod justo euismod vel. Vivamus sodales lectus sed odio lobortis vulputate. ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  overflow: TextOverflow.clip,
                                ))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<Duration>(
                stream: _audioPlayer.onAudioPositionChanged,
                builder: (context, snapshot) {
                  return _buildProgressBar(snapshot);
                }),
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.onPlayerStateChanged,
              builder: (context, snapshot) {
                return Center(
                    child: Container(
                  width: 70,
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () {
                        //print(snapshot.data);
                        if (snapshot.data == PlayerState.PLAYING &&
                            !_musicEnded) {
                          _audioPlayer.pause();
                        } else if (snapshot.data == PlayerState.COMPLETED ||
                            snapshot.data == PlayerState.STOPPED ||
                            snapshot.data == null ||
                            _musicEnded) {
                          _audioCache.play("musics/Bar.wav");
                          _musicEnded = false;
                        } else if (snapshot.data == PlayerState.PAUSED) {
                          _audioPlayer.resume();
                          _musicEnded = false;
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2000)))),
                      child: _buildPlayButton(snapshot.data)),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  ProgressBar _buildProgressBar(AsyncSnapshot<Duration> snapshot) {
    _musicEnded = ((snapshot.data?.inMilliseconds ?? 0) >= (totalDuration - 0));
    if (_musicEnded &&
        totalDuration > 0 &&
        _audioPlayer.state == PlayerState.PLAYING) {
      _audioPlayer.pause();
    }

    return ProgressBar(
      progress: snapshot.data ?? Duration(milliseconds: 0),
      total: Duration(milliseconds: totalDuration),
      onSeek: (value) {
        if (_audioPlayer.state == PlayerState.PLAYING ||
            _audioPlayer.state == PlayerState.PAUSED) {
          _audioPlayer.seek(value);
        }
      },
    );
  }

  Widget _buildPlayButton(PlayerState? data) {
    if (!_musicLoaded) {
      return const CircularProgressIndicator(
        color: Colors.white,
      );
    }

    if (data == PlayerState.PLAYING && totalDuration == 0) {
      _audioPlayer.getDuration().then((duration) {
        setState(() => totalDuration = duration);
      });
    }

    return Icon(
      (data == PlayerState.PLAYING && !_musicEnded)
          ? Icons.pause
          : Icons.play_arrow,
      size: 40,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _audioPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      _audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }
}
