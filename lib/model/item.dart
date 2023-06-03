class Item {
  late String name;
  late bool marked;
  late int id;
  Item({required this.name, required this.marked});

  static fromJson(json) {
    var item =  Item(name: json['name'] as String, marked: json['marked'] as bool);
    item.id = json['itemId'] as int;
    return item;
  }

}