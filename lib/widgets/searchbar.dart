
import 'package:flutter/material.dart';
import 'package:onservice/models/category_model.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredResults = [];

  void _filterResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredResults = [];
      });
      return;
    }

    final results = <String>[];
    for (var category in categories) {
      if (category.categoryName.toLowerCase().contains(query.toLowerCase())) {
        results.add(category.categoryName);
      }
    }
    setState(() {
      _filteredResults = results;
    });
  }

  void _onResultTap(String result) {
    for (var category in categories) {
      if (category.categoryName == result) {
        // Navigate to the page specified in the category model
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => category.pageName,
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ensure the column does not expand infinitely
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 480, // Set the maximum width
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _filterResults('');
                },
              ),
            ),
            onChanged: _filterResults,
          ),
        ),
        if (_filteredResults.isNotEmpty)
          Container(
            width: 240, // Set the width to half of the search bar's width
            constraints: const BoxConstraints(
              maxHeight: 100, // Set a maximum height for the recommendations list
            ),
            margin: const EdgeInsets.only(top: 8.0), // Add some margin to position it below the search bar
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true, // Ensure the ListView does not expand infinitely
              itemCount: _filteredResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredResults[index]),
                  onTap: () => _onResultTap(_filteredResults[index]),
                );
              },
            ),
          ),
      ],
    );
  }
}

class Category {
  final String name;
  final List<String> subcategories;

  Category(this.name, this.subcategories);
}

class CategoryPage extends StatelessWidget {
  final CategoryModel category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.categoryName),
      ),
      body: Center(
        child: Text('Welcome to ${category.categoryName} page!'),
      ),
    );
  }
}