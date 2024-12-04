class Model {
  String title;
  final String id;
  String description;

  Model({
    required this.title,
    this.description = '',
    required this.id,
  });
}
