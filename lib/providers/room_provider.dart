import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/room.dart';
import '../services/dio_services.dart';

final dioServiceProvider = Provider((ref) => DioService());

final roomsProvider = FutureProvider<List<Room>>((ref) async {
  try {
    final dioService = ref.read(dioServiceProvider);
    final rooms = await dioService.fetchRooms();
    return rooms;
  } catch (e) {
    return [];
  }
});

final searchQueryProvider = StateProvider((ref) => '');

final filteredRoomsProvider = Provider<List<Room>>((ref) {
  final search = ref.watch(searchQueryProvider).toLowerCase();
  return ref.watch(roomsProvider).maybeWhen(
        data: (rooms) => search.isEmpty
            ? rooms
            : rooms
                .where((room) => room.name.toLowerCase().contains(search))
                .toList(),
        orElse: () => [],
      );
});
