import 'package:chawi_hotel/providers/room_provider.dart';
import 'package:chawi_hotel/screens/search_screen.dart';
import 'package:chawi_hotel/utils/constants/colors.dart';
import 'package:chawi_hotel/widgets/crouseltopic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/crouselroom.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  List<String> options = ['Top Rated', 'Best Offers', 'Popular'];

  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 248, 233),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
          child: Icon(
            size: 30,
            Icons.menu_sharp,
            color: AppColors.primary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 40, 0),
            child: Icon(
              Icons.notifications_none,
              color: AppColors.primary,
              size: 30,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hi Amhita,',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 0, 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find Your Best Deals',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: FormBuilder(
                  child: FormBuilderTextField(
                    readOnly: true,
                    name: 'search',
                    decoration: InputDecoration(
                        hintText: 'Search Here...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    ),
                  ),
                )),
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Crouseltopic(
                        isSelected: isSelected, topic: options[index]),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  options[_selectedIndex],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 0, 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Hotoke Hotel',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 30, 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'See More',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            decoration: TextDecoration.underline,
                            decorationThickness: 2.0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              child: rooms.when(
                data: (rooms) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) =>
                        CrouselRoom(room: rooms[index])),
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
                error: (err, stack) => Center(
                  child: Text("Error: $err"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
