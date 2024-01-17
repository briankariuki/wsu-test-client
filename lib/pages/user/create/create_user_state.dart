import 'package:flutter/foundation.dart';

@immutable
class CreateUser {
  final String email;
  final String displayName;
  final String phoneNumber;

  const CreateUser(this.email, this.displayName, this.phoneNumber);
}

@immutable
abstract class CreateUserMessage {}

class CreateUserInvalidInformationMessage implements CreateUserMessage {
  const CreateUserInvalidInformationMessage();
}

class CreateUserErrorMessage implements CreateUserMessage {
  final String message;
  final Object error;

  const CreateUserErrorMessage(this.message, this.error);
}

class CreateUserSuccessMessage implements CreateUserMessage {
  final String email;

  const CreateUserSuccessMessage(this.email);
}
