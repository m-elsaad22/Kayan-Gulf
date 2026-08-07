import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/delivery_mock_data.dart';
import '../../data/models/delivery_models.dart';

final deliveryVendorsProvider = Provider<List<DeliveryVendor>>((ref) => mockDeliveryVendors);

final deliveryVendorProvider = Provider.family<DeliveryVendor?, String>((ref, slug) {
  return findDeliveryVendor(slug);
});

class DeliveryCartNotifier extends StateNotifier<List<DeliveryCartLine>> {
  DeliveryCartNotifier() : super(const []);

  void addItem(DeliveryVendor vendor, DeliveryMenuItem item) {
    final existing = state.indexWhere((l) => l.item.id == item.id);
    if (existing >= 0) {
      final updated = [...state];
      updated[existing].quantity++;
      state = updated;
      return;
    }
    if (state.isNotEmpty && state.first.vendor.id != vendor.id) {
      state = [DeliveryCartLine(item: item, vendor: vendor)];
      return;
    }
    state = [...state, DeliveryCartLine(item: item, vendor: vendor)];
  }

  void decrement(String itemId) {
    final updated = <DeliveryCartLine>[];
    for (final line in state) {
      if (line.item.id == itemId) {
        if (line.quantity > 1) {
          updated.add(DeliveryCartLine(item: line.item, vendor: line.vendor, quantity: line.quantity - 1));
        }
      } else {
        updated.add(line);
      }
    }
    state = updated;
  }

  void increment(String itemId) {
    state = [
      for (final line in state)
        if (line.item.id == itemId)
          DeliveryCartLine(item: line.item, vendor: line.vendor, quantity: line.quantity + 1)
        else
          line,
    ];
  }

  void clear() => state = const [];

  double get subtotal => state.fold(0, (sum, l) => sum + l.subtotal);

  int get itemCount => state.fold(0, (sum, l) => sum + l.quantity);
}

final deliveryCartProvider = StateNotifierProvider<DeliveryCartNotifier, List<DeliveryCartLine>>((ref) {
  return DeliveryCartNotifier();
});

final deliveryCartCountProvider = Provider<int>((ref) {
  return ref.watch(deliveryCartProvider).fold(0, (sum, l) => sum + l.quantity);
});

final deliveryCartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(deliveryCartProvider).fold(0.0, (sum, l) => sum + l.subtotal);
});
