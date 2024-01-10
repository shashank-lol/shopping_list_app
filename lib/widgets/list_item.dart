import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem(this.groceryItem, {required this.onRemoveItem,super.key});

  final GroceryItem groceryItem;
  final void Function(GroceryItem item) onRemoveItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Dismissible(
        onDismissed: (direction){
          onRemoveItem(groceryItem);
        },
        background: Container(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
        key: ValueKey(groceryItem.id),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              color: groceryItem.category.color,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              groceryItem.name,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const Spacer(),
            Text(
              "${groceryItem.quantity}",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }
}
