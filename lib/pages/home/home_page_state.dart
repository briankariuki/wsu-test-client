import 'package:flutter/foundation.dart';

@immutable
abstract class HomeMessage {}

class HomeInvalidInformationMessage implements HomeMessage {
  const HomeInvalidInformationMessage();
}

class HomeErrorMessage implements HomeMessage {
  final String message;
  final Object error;

  const HomeErrorMessage(this.message, this.error);
}

class HomeSuccessMessage implements HomeMessage {
  final String message;

  const HomeSuccessMessage(this.message);
}
