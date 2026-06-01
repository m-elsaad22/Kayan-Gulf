// ============================================================
// KAYAN — Live Tracking Screen
// lib/features/services/tracking/presentation/screens/live_tracking_screen.dart
//
// Features:
//   • Simulated map with animated provider dot moving to destination
//   • Status timeline (On the Way → Arrived → In Progress → Done)
//   • Provider info card with call + chat buttons
//   • ETA countdown
//   • Booking summary
// ============================================================

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_border_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../routing/app_routes.dart';
import '../../../../../shared/providers/locale_provider.dart';
import '../../data/models/services_models.dart';
import '../../presentation/providers/services_providers.dart';

class LiveTrackingScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const LiveTrackingScreen({super.key, required this.bookingId});

  @override
  ConsumerState<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends ConsumerState<LiveTrackingScreen>
    with TickerProviderStateMixin {

  // Provider dot position (0.0 = start, 1.0 = destination)
  double _progress = 0.0;
  Timer? _moveTimer;

  // Pulsing animation for provider dot
  late final AnimationController _pulseCtrl;
  late final AnimationController _mapLoadCtrl;
  late final Animation<double>   _pulse;
  late final Animation<double>   _mapFade;

  // ETA simulation
  int _etaMinutes = 12;
  Timer? _etaTimer;

  // Status progression simulation
  int _statusIndex = 1; // 0=pending,1=confirmed,2=onTheWay,3=inProgress,4=done
  final _statusEmojis = ['⏳','✅','🚗','🔧','🎉'];
  final _statusLabels = ['قيد الانتظار','مؤكد','الفني في الطريق','جاري التنفيذ','مكتمل'];

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.5, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_pulseCtrl);

    _mapLoadCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800));
    _mapFade = CurvedAnimation(parent: _mapLoadCtrl, curve: Curves.easeOut);
    _mapLoadCtrl.forward();

    // Start provider movement simulation
    _statusIndex = 2; // onTheWay
    _startMovement();
    _startEtaCountdown();
  }

  void _startMovement() {
    _moveTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _progress = (_progress + 0.02).clamp(0.0, 1.0);
      });
      if (_progress >= 0.95 && _statusIndex == 2) {
        setState(() => _statusIndex = 3); // inProgress
      }
    });
  }

  void _startEtaCountdown() {
    _etaTimer = Timer.periodic(const Duration(seconds: 30), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _etaMinutes = (_etaMinutes - 1).clamp(0, 60));
      if (_etaMinutes <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _moveTimer?.cancel();
    _etaTimer?.cancel();
    _pulseCtrl.dispose();
    _mapLoadCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);
    final booking  = ref.watch(bookingDetailProvider(widget.bookingId));

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        centerTitle:     true,
        title: Text(
          isArabic ? 'تتبع الفني' : 'Track Technician',
          style: isArabic
              ? AppTextStyles.arabicTitleMedium
              : AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: Icon(
            isArabic
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Map simulation ───────────────────────────────
          Expanded(
            flex: 5,
            child: FadeTransition(
              opacity: _mapFade,
              child: _MapView(
                progress:   _progress,
                pulse:      _pulse,
                statusIdx:  _statusIndex,
                isArabic:   isArabic,
              ),
            ),
          ),

          // ── Bottom sheet ─────────────────────────────────
          Expanded(
            flex: 6,
            child: Container(
              decoration: const BoxDecoration(
                color:        AppColors.bgSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color:        AppColors.borderDefault,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── ETA Card ─────────────────────────
                    _EtaCard(
                      etaMinutes: _etaMinutes,
                      statusIdx:  _statusIndex,
                      isArabic:   isArabic,
                    ),

                    const SizedBox(height: 16),

                    // ── Status timeline ───────────────────
                    _StatusTimeline(
                      currentIdx: _statusIndex,
                      isArabic:   isArabic,
                    ),

                    const SizedBox(height: 16),

                    // ── Provider card ─────────────────────
                    booking.when(
                      loading: () => const SizedBox.shrink(),
                      error:   (_, __) => const SizedBox.shrink(),
                      data: (b) => _ProviderTrackCard(
                        booking:  b,
                        isArabic: isArabic,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Action row ────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color:        AppColors.bgCard2,
                                borderRadius: AppBorderRadius.button,
                                border:       Border.all(
                                    color: AppColors.borderDefault),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.chat_bubble_outline_rounded,
                                      size: 16, color: AppColors.royalBlue),
                                  const SizedBox(width: 6),
                                  Text(
                                    isArabic ? 'مراسلة' : 'Message',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.royalBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => HapticFeedback.lightImpact(),
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color:        AppColors.success.withOpacity(0.1),
                                borderRadius: AppBorderRadius.button,
                                border:       Border.all(
                                  color: AppColors.success.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.phone_rounded,
                                      size: 16, color: AppColors.success),
                                  const SizedBox(width: 6),
                                  Text(
                                    isArabic ? 'اتصال' : 'Call',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Cancel booking
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                  isArabic ? 'إلغاء الحجز؟' : 'Cancel Booking?',
                                ),
                                content: Text(
                                  isArabic
                                      ? 'هل أنت متأكد من إلغاء الحجز؟'
                                      : 'Are you sure you want to cancel?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(isArabic ? 'لا' : 'No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.pop();
                                    },
                                    child: Text(
                                      isArabic ? 'إلغاء' : 'Cancel',
                                      style: const TextStyle(
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width:  46, height: 46,
                            decoration: BoxDecoration(
                              color:        AppColors.errorBg,
                              borderRadius: AppBorderRadius.button,
                              border:       Border.all(
                                  color: AppColors.borderError),
                            ),
                            child: const Icon(Icons.close_rounded,
                                size: 18, color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// MAP VIEW  (Custom Painted simulation)
// ──────────────────────────────────────────────────────────────
class _MapView extends StatelessWidget {
  final double            progress;
  final Animation<double> pulse;
  final int               statusIdx;
  final bool              isArabic;

  const _MapView({
    required this.progress,
    required this.pulse,
    required this.statusIdx,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) => CustomPaint(
        painter: _MapPainter(
          progress:  progress,
          pulse:     pulse.value,
          statusIdx: statusIdx,
        ),
        child: Stack(
          children: [
            // Destination label
            Positioned(
              bottom: 60,
              right:  30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color:        AppColors.bgCard.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border:       Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home_rounded,
                        size: 14, color: AppColors.royalBlue),
                    const SizedBox(width: 4),
                    Text(
                      isArabic ? 'موقعك' : 'Your location',
                      style: AppTextStyles.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
            // Provider label
            Positioned(
              top: 40,
              left: _lerp(30, MediaQuery.sizeOf(context).width - 120, progress),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient:     AppGradients.primaryButton,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color:      AppColors.royalBlue.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🚗', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      isArabic ? 'الفني' : 'Technician',
                      style: AppTextStyles.badge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

class _MapPainter extends CustomPainter {
  final double progress;
  final double pulse;
  final int    statusIdx;

  const _MapPainter({
    required this.progress,
    required this.pulse,
    required this.statusIdx,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── Background ─────────────────────────────────────
    final bgPaint = Paint()..color = const Color(0xFF0D2040);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // ── Grid roads ────────────────────────────────────
    final roadPaint = Paint()
      ..color       = const Color(0xFF162C50)
      ..strokeWidth = 8
      ..strokeCap   = StrokeCap.round;

    final smallRoadPaint = Paint()
      ..color       = const Color(0xFF112035)
      ..strokeWidth = 4;

    // Horizontal roads
    for (double y = 60; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), smallRoadPaint);
    }
    // Vertical roads
    for (double x = 60; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), smallRoadPaint);
    }
    // Main road (diagonal-ish route)
    final path = Path()
      ..moveTo(40, size.height - 80)
      ..cubicTo(
        size.width * 0.3, size.height * 0.7,
        size.width * 0.7, size.height * 0.3,
        size.width - 40, 80,
      );
    canvas.drawPath(
      path,
      roadPaint..color = const Color(0xFF1E3A6A)..strokeWidth = 12,
    );

    // ── Route highlight ───────────────────────────────
    final routePaint = Paint()
      ..color       = AppColors.royalBlue.withOpacity(0.6)
      ..strokeWidth = 4
      ..strokeCap   = StrokeCap.round
      ..style       = PaintingStyle.stroke;

    final pathMeasure = PathMetric(path, false);
    final routedPath  = pathMeasure.extractPath(
      0, pathMeasure.length * progress);
    canvas.drawPath(routedPath, routePaint);

    // ── Provider dot ──────────────────────────────────
    final pt = _getPoint(path, progress, pathMeasure.length);

    // Pulse ring
    canvas.drawCircle(
      pt,
      20 * pulse,
      Paint()..color = AppColors.royalBlue.withOpacity(0.15 * pulse),
    );
    canvas.drawCircle(
      pt,
      14,
      Paint()..color = AppColors.royalBlue.withOpacity(0.3),
    );
    canvas.drawCircle(
      pt,
      10,
      Paint()..color = AppColors.royalBlue,
    );
    canvas.drawCircle(
      pt,
      6,
      Paint()..color = Colors.white,
    );

    // ── Destination pin ───────────────────────────────
    final destPt = Offset(size.width - 40, 80);
    canvas.drawCircle(
      destPt,
      16,
      Paint()..color = AppColors.royalBlue.withOpacity(0.2),
    );
    canvas.drawCircle(
      destPt,
      10,
      Paint()..color = AppColors.royalBlue,
    );
    canvas.drawCircle(
      destPt,
      5,
      Paint()..color = Colors.white,
    );
  }

  Offset _getPoint(Path path, double t, double totalLen) {
    final m = PathMetric(path, false);
    final pos = m.getTangentForOffset(totalLen * t.clamp(0.001, 0.999));
    return pos?.position ?? const Offset(40, 300);
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.progress != progress || old.pulse != pulse;
}

// ──────────────────────────────────────────────────────────────
// ETA CARD
// ──────────────────────────────────────────────────────────────
class _EtaCard extends StatelessWidget {
  final int  etaMinutes;
  final int  statusIdx;
  final bool isArabic;
  const _EtaCard({
    required this.etaMinutes,
    required this.statusIdx,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabels = isArabic
        ? ['قيد الانتظار','مؤكد','الفني في الطريق','جاري التنفيذ','مكتمل']
        : ['Pending','Confirmed','On the Way','In Progress','Completed'];
    final statusColors = [
      AppColors.warning, AppColors.royalBlue,
      AppColors.categoryTeal, AppColors.categoryPurple, AppColors.success,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          statusColors[statusIdx].withOpacity(0.15),
          statusColors[statusIdx].withOpacity(0.05),
        ]),
        borderRadius: AppBorderRadius.card,
        border:       Border.all(
          color: statusColors[statusIdx].withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // ETA
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'وقت الوصول المتوقع' : 'Estimated Arrival',
                style: AppTextStyles.caption,
              ),
              Text(
                statusIdx >= 3
                    ? (isArabic ? 'وصل الفني ✅' : 'Technician arrived ✅')
                    : '$etaMinutes ${isArabic ? "دقيقة" : "min"}',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: statusColors[statusIdx],
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color:        statusColors[statusIdx].withOpacity(0.15),
              borderRadius: AppBorderRadius.pill,
              border:       Border.all(
                color: statusColors[statusIdx].withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ['⏳','✅','🚗','🔧','🎉'][statusIdx],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabels[statusIdx],
                  style: AppTextStyles.labelMedium.copyWith(
                    color: statusColors[statusIdx],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// STATUS TIMELINE
// ──────────────────────────────────────────────────────────────
class _StatusTimeline extends StatelessWidget {
  final int  currentIdx;
  final bool isArabic;
  const _StatusTimeline({required this.currentIdx, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final steps = isArabic
        ? ['مؤكد', 'في الطريق', 'جاري التنفيذ', 'مكتمل']
        : ['Confirmed', 'On the Way', 'In Progress', 'Done'];
    final icons = [Icons.check_circle_rounded, Icons.local_shipping_rounded,
        Icons.build_rounded, Icons.star_rounded];

    // Map statusIdx (0-4) to step index (0-3)
    final stepIdx = (currentIdx - 1).clamp(0, 3);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector
          final done = (i ~/ 2) < stepIdx;
          return Expanded(
            child: Container(
              height: 2,
              color: done ? AppColors.royalBlue : AppColors.bgCard2,
            ),
          );
        }
        final idx  = i ~/ 2;
        final done = idx <= stepIdx;
        final curr = idx == stepIdx;

        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width:  curr ? 36 : 28,
              height: curr ? 36 : 28,
              decoration: BoxDecoration(
                shape:    BoxShape.circle,
                gradient: done ? AppGradients.primaryButton : null,
                color:    done ? null : AppColors.bgCard2,
                boxShadow: curr ? [
                  BoxShadow(
                    color:      AppColors.royalBlue.withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ] : [],
              ),
              child: Icon(
                icons[idx],
                size:  curr ? 18 : 14,
                color: done ? Colors.white : AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              steps[idx],
              style: AppTextStyles.caption.copyWith(
                color: done ? AppColors.royalBlue : AppColors.textMuted,
                fontWeight: curr ? FontWeight.w700 : FontWeight.w400,
                fontSize: 8,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PROVIDER TRACK CARD
// ──────────────────────────────────────────────────────────────
class _ProviderTrackCard extends StatelessWidget {
  final BookingModel booking;
  final bool         isArabic;
  const _ProviderTrackCard({required this.booking, required this.isArabic});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color:        AppColors.bgCard,
      borderRadius: AppBorderRadius.md,
      border:       Border.all(color: AppColors.borderSubtle),
    ),
    child: Row(children: [
      Container(
        width:  44, height: 44,
        decoration: BoxDecoration(
          shape:    BoxShape.circle,
          gradient: AppGradients.primaryButton),
        child: Center(
          child: Text(
            booking.providerName.isNotEmpty ? booking.providerName[0] : '?',
            style: const TextStyle(
              fontSize:   18,
              fontWeight: FontWeight.w800,
              color:      Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(booking.providerName,
              style: isArabic ? AppTextStyles.arabicTitleSmall : AppTextStyles.titleSmall),
          const SizedBox(width: 6),
          const Icon(Icons.verified_rounded, size: 14, color: AppColors.royalBlue),
        ]),
        Text(booking.serviceNameAr,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
      ])),
      const Icon(Icons.star_rounded, size: 14, color: AppColors.starFilled),
      const SizedBox(width: 2),
      const Text('4.9', style: AppTextStyles.rating),
    ]),
  );
}
