import 'package:todo/models/category.dart';
import 'package:todo/models/model.dart';

class GroceryItem extends Model {
  GroceryItem({
    required super.title,
    super.description,
    required this.quantity,
    required this.category,
    required super.id,
  });

  int quantity;
  Category category;
}
