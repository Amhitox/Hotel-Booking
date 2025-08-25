import 'package:chawi_hotel/models/room.dart';
import 'package:chawi_hotel/utils/constants/colors.dart';
import 'package:chawi_hotel/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/services.dart';


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
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: isCheckIn ? DateTime.now() : _checkInDate,
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate.isBefore(_checkInDate)) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  int _calc() {
    return _checkOutDate.difference(_checkInDate).inDays;
  }

  int _fullprice() => widget.room.price.toInt() * _numberOfPersons * _calc();

  Future<void> _generateAndSharePDF() async {
    try {
      final pdf = pw.Document();

      final logoImage = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(40),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(logoImage, width: 100, height: 100),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('CHAWİ HOTEL',
                              style: pw.TextStyle(
                                  fontSize: 24,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.blue900)),
                          pw.Text('Booking Confirmation',
                              style: pw.TextStyle(
                                  fontSize: 16, color: PdfColors.grey700)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(5)),
                    ),
                    child: pw.Text(
                      'Booking Reference: ${DateTime.now().millisecondsSinceEpoch}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.blue900,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(10)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Room Details',
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900)),
                        pw.Divider(color: PdfColors.grey300),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Room Name:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text(widget.room.name),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Price per night:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${widget.room.price.toInt()}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(10)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Booking Details',
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900)),
                        pw.Divider(color: PdfColors.grey300),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Check-in Date:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text(DateFormat.yMMMd().format(_checkInDate)),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Check-out Date:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text(DateFormat.yMMMd().format(_checkOutDate)),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Number of Guests:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('$_numberOfPersons'),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Number of Nights:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('${_calc()}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(10)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total Amount:',
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900)),
                        pw.Text('\$${_fullprice()}',
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900)),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(10)),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text('Thank you for choosing CHAWİ HOTEL!',
                            style: pw.TextStyle(
                                fontSize: 14,
                                color: PdfColors.grey700,
                                fontStyle: pw.FontStyle.italic)),
                        pw.SizedBox(height: 5),
                        pw.Text(
                            'For any inquiries, please contact us at support@chawihotel.com',
                            style: pw.TextStyle(
                                fontSize: 12, color: PdfColors.grey600)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/booking_confirmation.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Your CHAWİ HOTEL Booking Confirmation',
      );
    } catch (e) {
      customDialogBox(
        context,
        title: 'Error',
        message: 'Failed to generate PDF: $e',
      );
    }
  }

  Future<void> _book(DateTime startDate, DateTime endDate) async {
    if (_checkOutDate.isBefore(_checkInDate)) {
      customDialogBox(
        context,
        title: 'Invalid Dates',
        message: 'Check-out date must be after check-in date',
      );
      return;
    }

    if (_numberOfPersons > widget.room.maxPersons) {
      customDialogBox(
        context,
        title: 'Too Many Guests',
        message:
            'This room can only accommodate ${widget.room.maxPersons} persons',
      );
      return;
    }

    try {
      final roomSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('id', isEqualTo: widget.room.id)
          .limit(1)
          .get();

      if (roomSnapshot.docs.isEmpty) {
        customDialogBox(
          context,
          title: 'Error',
          message: 'Room not found.',
        );
        return;
      }

      final roomDoc = roomSnapshot.docs.first;
      final roomData = roomDoc.data();
      final List<dynamic> bookedDates = roomData['bookedDates'] ?? [];

      bool hasConflict = false;
      for (var booking in bookedDates) {
        final bookingStart = (booking['start'] as Timestamp).toDate();
        final bookingEnd = (booking['end'] as Timestamp).toDate();

        if (startDate.isBefore(bookingEnd) && endDate.isAfter(bookingStart)) {
          hasConflict = true;
          break;
        }
      }

      if (hasConflict) {
        customDialogBox(
          context,
          title: 'Warning',
          message: 'Room isn\'t available on the chosen dates. Try again.',
        );
        return;
      }

      final newBooking = {
        'start': Timestamp.fromDate(startDate),
        'end': Timestamp.fromDate(endDate),
        'numberOfPersons': _numberOfPersons,
        'totalPrice': _fullprice(),
        'bookingDate': Timestamp.now(),
      };

      await roomDoc.reference.update({
        'bookedDates': FieldValue.arrayUnion([newBooking])
      });

      await _generateAndSharePDF();

      customSnackbar(
        context,
        'Booking confirmed from ${DateFormat.yMMMd().format(startDate)} to ${DateFormat.yMMMd().format(endDate)}',
      );
    } catch (e) {
      customDialogBox(
        context,
        title: 'Error',
        message: 'There was an error processing your booking: $e',
      );
    }
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
