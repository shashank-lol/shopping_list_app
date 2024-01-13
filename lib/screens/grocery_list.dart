import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/list_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        "shashank-flutter-default-rtdb.firebaseio.com", "shopping-list.json");
    try {
      final response = await http.get(url);
      if (response.body == "null") {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> _loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries.firstWhere(
            (element) => element.value.title == item.value["category"]);
        _loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: category.value));
      }
      setState(() {
        _groceryItems = _loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "Failed to fetch data. Please try again later.";
      });
    }
  }

  void _addItem(BuildContext context) async {
    final newItem = await Navigator.push<GroceryItem>(
        context, MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (newItem == null) return;
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https("shashank-flutter-default-rtdb.firebaseio.com",
        "shopping-list/${item.id}.json");
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _groceryItems.insert(index, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        "No groceries added yet",
      ),
    );
    if (_isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    }
    if (_groceryItems.isNotEmpty) {
      mainContent = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (ctx, index) => GroceryListItem(
                _groceryItems[index],
                onRemoveItem: _removeItem,
              ));
    }
    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
              onPressed: () {
                _addItem(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: mainContent,
    );
  }
}
