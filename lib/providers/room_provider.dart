import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
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

final firebaseProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final fetchrooms = FutureProvider<List<Room>>((ref) async {
  final fbwatcher = ref.watch(firebaseProvider);
  final rawData = await fbwatcher.collection('rooms').get();
  return rawData.docs.map((data) => Room.fromJson(data.data())).toList();
});

final fetchBookings = FutureProvider<List<Booking>>((ref) async {
  final fbwatcher = ref.watch(firebaseProvider);
  final rawData = await fbwatcher.collection('booking').get();
  return rawData.docs.map((data) => Booking.fromJson(data.data())).toList();
});

final searchQueryProvider = StateProvider((ref) => '');

final filteredRoomsProvider = Provider<List<Room>>((ref) {
  final search = ref.watch(searchQueryProvider).toLowerCase();
  return ref.watch(fetchrooms).maybeWhen(
        data: (rooms) => search.isEmpty
            ? rooms
            : rooms
                .where((room) => room.name.toLowerCase().contains(search))
                .toList(),
        orElse: () => [],
      );
});
