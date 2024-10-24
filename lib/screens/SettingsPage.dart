import 'package:flutter/material.dart';
import '../widgets/ButtonNavBar.dart'; 
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Add your widget implementation here
    return  Scaffold(
      appBar: AppBar(title: Text('Setting'),)
    ); // Replace Container() with your desired widget
  }
}
