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

import 'update_user_state.dart';

class UpdateUserController {
  final Stream<bool> isFetching$;
  final Function() updateUser;
  final BehaviorSubject<User> user$;

  final Function(String) emailChanged;
  final Function(String) firstNameChanged;
  final Function(String) lastNameChanged;

  final Stream<String?> emailError$;
  final Stream<String?> firstNameError$;
  final Stream<String?> lastNameError$;

  final Stream<UpdateUserMessage> message$;

  UpdateUserController._({
    required this.isFetching$,
    required this.updateUser,
    required this.user$,
    required this.emailChanged,
    required this.lastNameChanged,
    required this.firstNameChanged,
    required this.emailError$,
    required this.firstNameError$,
    required this.lastNameError$,
    required this.message$,
  });

  factory UpdateUserController(User user, HomeController homeController) {
    if (kDebugMode) {
      print('UpdateUserController init');
    }

    final UserApi userApi = UserApi();

    final isFetchingController = BehaviorSubject<bool>.seeded(false);

    final updateUserController = PublishSubject<void>();
    final userController = BehaviorSubject<User>();
    final emailController = BehaviorSubject<String>.seeded(user.email!);
    final firstNameController = BehaviorSubject<String>.seeded(user.firstName!);
    final lastNameController = BehaviorSubject<String>.seeded(user.lastName!);

    final isValidSubmit$ = Rx.combineLatest4(
      emailController.stream.map(Validator.isValidEmail),
      lastNameController.stream.map(Validator.isValidPhonenumber),
      isFetchingController.stream,
      firstNameController.stream.map(Validator.isValidUserName),
      (bool isValidEmail, bool isValidPhonenumber, bool isLoading, bool isValidName) => isValidEmail && isValidPhonenumber && !isLoading && isValidName,
    ).shareValueSeeded(false);

    final updateUser$ = Rx.combineLatest3(
      emailController.stream,
      firstNameController.stream,
      lastNameController.stream,
      (String email, String firstName, String lastName) => UpdateUser(email, firstName, lastName),
    );

    final submit$ = updateUserController.stream.withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid).share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(
            updateUser$,
            (_, UpdateUser user) => user,
          )
          .exhaustMap(
            (updateUser) => userApi
                .update(user.id!, {
                  "email": updateUser.email,
                  "firstName": updateUser.firstName,
                  "lastName": updateUser.lastName,
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
                .map((event) => _responseToMessage(event, updateUser.email)),
          ),
      submit$.where((isValid) => !isValid).map(
            (_) => const UpdateUserInvalidInformationMessage(),
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

    final lastNameError$ = lastNameController.stream
        .map((phoneNumber) {
          if (Validator.isValidPhonenumber(phoneNumber)) return null;
          return 'Phonenumber must be at least 6 characters';
        })
        .distinct()
        .share();

    final firstNameError$ = firstNameController.stream
        .map((name) {
          if (Validator.isValidUserName(name)) return null;
          return 'Name must be at least 3 characters';
        })
        .distinct()
        .share();

    return UpdateUserController._(
      isFetching$: isFetchingController,
      updateUser: () => updateUserController.add(null),
      firstNameChanged: (value) => firstNameController.add(value.trim()),
      emailChanged: (value) => emailController.add(value.trim()),
      lastNameChanged: (value) => lastNameController.add(value.trim()),
      user$: userController,
      emailError$: emailError$,
      firstNameError$: firstNameError$,
      lastNameError$: lastNameError$,
      message$: message$,
    );
  }

  dispose() {
    isFetching$.drain();
    user$.drain();
    user$.close();

    emailError$.drain();
    firstNameError$.drain();
    lastNameError$.drain();

    message$.drain();

    if (kDebugMode) {
      print('UpdateUserController disposed');
    }
  }

  static UpdateUserMessage? _responseToMessage(Either<AppError, Response<BaseResponse>> result, String email) {
    return result.fold(
      ifRight: (_) => UpdateUserSuccessMessage(email),
      ifLeft: (appError) => UpdateUserErrorMessage(appError.message!, appError.error!),
    );
  }
}
