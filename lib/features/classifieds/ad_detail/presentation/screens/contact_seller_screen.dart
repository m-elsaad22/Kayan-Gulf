import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/app_routes.dart';

/// Opens classifieds seller chat (117-cl-chat-seller).
class ContactSellerScreen extends ConsumerStatefulWidget {
  const ContactSellerScreen({super.key});

  @override
  ConsumerState<ContactSellerScreen> createState() => _ContactSellerScreenState();
}

class _ContactSellerScreenState extends ConsumerState<ContactSellerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.replace(AppRoutes.classifiedsChatPath('khalid'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
