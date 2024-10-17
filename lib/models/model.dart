class Model {
  String title;
  final String id;
  String description;
  //final DateTime time = DateTime.now();

  Model({
    required this.title,
    this.description = '',
    required this.id,
  });
}
