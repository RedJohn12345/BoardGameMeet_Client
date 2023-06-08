class EventNotFoundException implements Exception {
  String errMsg() => 'Мероприятие не найдено, возможно оно было удалено создателем или администратором';
}

class UnauthorizedException implements Exception {
  String errMsg() => 'Ошибка авторизации, перезапустите приложение';
}