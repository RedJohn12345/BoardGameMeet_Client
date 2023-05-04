class Item {
  late String name;
  Item({required this.name});

  static fromJson(json) {
    return Item(name: json['name'] as String);
  }

}