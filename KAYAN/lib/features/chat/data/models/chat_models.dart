// ============================================================
// KAYAN — Chat Data Models
// lib/features/chat/data/models/chat_models.dart
// ============================================================

// ── Message Type ──────────────────────────────────────────────
enum MessageType { text, image, audio, systemInfo }

// ── Message Status ────────────────────────────────────────────
enum MessageStatus { sent, delivered, read }

// ── Message Model ─────────────────────────────────────────────
class ChatMessage {
  final String        id;
  final String        senderId;
  final String        content;
  final MessageType   type;
  final MessageStatus status;
  final DateTime      createdAt;
  final bool          isMe;
  final String?       imageUrl;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    this.type       = MessageType.text,
    this.status     = MessageStatus.read,
    required this.createdAt,
    required this.isMe,
    this.imageUrl,
  });

  bool get isSystem => type == MessageType.systemInfo;
}

// ── Conversation Context ──────────────────────────────────────
enum ConvContext { product, service, classifiedAd, general }

// ── Conversation Model ────────────────────────────────────────
class Conversation {
  final String       id;
  final String       otherUserId;
  final String       otherUserName;
  final String?      otherUserAvatar;
  final bool         otherIsVerified;
  final bool         otherIsOnline;
  final ChatMessage? lastMessage;
  final int          unreadCount;
  final DateTime     updatedAt;
  final ConvContext  context;
  final String?      contextTitleAr; // product/service/ad name
  final String?      contextTitleEn;
  final String?      contextImageUrl;
  final double?      contextPrice;

  const Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    this.otherIsVerified  = false,
    this.otherIsOnline    = false,
    this.lastMessage,
    this.unreadCount      = 0,
    required this.updatedAt,
    this.context          = ConvContext.general,
    this.contextTitleAr,
    this.contextTitleEn,
    this.contextImageUrl,
    this.contextPrice,
  });

  String timeLabel(bool ar) {
    final now  = DateTime.now();
    final diff = now.difference(updatedAt);
    if (diff.inMinutes < 1)   return ar ? 'الآن'        : 'Now';
    if (diff.inHours < 1)     return ar ? '${diff.inMinutes}د' : '${diff.inMinutes}m';
    if (diff.inDays < 1)      return ar ? '${diff.inHours}س'   : '${diff.inHours}h';
    if (diff.inDays < 7)      return ar ? '${diff.inDays}ي'    : '${diff.inDays}d';
    return ar ? '${diff.inDays ~/ 7}أ' : '${diff.inDays ~/ 7}w';
  }
}

// ──────────────────────────────────────────────────────────────
// MOCK DATA
// ──────────────────────────────────────────────────────────────

final _now = DateTime.now();

final mockConversations = [
  Conversation(
    id: 'conv1', otherUserId: 'u1', otherUserName: 'أحمد محمد',
    otherIsVerified: true, otherIsOnline: true,
    unreadCount: 3, updatedAt: _now.subtract(const Duration(minutes: 5)),
    context: ConvContext.classifiedAd,
    contextTitleAr: 'آيفون 15 برو ماكس 256GB', contextTitleEn: 'iPhone 15 Pro Max 256GB',
    contextImageUrl: 'https://picsum.photos/100?random=101', contextPrice: 3200,
    lastMessage: ChatMessage(id:'m1', senderId:'u1', content:'هل السعر قابل للتفاوض؟', createdAt:_now.subtract(const Duration(minutes:5)), isMe:false),
  ),
  Conversation(
    id: 'conv2', otherUserId: 'u2', otherUserName: 'محمد الغامدي',
    otherIsVerified: true, otherIsOnline: false,
    unreadCount: 0, updatedAt: _now.subtract(const Duration(hours: 2)),
    context: ConvContext.service,
    contextTitleAr: 'تركيب تكييف سبليت', contextTitleEn: 'AC Installation',
    contextImageUrl: 'https://picsum.photos/100?random=90', contextPrice: 120,
    lastMessage: ChatMessage(id:'m2', senderId:'me', content:'شكراً، الخدمة ممتازة 🌟', createdAt:_now.subtract(const Duration(hours:2)), isMe:true, status:MessageStatus.read),
  ),
  Conversation(
    id: 'conv3', otherUserId: 'u3', otherUserName: 'سارة العلي',
    otherIsVerified: false, otherIsOnline: true,
    unreadCount: 1, updatedAt: _now.subtract(const Duration(hours: 5)),
    context: ConvContext.classifiedAd,
    contextTitleAr: 'MacBook Pro M3 Pro 14"', contextTitleEn: 'MacBook Pro M3 Pro',
    contextImageUrl: 'https://picsum.photos/100?random=109', contextPrice: 4800,
    lastMessage: ChatMessage(id:'m3', senderId:'u3', content:'متى يمكنني مشاهدته؟', createdAt:_now.subtract(const Duration(hours:5)), isMe:false),
  ),
  Conversation(
    id: 'conv4', otherUserId: 'u4', otherUserName: 'خالد الرشيد',
    otherIsVerified: true, otherIsOnline: false,
    unreadCount: 0, updatedAt: _now.subtract(const Duration(days: 1)),
    context: ConvContext.product,
    contextTitleAr: 'سماعات سوني WH-1000XM5', contextTitleEn: 'Sony WH-1000XM5',
    contextImageUrl: 'https://picsum.photos/100?random=71', contextPrice: 1299,
    lastMessage: ChatMessage(id:'m4', senderId:'u4', content:'تم تأكيد الطلب ✓', createdAt:_now.subtract(const Duration(days:1)), isMe:false, type:MessageType.systemInfo),
  ),
  Conversation(
    id: 'conv5', otherUserId: 'u5', otherUserName: 'فاطمة الزهراني',
    otherIsVerified: false, otherIsOnline: false,
    unreadCount: 0, updatedAt: _now.subtract(const Duration(days: 3)),
    context: ConvContext.classifiedAd,
    contextTitleAr: 'شقة للإيجار - حي العليا', contextTitleEn: 'Apartment for Rent',
    contextPrice: 3500,
    lastMessage: ChatMessage(id:'m5', senderId:'me', content:'سأتواصل معك غداً إن شاء الله', createdAt:_now.subtract(const Duration(days:3)), isMe:true, status:MessageStatus.delivered),
  ),
];

Map<String, List<ChatMessage>> buildMockMessages() => {
  'conv1': [
    ChatMessage(id:'c1m1', senderId:'u1', content:'السلام عليكم، الإعلان لا زال متاحاً؟', createdAt:_now.subtract(const Duration(minutes:62)), isMe:false),
    ChatMessage(id:'c1m2', senderId:'me', content:'وعليكم السلام، نعم لا يزال متاحاً', createdAt:_now.subtract(const Duration(minutes:60)), isMe:true, status:MessageStatus.read),
    ChatMessage(id:'c1m3', senderId:'u1', content:'ممتاز. هل السعر قابل للتفاوض؟', createdAt:_now.subtract(const Duration(minutes:58)), isMe:false),
    ChatMessage(id:'c1m4', senderId:'me', content:'يمكن التفاوض قليلاً، ما هو عرضك؟', createdAt:_now.subtract(const Duration(minutes:55)), isMe:true, status:MessageStatus.read),
    ChatMessage(id:'c1m5', senderId:'u1', content:'هل تقبل 3000 ريال؟', createdAt:_now.subtract(const Duration(minutes:20)), isMe:false),
    ChatMessage(id:'c1m6', senderId:'u1', content:'هل السعر قابل للتفاوض؟', createdAt:_now.subtract(const Duration(minutes:5)), isMe:false),
  ],
  'conv2': [
    ChatMessage(id:'c2m1', senderId:'me', content:'السلام عليكم، هل أنت متاح غداً الساعة 10 صباحاً؟', createdAt:_now.subtract(const Duration(hours:4)), isMe:true, status:MessageStatus.read),
    ChatMessage(id:'c2m2', senderId:'u2', content:'وعليكم السلام، نعم سأكون في منطقتكم الساعة 9-11 صباحاً', createdAt:_now.subtract(const Duration(hours:3, minutes:30)), isMe:false),
    ChatMessage(id:'c2m3', senderId:'me', content:'ممتاز، هذا هو عنواني: حي النخيل، شارع الملك فهد', createdAt:_now.subtract(const Duration(hours:3)), isMe:true, status:MessageStatus.read),
    ChatMessage(id:'c2m4', senderId:'u2', content:'حسناً سأكون هناك في الوقت المحدد ✓', createdAt:_now.subtract(const Duration(hours:2, minutes:30)), isMe:false),
    ChatMessage(id:'c2m5', senderId:'u2', content:'تم الانتهاء من الخدمة بنجاح 🛠️', createdAt:_now.subtract(const Duration(hours:2, minutes:5)), isMe:false, type:MessageType.systemInfo),
    ChatMessage(id:'c2m6', senderId:'me', content:'شكراً، الخدمة ممتازة 🌟', createdAt:_now.subtract(const Duration(hours:2)), isMe:true, status:MessageStatus.read),
  ],
  'conv3': [
    ChatMessage(id:'c3m1', senderId:'u3', content:'مرحباً، هل اللابتوب لا يزال متاحاً؟', createdAt:_now.subtract(const Duration(hours:6)), isMe:false),
    ChatMessage(id:'c3m2', senderId:'me', content:'نعم متاح، ما الذي تريد معرفته؟', createdAt:_now.subtract(const Duration(hours:5, minutes:45)), isMe:true, status:MessageStatus.read),
    ChatMessage(id:'c3m3', senderId:'u3', content:'ما هي حالة البطارية؟ وهل معه ضمان؟', createdAt:_now.subtract(const Duration(hours:5, minutes:30)), isMe:false),
    ChatMessage(id:'c3m4', senderId:'me', content:'البطارية بصحة 96%، والضمان لا يزال ساري لمدة 8 أشهر', createdAt:_now.subtract(const Duration(hours:5, minutes:15)), isMe:true, status:MessageStatus.read),
    ChatMessage(id:'c3m5', senderId:'u3', content:'متى يمكنني مشاهدته؟', createdAt:_now.subtract(const Duration(hours:5)), isMe:false),
  ],
};
