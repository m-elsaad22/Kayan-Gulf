import 'package:flutter/material.dart';

import 'conversations_light_screen.dart';

/// المحادثات — legacy alias يوجّه إلى [ConversationsLightScreen] (تصميم خفيف).
class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) => const ConversationsLightScreen();
}
