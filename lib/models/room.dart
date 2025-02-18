import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Room {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> services;
  final bool available;
  final int maxPersons;
  final List<DateTimeRange> bookedDates;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.services,
    this.available = true,
    this.maxPersons = 4,
    this.bookedDates = const [],
  });

  bool isAvailable(DateTime startDate, DateTime endDate) {
    for (DateTimeRange bookedDate in bookedDates) {
      if (startDate.isBefore(bookedDate.end) &&
          endDate.isAfter(bookedDate.start)) {
        return false;
      }
    }
    return true;
  }

  void bookRoom(DateTime startDate, DateTime endDate) {
    bookedDates.add(DateTimeRange(start: startDate, end: endDate));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'services': services,
      'available': available,
      'maxPersons': maxPersons,
      'bookedDates': bookedDates
          .map((e) => {
                'start': e.start.toIso8601String(),
                'end': e.end.toIso8601String()
              })
          .toList(),
    };
  }

  factory Room.fromJson(Map<String, dynamic> data) {
    return Room(
      id: data['id'] ?? '0',
      name: data['name'] ?? 'No Name',
      description: data['description'] ?? 'No Description',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      image: data['image'] ?? 'assets/images/default_room.jpg',
      services: (data['services'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      available: data['available'] ?? true,
      maxPersons: data['maxPersons'] ?? 4,
      bookedDates: (data['bookedDates'] as List<dynamic>?)
              ?.map((e) => DateTimeRange(
                    start: (e['start'] as Timestamp).toDate(),
                    end: (e['end'] as Timestamp).toDate(),
                  ))
              .toList() ??
          [],
    );
  }
}
