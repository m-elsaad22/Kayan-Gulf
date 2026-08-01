import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/admin_data_service.dart';

/// Triggers app-wide rebuild when admin CMS data changes.
final adminConfigRevisionProvider = Provider<int>((ref) {
  return AdminDataService.instance.revision;
});

void notifyAdminConfigChanged() {
  AdminDataService.instance;
}
