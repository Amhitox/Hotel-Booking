import 'package:chawi_hotel/providers/room_provider.dart';
import 'package:chawi_hotel/widgets/listroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomsProvider);
    final filteredRooms = ref.watch(filteredRoomsProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: FormBuilder(
              child: FormBuilderTextField(
                name: 'search',
                autofocus: true,
                decoration: InputDecoration(
                  helperStyle: TextStyle(color: Colors.black87),
                  hintText: 'Search Here...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value ?? '',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: rooms.when(
                data: (roomList) {
                  return filteredRooms.isEmpty
                      ? const Center(child: Text("No rooms found"))
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: filteredRooms.length,
                          itemBuilder: (context, index) {
                            return ListOfRooms(room: filteredRooms[index]);
                          },
                        );
                },
                loading: () => ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
