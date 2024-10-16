import 'package:uuid/uuid.dart';

class Model {
  final String title;
  final String id;
  final String description;
  //final DateTime time = DateTime.now();

  Model({
    required this.title,
    this.description = '',
  }) : id = const Uuid().v4();
}
