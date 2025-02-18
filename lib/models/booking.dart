class Booking {
  final String userId;
  final String roomId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPersons;
  final int totalPrice;
  String payementStatus;
  String bookingStatus;

  Booking({
    required this.userId,
    required this.roomId,
    required this.startDate,
    required this.endDate,
    required this.numberOfPersons,
    required this.totalPrice,
    this.payementStatus = 'pending',
    this.bookingStatus = 'pending',
  });

  void bookRoom(DateTime startDate, DateTime endDate) {
    startDate = startDate;
    endDate = endDate;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roomId': roomId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numberOfPersons': numberOfPersons,
      'totalPrice': totalPrice,
      'payementStatus': payementStatus,
      'bookingStatus': bookingStatus,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      userId: json['userId'] ?? '0',
      roomId: json['roomId'] ?? '0',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      numberOfPersons: json['numberOfPersons'] ?? 1,
      totalPrice: json['totalPrice'] ?? 0,
      payementStatus: json['payementStatus'] ?? 'pending',
      bookingStatus: json['bookingStatus'] ?? 'pending',
    );
  }
}
