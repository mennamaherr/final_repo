import 'package:flutter/material.dart';
import 'package:onservice/models/category_model.dart';
import 'package:onservice/views/category_card.dart';

class CategoriesListView extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const CategoriesListView({
    super.key,
    required this.title,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140, // Adjust the height to fit the category cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return CategoryCard(
                category: categories[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
