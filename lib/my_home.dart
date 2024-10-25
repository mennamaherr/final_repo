import 'package:flutter/material.dart';
import 'package:onservice/views/OffersListView.dart';
import 'package:onservice/views/categories_list_view.dart';

import 'package:onservice/widgets/searchbar.dart'as custom;
import 'screens/CategoriesPage.dart';
import 'widgets/ButtonNavBar.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'),),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.all(20.0), // Adjust padding for welcome text
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10), // Space above welcome text
                  const Text(
                    'Here, you get the comfort of a well-maintained Home ;)',
                    style: TextStyle(
                      fontSize: 28, // Adjust font size for header
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                      height: 16), // Spacing between title and search bar
                  custom.SearchBar(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CategoriesListView(
              title: 'Home Services',
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesPage(),
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(height: 20)), // Extra spacing before offers
          const SliverFillRemaining(child: OffersListView()),
         // SliverToBoxAdapter(child: ButtonNavBar(),)
        ],
      ),
    );
  }
}
