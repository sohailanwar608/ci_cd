import 'package:ci_cd/record_audio.dart';
import 'package:ci_cd/speech.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

/// firebase cli token
/// 1//097RfiF9HBuU6CgYIARAAGAkSNwF-L9IrzUQwaaekdvfcdBQle00trWL-CQ-F9DDjxFhCmKalnvB3eqObYQDYlc8bOOERGx3OmlE

/// instal firebase tools in mac using below command
/// curl -sL firebase.tools | upgrade=true bash

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
      (
      home: AudioRecorder(),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  int _counter = 0;

  void _incrementCounter()
  {
    setState(()
    {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar
        (
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center
        (
        child: Column
          (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            const Text
              (
              'You have pushed the button this ssmany times bbbbbbsss dd:',
            ),
            Text(
              '$_counter',
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton
        (
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
