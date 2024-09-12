import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import "package:just_audio/just_audio.dart" as just_audio;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:socket_io_client/socket_io_client.dart' as ioBase;
import 'package:sound/utils/SiriWaveformWidget.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:volume_watcher/volume_watcher.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isRecording = false;
  late AudioRecorder _record;
  late AudioPlayer _audioPlayer;
  late ioBase.Socket _socket;
  String _filePath = '';
  late Timer timer;
  int count = 0;
  final List<Uint8List> _audioChunks = [];
  bool _userSpeak = true;
  String _currentPhrase = '';
  late Color colorBySide;
  final String ipAddress = '10.50.112.180';
  bool _isPlayerStart = false;

  StreamSubscription<Amplitude>? _amplitudeSubscription;
  late SiriWaveformController _controller;

  double _amplitude = 0.0;
  double speed = .2;
  double frequency = 6.0;
  double _currentVolume = 0;

  List<int> buffer = [];
  final int CHUNK_SIZE = 1024;

  final just_audio.AudioPlayer player = just_audio.AudioPlayer();
  final streamCtrl = StreamController<List<int>>.broadcast();

  final PlayerStream _playerNew = PlayerStream();
  bool _isStreamStart = false;
  StreamSubscription? _playerStatus;

  List<int> incomingAudioBuffer =
      []; // Temporary buffer for incoming audio chunks

  Future<void> initPlayer() async {
    // Initialize player stream
    // _playerStatus = _playerNew.status.listen((status) {
    //   setState(() {
    //     _isStreamStart = status == SoundStreamStatus.Playing;
    //   });
    // });
    // setState(() {
    //   _isStreamStart = true;
    // });

    await _playerNew.initialize(sampleRate: 16000);
  }

  Uint8List adjustVolume(Uint8List audioChunk, double volumeFactor) {
    try {
      // Check if the audio chunk length is a multiple of 2 (16-bit samples)
      if (audioChunk.length % 2 != 0) {
        throw Exception('Invalid audio chunk length');
      }

      Uint8List adjustedChunk = Uint8List.fromList(audioChunk);
      Int16List samples = adjustedChunk.buffer.asInt16List();

      for (int i = 0; i < samples.length; i++) {
        // Multiply each sample by the volume factor and clamp to valid range
        samples[i] = (samples[i] * volumeFactor).clamp(-32768, 32767).toInt();
      }

      return adjustedChunk;
    } catch (e) {
      // Handle or log the error, and return an empty chunk or a safe default
      print('Error adjusting volume: $e');
      return Uint8List(0);
    }
  }

  void playChunks(Uint8List audioChunk) async {
    if (!_isStreamStart) {
      await _playerNew.start();
      setState(() {
        _isStreamStart = true;
      });
    }

    double volumeFactor = _currentVolume;
    Uint8List adjustedChunk = adjustVolume(audioChunk, volumeFactor);

    if (adjustedChunk.isNotEmpty) {
      await _playerNew.writeChunk(adjustedChunk);
    } else {
      print('Skipped a corrupted chunk');
    }
  }

  double dbToLinear(double db) {
    return pow(10, db / 20).toDouble();
  }

  void onChangeSpeakingSide(bool data) {
    setState(() {
      _userSpeak = data;
      _currentPhrase = '';
    });
  }

  void startListening() {
    _amplitudeSubscription = _record
        .onAmplitudeChanged(const Duration(milliseconds: 200))
        .listen((amplitude) {
      setState(() {
        _amplitude = dbToLinear(amplitude.current);
        _controller.amplitude = _amplitude;
      });
      // _amplitudeSubscription!.cancel();
    });
  }

  void startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/temp_audio.wav';
    await _record.start(
        const RecordConfig(
            encoder: AudioEncoder.pcm16bits,
            numChannels: 1,
            noiseSuppress: false,
            sampleRate: 16000),
        path: filePath);
  }

  Future<void> playRecording(AudioPlayer audioPlayer, Uint8List audioChunk,
      List<Uint8List> audioChunks, Function onChangeSpeakingSide) async {
    streamCtrl.sink.add(audioChunk);

    //     _audioChunks.add(audioChunk);
    //   final combinedAudio = _audioChunks.expand((x) => x).toList();
    //   final directory = await getApplicationDocumentsDirectory();
    //   final filePath = '${directory.path}/streamed_audio.wav';
    //   final file = File(filePath);
    //   await file.writeAsBytes(combinedAudio);

    // if(filePath != ''){
    //   await audioPlayer.play(UrlSource(filePath));
    // }

    _socket.emit('streamStart', 0);

    // _audioChunks.clear();
  }

  stopVoiceRecording() async {
    final path = await _record.stop();
    if (path != null) {
      print(path);
    }
    setState(() {
      _isRecording = false;
      _isStreamStart = false;
    });
    _playerNew.stop();
    _playerNew.dispose();
    if (incomingAudioBuffer.isNotEmpty) {
      incomingAudioBuffer = [];
    }
    // Send any remaining data in buffer
    if (buffer.isNotEmpty) {
      _socket.emit('binary', buffer);
      buffer.clear();
      buffer = [];
    }

    _socket.emit('binary', 'EOF');
    _amplitudeSubscription?.cancel();
    _record.cancel();
  }

  Future<void> getCurrentVolume() async {
    VolumeWatcher.addListener((double volume) {
      setState(() {
        _currentVolume = volume * 0.2;
      });
      print(_currentVolume);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentVolume();
    initPlayer();
    colorBySide = _userSpeak
        ? const Color.fromARGB(255, 52, 142, 216)
        : const Color.fromARGB(255, 223, 28, 28);
    _controller = IOS7SiriWaveformController(color: colorBySide);

    _record = AudioRecorder();
    _audioPlayer = AudioPlayer();

    timer = Timer.periodic(const Duration(milliseconds: 130), (timer) {
      setState(() {
        count++;
        if (count == 12) {
          count = 0;
        }
      });
    });

    _socket = ioBase.io("http://$ipAddress:5000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.on('connect', (_) {
      print('Connected to WebSocket server');
    });

    _socket.on('stop', (_) {
      stopVoiceRecording();
    });

    _socket.on('stream', (data) async {
      if (data != null) {
        String text = data['text'];
        Uint8List audioChunk = data['audio_chunk'];
        if (_isPlayerStart == false) {
          setState(() {
            _isPlayerStart = true;
          });
        }
        playChunks(audioChunk);
        if (_isStreamStart) {
          print('Chunk written');
          // await player.setAudioSource(StreamSource(streamCtrl.stream));
          // await player.play();

          setState(() {
            _isPlayerStart = true;
          });
        }
        // streamCtrl.sink.add(audioChunk);
        // playRecording(_audioPlayer, audioChunk, _audioChunks, onChangeSpeakingSide);

        setState(() {
          _currentPhrase = text;
        });
      }
    });

    _socket.on('disconnect', (_) {
      print('Disconnected from WebSocket server');
    });

    _socket.on('connect_error', (error) {
      print('Connection Error: $error');
    });

    _socket.on('message', (data) {
      setState(() {
        _currentPhrase = data;
        _userSpeak = false;
      });

      colorBySide = _userSpeak
          ? const Color.fromARGB(255, 52, 142, 216)
          : const Color.fromARGB(255, 223, 28, 28);
      _controller = IOS7SiriWaveformController(color: colorBySide);
    });

    _socket.connect();
  }

  @override
  void dispose() {
    _playerNew.dispose();
    _playerStatus?.cancel();
    _record.dispose();
    _audioPlayer.dispose();
    _socket.dispose();
    timer.cancel();
    super.dispose();
  }

  void changeRecording(String filePath, bool isRecordingOn) {
    setState(() {
      _isRecording = isRecordingOn;
      _filePath = filePath;
    });

    if (!isRecordingOn) {
      // sendAudioFile(filePath);
    }
  }

  void startVoiceStreaming() async {
    if (await Permission.microphone.request().isGranted) {
      final stream = await _record.startStream(const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          numChannels: 1,
          noiseSuppress: false,
          sampleRate: 16000));
      print('PRIVET');
      startListening();

      setState(() {
        _isRecording = true;
      });

      _socket.emit('streamStart', false);
      // onChangeSpeakingSide(true);
      if (stream.isBroadcast) {
        onChangeSpeakingSide(true);
        colorBySide = _userSpeak
            ? const Color.fromARGB(255, 52, 142, 216)
            : const Color.fromARGB(255, 223, 28, 28);
        _controller = IOS7SiriWaveformController(color: colorBySide);
        stream.listen((audioChunk) {
          buffer.addAll(audioChunk);

          while (buffer.length >= CHUNK_SIZE) {
            _socket.emit('binary', buffer.sublist(0, CHUNK_SIZE));
            buffer = buffer.sublist(CHUNK_SIZE);
          }

          print('Buffer length: ${buffer.length}'); // Debugging buffer length
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: const Text(
              'Talk with me',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                children: [
                  Text(
                    'Hey, Nikolai',
                    style: TextStyle(color: Colors.white54, fontSize: 20),
                  ),
                  Text(
                    'How may I Help You Today ?',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              const SizedBox(),
              SiriWaveformWidget(
                controller: _controller,
                showSupportBar: true,
                style: SiriWaveformStyle.ios_7,
              ),
              Text(
                _currentPhrase,
                style: const TextStyle(
                    color: Colors.white, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  _isRecording ? stopVoiceRecording() : startVoiceStreaming();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.blue, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 0.5,
                      )
                    ],
                    gradient: LinearGradient(
                      transform: GradientRotation(count / 2),
                      colors: const [
                        Colors.white,
                        Colors.black87,
                        Colors.black87,
                        Colors.black87,
                        Colors.black87,
                        Colors.black87,
                        Colors.black87,
                        Colors.black87,
                        Colors.black87
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: _isRecording
                      ? const Icon(
                          Icons.mic_off,
                          color: Colors.blue,
                          size: 50,
                        )
                      : const Icon(Icons.mic, size: 50, color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
