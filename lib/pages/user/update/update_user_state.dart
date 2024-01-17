import 'package:flutter/foundation.dart';

@immutable
class UpdateUser {
  final String email;
  final String displayName;
  final String phoneNumber;

  const UpdateUser(this.email, this.displayName, this.phoneNumber);
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
