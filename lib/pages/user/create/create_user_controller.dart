import 'package:client/api/base_response.dart';
import 'package:client/api/user_api.dart';
import 'package:client/model/app_error.dart';
import 'package:client/model/user.dart';
import 'package:client/pages/home/home_page_controller.dart';
import 'package:client/util/mappers.dart';
import 'package:client/util/validators.dart';
import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'create_user_state.dart';

class CreateUserController {
  final Stream<bool> isFetching$;
  final Function() createUser;
  final BehaviorSubject<User> user$;

  final Function(String) emailChanged;
  final Function(String) nameChanged;
  final Function(String) phoneNumberChanged;

  final Stream<String?> emailError$;
  final Stream<String?> nameError$;
  final Stream<String?> phoneNumberError$;

  final Stream<CreateUserMessage> message$;

  CreateUserController._({
    required this.isFetching$,
    required this.createUser,
    required this.user$,
    required this.emailChanged,
    required this.phoneNumberChanged,
    required this.nameChanged,
    required this.emailError$,
    required this.nameError$,
    required this.phoneNumberError$,
    required this.message$,
  });

  factory CreateUserController(HomeController homeController) {
    if (kDebugMode) {
      print('CreateUserController init');
    }

    final UserApi userApi = UserApi();

    final isFetchingController = BehaviorSubject<bool>.seeded(false);

    final createUserController = PublishSubject<void>();
    final userController = BehaviorSubject<User>();
    final emailController = PublishSubject<String>();
    final nameController = PublishSubject<String>();
    final phoneNumberController = PublishSubject<String>();

    final isValidSubmit$ = Rx.combineLatest4(
      emailController.stream.map(Validator.isValidEmail),
      phoneNumberController.stream.map(Validator.isValidPhonenumber),
      isFetchingController.stream,
      nameController.stream.map(Validator.isValidUserName),
      (bool isValidEmail, bool isValidPhonenumber, bool isLoading, bool isValidName) => isValidEmail && isValidPhonenumber && !isLoading && isValidName,
    ).shareValueSeeded(false);

    final createUser$ = Rx.combineLatest3(
      emailController.stream,
      nameController.stream,
      phoneNumberController.stream,
      (String email, String name, String phoneNumber) => CreateUser(email, name, phoneNumber),
    );

    final submit$ = createUserController.stream.withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid).share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(
            createUser$,
            (_, CreateUser user) => user,
          )
          .exhaustMap(
            (user) => userApi
                .create({
                  "email": user.email,
                  "phoneNumber": user.phoneNumber,
                  "displayName": user.displayName,
                })
                .asStream()
                .toEitherStream(Mappers.errorToAppError)
                .doOn(
                  listen: () => isFetchingController.add(true),
                  cancel: () => isFetchingController.add(false),
                  data: (result) => result.findOrNull(
                    (value) {
                      homeController.updateUser(value.data!.user!);
                      return false;
                    },
                  ),
                )
                .map((event) => _responseToMessage(event, user.email)),
          ),
      submit$.where((isValid) => !isValid).map(
            (_) => const CreateUserInvalidInformationMessage(),
          )
    ]).whereNotNull().share();

    //Format Errors
    final emailError$ = emailController.stream
        .map((email) {
          if (Validator.isValidEmail(email)) return null;
          return 'Invalid email address';
        })
        .distinct()
        .share();

    final phoneNumberError$ = phoneNumberController.stream
        .map((phoneNumber) {
          if (Validator.isValidPhonenumber(phoneNumber)) return null;
          return 'Phonenumber must be at least 6 characters';
        })
        .distinct()
        .share();

    final nameError$ = nameController.stream
        .map((name) {
          if (Validator.isValidUserName(name)) return null;
          return 'Name must be at least 3 characters';
        })
        .distinct()
        .share();

    return CreateUserController._(
      isFetching$: isFetchingController,
      createUser: () => createUserController.add(null),
      nameChanged: (value) => nameController.add(value.trim()),
      emailChanged: (value) => emailController.add(value.trim()),
      phoneNumberChanged: (value) => phoneNumberController.add(value.trim()),
      user$: userController,
      emailError$: emailError$,
      nameError$: nameError$,
      phoneNumberError$: phoneNumberError$,
      message$: message$,
    );
  }

  dispose() {
    isFetching$.drain();
    user$.drain();
    user$.close();

    emailError$.drain();
    nameError$.drain();
    phoneNumberError$.drain();

    message$.drain();

    if (kDebugMode) {
      print('CreateUserController disposed');
    }
  }

  static CreateUserMessage? _responseToMessage(Either<AppError, Response<BaseResponse>> result, String email) {
    return result.fold(
      ifRight: (_) => CreateUserSuccessMessage(email),
      ifLeft: (appError) => CreateUserErrorMessage(appError.message!, appError.error!),
    );
  }
}
