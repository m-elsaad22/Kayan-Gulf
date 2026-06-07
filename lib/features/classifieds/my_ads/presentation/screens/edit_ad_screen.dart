// TODO: connect to real backend
import 'package:flutter/material.dart';

import '../../../post_ad/presentation/screens/post_ad_screen.dart';

/// Dedicated edit flow — delegates to [PostAdScreen] with [editAdId].
class EditAdScreen extends StatelessWidget {
  final String adId;
  const EditAdScreen({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    return PostAdScreen(editAdId: adId);
  }
}
