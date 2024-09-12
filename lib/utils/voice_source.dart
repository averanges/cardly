import 'package:just_audio/just_audio.dart';

class StreamSource extends StreamAudioSource {
  StreamSource(this.stream);

  final Stream<List<int>> stream;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: 0,
      stream: stream,
      contentType: 'audio/mp3',
    );
  }
}