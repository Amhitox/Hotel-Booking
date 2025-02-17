import 'package:chawi_hotel/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Searchbar extends ConsumerStatefulWidget {
  const Searchbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchbarState();
}

class _SearchbarState extends ConsumerState<Searchbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: FormBuilder(
          child: FormBuilderTextField(
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
        ));
  }
}
