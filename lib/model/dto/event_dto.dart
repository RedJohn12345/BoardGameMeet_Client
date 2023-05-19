
import 'dart:ffi';

class UpdateEventRequest {
  late Long id;
  late String name;
  late String game;
  late String city;
  late String address;
  late DateTime date;
  late int maxPersonCount;
  late int minAge;
  late int maxAge;
  late String description;

  UpdateEventRequest(this.id, this.name, this.game, this.city, this.address,
      this.date, this.maxPersonCount, this.minAge, this.maxAge, this.description);
}