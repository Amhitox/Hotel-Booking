import 'package:chawi_hotel/screens/room_details_screen.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';

class CrouselRoom extends StatelessWidget {
  final Room room;
  const CrouselRoom({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RoomDetails(room: room)));
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Image.asset(
                room.image,
                fit: BoxFit.cover,
                height: 288,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
