import 'package:flutter/material.dart';
import 'package:onservice/models/category_model.dart';

import 'widgets/ButtonNavBar.dart';
import '../views/category_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => myHome()),
        //     );
        //     return false; // Prevent default back button behavior
        //   },
        //   child:
        Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: 32.0), // Add more space before the GridView
            Expanded(
              child: cardsGridView(),
            ),
          ],
        ),
      ),
    );
    // );
  }
}

class cardsGridView extends StatelessWidget {
  const cardsGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 16.0, // Spacing between columns
        mainAxisSpacing: 16.0, // Spacing between rows
        childAspectRatio: 1.5,

        // Aspect ratio of the items
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          category: categories[index],
        );
      },
    );
  }
}
