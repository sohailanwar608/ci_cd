import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorder extends StatefulWidget {
  const AudioRecorder({super.key});

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterSoundRecorder? _recorder;
  String? _filePath;

  @override
  void initState() {
    super.initState();

  }

  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/recording.wav';
    setState(() {
      _filePath = filePath;
    });
    await _recorder!.startRecorder(toFile: filePath);
  }

  Future<void> _stopRecording() async {
    // Stop the audio recorder
    await _recorder!.stopRecorder();

    // Get the application documents directory
    final appDir = await getApplicationDocumentsDirectory();

    // Ensure that the directory exists, create it if it doesn't
    final directory = Directory('${appDir.path}/app_flutter/');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Construct the new file path
    final newFilePath = '${directory.path}/recording.wav';

    // Move the recorded file to the new location
    final file = File(_filePath!);
    await file.rename(newFilePath);

    setState(() {
      _filePath = newFilePath;
    });
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_filePath != null)
              Text('Recording saved: $_filePath'),
            ElevatedButton(
              onPressed: _startRecording,
              child: const Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: _stopRecording,
              child: const Text('Stop Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
