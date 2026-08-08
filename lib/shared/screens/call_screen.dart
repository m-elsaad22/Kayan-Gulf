import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kayan_design_tokens.dart';
import '../../shared/providers/locale_provider.dart';

/// شاشة المكالمة — light design
class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key, this.name, this.avatar});

  final String? name;
  final String? avatar;

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  Timer? _timer;
  int _seconds = 0;
  bool _muted = false;
  bool _speaker = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _duration {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    final name = widget.name ?? (ar ? 'أحمد الغامدي' : 'Ahmed Al-Ghamdi');
    final initial = name.isNotEmpty ? name.trim()[0] : 'ك';

    return Scaffold(
      backgroundColor: KayanDesignTokens.kBlueDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              Text(ar ? 'مكالمة جارية' : 'Ongoing call', style: KayanDesignTokens.cairo(color: Colors.white70)),
              const Spacer(),
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(gradient: KayanDesignTokens.gradGold, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(initial, style: KayanDesignTokens.cairo(fontSize: 40, fontWeight: FontWeight.w900, color: const Color(0xFF402C00))),
              ),
              const SizedBox(height: 20),
              Text(name, style: KayanDesignTokens.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 6),
              Text(_duration, style: KayanDesignTokens.cairo(fontSize: 16, color: Colors.white70)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallBtn(
                    icon: _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: ar ? 'كتم' : 'Mute',
                    active: _muted,
                    onTap: () => setState(() => _muted = !_muted),
                  ),
                  _CallBtn(
                    icon: _speaker ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                    label: ar ? 'سماعة' : 'Speaker',
                    active: _speaker,
                    onTap: () => setState(() => _speaker = !_speaker),
                  ),
                  _CallBtn(
                    icon: Icons.videocam_rounded,
                    label: ar ? 'فيديو' : 'Video',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(color: KayanDesignTokens.danger, shape: BoxShape.circle),
                  child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallBtn extends StatelessWidget {
  const _CallBtn({required this.icon, required this.label, this.onTap, this.active = false});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: active ? KayanDesignTokens.kBlueDeep : Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: KayanDesignTokens.cairo(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }
}
