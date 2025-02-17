import 'package:chawi_hotel/models/room.dart';
import 'package:chawi_hotel/utils/constants/colors.dart';
import 'package:chawi_hotel/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../testmodels/booking.dart';

class BookScreen extends ConsumerStatefulWidget {
  final Room room;
  const BookScreen({super.key, required this.room});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> {
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 1));
  int _numberOfPersons = 1;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  int _fullprice() =>
      widget.room.price.toInt() *
      _numberOfPersons *
      ((_checkOutDate.day.toInt()) - (_checkInDate.day.toInt()));

  Future<void> _book(DateTime startDate, DateTime endDate) async {
    final booking = Booking(
      userId: '0',
      roomId: widget.room.id,
      startDate: startDate,
      endDate: endDate,
      numberOfPersons: _numberOfPersons,
      totalPrice: _fullprice(),
    );
    await FirebaseFirestore.instance
        .collection('booking')
        .add(booking.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Book Your Stay",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoomDetailsCard(context),
            const SizedBox(height: 20),
            _buildBookingDetailsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomDetailsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(widget.room.image,
                  width: double.infinity, height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(widget.room.name,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rating: 4.5",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                Text("${widget.room.price.toInt()}\$ / night",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
            const SizedBox(height: 5),
            Text(widget.room.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetailsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book Now',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDateSelector('Check-In Date:', _checkInDate,
                () => _selectDate(context, true)),
            _buildDateSelector('Check-Out Date:', _checkOutDate,
                () => _selectDate(context, false)),
            _buildPersonSelector(),
            _buildTotalPrice(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15)),
              onPressed: () {
                customSnackbar(context,
                    'Booking confirmed from ${DateFormat.yMMMd().format(_checkInDate)} to ${DateFormat.yMMMd().format(_checkOutDate)}');
                _book(_checkInDate, _checkOutDate);
              },
              child: Center(
                  child: Text('Confirm Booking',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
                date != null ? DateFormat.yMMMd().format(date) : 'Select Date',
                style: GoogleFonts.poppins(fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Guests:',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => setState(() {
                _numberOfPersons = (_numberOfPersons > 1)
                    ? --_numberOfPersons
                    : _numberOfPersons;
              }),
            ),
            Text('$_numberOfPersons', style: GoogleFonts.poppins(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () => setState(
                () {
                  _numberOfPersons = (_numberOfPersons < 5)
                      ? ++_numberOfPersons
                      : _numberOfPersons;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total:',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        Text('${_fullprice()}\$',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green)),
      ],
    );
  }
}
