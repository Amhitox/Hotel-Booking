import 'package:chawi_hotel/providers/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestState();
}

class _TestState extends ConsumerState<Test> {
  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(fetchBookings);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: bookings.when(
            data: (data) {
              // Displaying roomId from the first booking
              return Text(data.isNotEmpty
                  ? data[2].endDate.toString()
                  : 'No bookings available');
            },
            error: (err, stack) {
              // Displaying error message
              return Text('Error: $err');
            },
            loading: () {
              // Centering the loading indicator
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
