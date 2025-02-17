import 'package:dio/dio.dart';

import '../models/room.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://run.mocky.io/v3/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<Room>> fetchRooms() async {
    try {
      final response = await _dio.get('457816f4-ea34-4907-a412-f4ddc5b8bd74');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data.containsKey('rooms')) {
          List<dynamic> roomsData = data['rooms'];
          return roomsData.map((room) => Room.fromJson(room)).toList();
        } else {
          throw Exception(
              'Invalid JSON structure: Missing "hotel" or "rooms" key');
        }
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
