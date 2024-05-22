import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class TextToSpeech extends StatefulWidget
{
  const TextToSpeech({super.key});
  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
   TextEditingController _textFieldController = TextEditingController();
  final player = AudioPlayer();
  bool _isLoadingVoice = false;

  @override
  void dispose() {
    _textFieldController.dispose();
    player.dispose();
    super.dispose();
  }
  @override


  //For the Text To Speech
  Future<void> playTextToSpeech(String text) async
  {

    setState(() {
      _isLoadingVoice = true; //progress indicator turn on now
    });

    String voiceRachel =
        '21m00Tcm4TlvDq8ikWAM';
    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceRachel';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'audio/mpeg',
        'xi-api-key': 'b917e732e7ce1a11e00e3ea643cbf0f8',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "text": text,
        "model_id": "eleven_monolingual_v1",
        "voice_settings": {"stability": .15, "similarity_boost": .75}
      }),
    );

    setState(() {
      _isLoadingVoice = false; //progress indicator turn off now
    });

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      await player.setAudioSource(MyCustomSource(
          bytes)); //send the bytes to be read from the JustAudio library
      player.play(); //play the audio
    } else {
      // throw Exception('Failed to load audio');
      return;
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EL TTS Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                labelText: 'Enter some text',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                playTextToSpeech(_textFieldController.text);
              },
              child: _isLoadingVoice
                  ? const LinearProgressIndicator()
                  : const Icon(Icons.volume_up),
            ),

            ElevatedButton(onPressed: () async{
              fetchVoices();
            }, child: const Text('Get voices'))
          ],
        ),
      ),
    );
  }





   Future<void> fetchVoices() async
   {
     String voiceRachel =
         '21m00Tcm4TlvDq8ikWAM';
     final String apiUrl = 'https://api.elevenlabs.io/v1/voices';

     try
     {
       // Make a GET request to the API endpoint
       final response = await http.get(
         Uri.parse(apiUrl),
         headers: {
           'accept': 'audio/mpeg',
           'xi-api-key': 'b917e732e7ce1a11e00e3ea643cbf0f8',
         },
       );

       // Check if the request was successful (status code 200)
       if (response.statusCode == 200) {
         // Parse the response JSON data
         final responseData = json.decode(response.body);
         // Use responseData as needed (e.g., display the voices)
         log('Voices: $responseData');
       } else {
         // If the request was not successful, handle the error
         print('Failed to fetch voices: ${response.statusCode}');
       }
     } catch (e) {
       // Handle any errors that occur during the HTTP request
       print('Error fetching voices: $e');
     }
   }


}



// Feed your own stream of bytes into the player
class MyCustomSource extends StreamAudioSource
{
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async
  {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

