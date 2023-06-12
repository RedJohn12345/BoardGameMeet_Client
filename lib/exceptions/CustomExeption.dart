class EventNotFoundException implements Exception {
  String errMsg() => 'Мероприятие не найдено, возможно оно было удалено создателем или администратором';
}

class PersonNotFoundException implements Exception {
  String errMsg() => 'Профиль не найден, возможно участник был заблокирован';
}

class KickFromEventException implements Exception {
  String errMsg() => 'Похоже вы были исключены из мероприятия';
}

class InputException implements Exception {
  final String e;

  InputException(this.e);
  String errMsg() => e;
}

// class UnauthorizedException implements Exception {
//   String errMsg() => 'Ошибка авторизации, перезапустите приложение';
// }