import 'package:flutter/foundation.dart';

@immutable
class UpdateUser {
  final String email;
  final String firstName;
  final String lastName;

  const UpdateUser(this.email, this.firstName, this.lastName);
}

@immutable
abstract class UpdateUserMessage {}

class UpdateUserInvalidInformationMessage implements UpdateUserMessage {
  const UpdateUserInvalidInformationMessage();
}

class UpdateUserErrorMessage implements UpdateUserMessage {
  final String message;
  final Object error;

  const UpdateUserErrorMessage(this.message, this.error);
}

class UpdateUserSuccessMessage implements UpdateUserMessage {
  final String email;

  const UpdateUserSuccessMessage(this.email);
}
