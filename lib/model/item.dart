class Item {
  late String name;
  late bool marked;
  late int id;
  Item({required this.name, required this.marked});

  static fromJson(json) {
    return Item(name: json['name'] as String, marked: json['marked'] as bool);
  }

}