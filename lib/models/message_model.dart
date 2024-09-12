import 'dart:io';
import 'dart:typed_data';

class MessageModel {
  String messageContent;
  final MessageTypes type;
  int? id;
  String? mistakes;
  File? file;
  Uint8List? audioBytes;
  bool? isCorrect;
  String? image;

  MessageModel(
      {this.messageContent = '',
      this.id,
      required this.type,
      this.audioBytes,
      this.mistakes,
      this.file});

  set addMistakes(String newMistakes) {
    mistakes = newMistakes;
  }

  set setIsCorrect(String newMistakes) {
    isCorrect = newMistakes == "[0]" || newMistakes == "'[0]'";
  }

  set setMessageContent(String newMessage) {
    messageContent = newMessage;
  }

  set setImage(String value) {
    image = value;
  }

  set setFile(File newFile) {
    file = newFile;
  }

  set setAudioBytes(Uint8List value) {
    audioBytes = value;
  }
}

enum MessageTypes {
  botMessage,
  userMessage,
  taskCompleteMessage,
  chatCompleteMessage,
  image
}
