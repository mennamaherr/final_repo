import 'package:onservice/screens/subcategory_screen copy.dart' as sub1;
import 'package:onservice/screens/subcategory_screen.dart' as sub;
import 'package:flutter/material.dart';

class CategoryModel {
  final String image;
  final String categoryName;
  final Widget pageName;

  const CategoryModel({
    required this.image,
    required this.categoryName,
    required this.pageName,
  });
}

List<CategoryModel> categories = [
  CategoryModel(
    image: 'assets/Cleaning Services.jpeg',
    categoryName: 'Cleaning Services',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/Landscaping.jpeg',
    categoryName: 'Landscaping',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/appliance Repair.jpeg',
    categoryName: 'Appliance Repair',
    pageName: sub1.SubcategoryScreencopy(),
  ),
  CategoryModel(
    image: 'assets/electricals.jpeg',
    categoryName: 'Electrical Services',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/Paintingsjpeg.jpeg',
    categoryName: 'Paintings',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/shiftingjpeg.jpeg',
    categoryName: 'Shifting Services',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/handyman.jpeg',
    categoryName: 'Handyman Services',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/Home Security.jpeg',
    categoryName: 'Home Security',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/Pest Control.jpeg',
    categoryName: 'Pest Control',
    pageName: sub.SubCategoryScreen(),
  ),
  CategoryModel(
    image: 'assets/plumbing.jpeg',
    categoryName: 'Plumbing Services',
    pageName: sub.SubCategoryScreen(),
  ),
];
