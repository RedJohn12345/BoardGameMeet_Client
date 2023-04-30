

enum Sex {
  MAN(title: "Мужской"),
  WOMAN(title: "Женский"),
  NONE(title: "Не указывать");


  final String title;


  const Sex({required this.title});

}