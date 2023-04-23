import 'package:flutter/material.dart';

class MessageTabPage extends StatefulWidget {
  const MessageTabPage({Key? key}) : super(key: key);

  @override
  State<MessageTabPage> createState() => _MessageTabPageState();
}

class _MessageTabPageState extends State<MessageTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Message"
      ),
    );
  }
}

