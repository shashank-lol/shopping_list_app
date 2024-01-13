import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/theme.dart';
import 'package:shopping_list_app/screens/grocery_list.dart';
import 'package:shopping_list_app/widgets/list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shopping List App",
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme,
      home: const GroceryList(),
    );
  }
}
