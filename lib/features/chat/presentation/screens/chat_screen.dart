import 'package:flutter/material.dart';

import 'chat_light_screen.dart';

/// غرفة المحادثة — legacy alias يوجّه إلى [ChatLightScreen] (تصميم خفيف).
class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.convId,
    this.adTitle,
    this.adImage,
  });

  final String convId;
  final String? adTitle;
  final String? adImage;

  @override
  Widget build(BuildContext context) {
    return ChatLightScreen(
      convId: convId,
      adTitle: adTitle,
      adImage: adImage,
    );
  }
}
