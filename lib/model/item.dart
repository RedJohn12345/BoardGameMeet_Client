class Item {
  late String name;
  late bool marked;
  Item({required this.name, required this.marked});

  static fromJson(json) {
    return Item(name: json['name'] as String, marked: json['marked'] as bool);
  }

}