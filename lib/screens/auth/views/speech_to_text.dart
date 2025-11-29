import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  late SpeechToText _speech;
  bool _isListening = false;
  final TextEditingController controller;

  SpeechService({required this.controller}) {
    _speech = SpeechToText();
  }

  bool get isListening => _isListening;

  // تهيئة الخدمة
  Future<void> initSpeech() async {
    await _speech.initialize();
  }

  // بدء الاستماع
  void startListening(VoidCallback? onStateChanged) async {
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      onStateChanged?.call();

      _speech.listen(
        onResult: (result) {
          controller.text = result.recognizedWords;
        },
      );
    }
  }

  // إيقاف الاستماع
  void stopListening(VoidCallback? onStateChanged) {
    _speech.stop();
    _isListening = false;
    onStateChanged?.call();
  }
}
