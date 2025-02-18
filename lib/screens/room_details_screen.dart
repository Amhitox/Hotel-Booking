import 'package:chawi_hotel/screens/book_screen.dart';
import 'package:chawi_hotel/utils/constants/responisve.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/room.dart';
import '../utils/constants/colors.dart';

class RoomDetails extends ConsumerStatefulWidget {
  final Room room;
  const RoomDetails({super.key, required this.room});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends ConsumerState<RoomDetails> {
  List<String> images = [
    'assets/images/Room_1.jpg',
    'assets/images/Room_2.jpg',
    'assets/images/Room_3.jpg',
  ];
  bool _isFva = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            if (_isFva)
              // ignore: dead_code
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    _isFva = !_isFva;
                  });
                },
              )
            else
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isFva = !_isFva;
                    });
                  },
                  icon: Icon(Icons.favorite_border)),
          ],
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: context.width,
                padding: EdgeInsets.all(10),
                height: 330,
                child: CarouselView(
                    itemExtent: 320,
                    backgroundColor: Colors.white,
                    itemSnapping: true,
                    children: images
                        .map(
                          (image) => ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              image,
                              width: double.infinity,
                              height: 420,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        .toList()),
              ),
            ),
            Positioned(
              top: 360,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: context.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(146, 31, 112, 34),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  color: AppColors.primary,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.room.name,
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.room.price}\$',
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.room.description,
                        style: GoogleFonts.workSans(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.food_bank,
                            color: Colors.white,
                            size: 40,
                          ),
                          Icon(
                            Icons.light,
                            color: Colors.white,
                            size: 40,
                          ),
                          Icon(
                            Icons.pool,
                            color: Colors.white,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookScreen(
                                        room: widget.room,
                                      )));
                        },
                        child: Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
