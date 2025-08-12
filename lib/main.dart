import 'package:flutter/material.dart';
import 'package:midc_chatbot/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIDC Chatbot',
      debugShowCheckedModeBanner: false,
      home: const ChatScreen()
    );
  }
}