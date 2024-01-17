import 'package:client/api/base_response.dart';
import 'package:client/api/healthcheck.dart';
import 'package:client/api/user_api.dart';
import 'package:client/model/app_error.dart';
import 'package:client/model/healthcheck.dart';
import 'package:client/model/user.dart';
import 'package:client/model/user_page.dart';
import 'package:client/util/mappers.dart';
import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'home_page_state.dart';

class HomeController {
  Stream<bool> isFetchingUsers$;
  Stream<bool> isCheckingApi$;
  final Stream<HomeMessage> message$;
  final Stream<User> deletedUser$;
  final Stream<User> updatedUser$;

  final Function() checkApiStatus;
  final Function() fetchUsers;
  final Function(User) deleteUser;
  final Function(User) updateUser;
  final BehaviorSubject<Healthcheck> healthcheck$;

  final BehaviorSubject<UserPage> userPage$;
  final BehaviorSubject<List<User>> users$;

  HomeController._({
    required this.isCheckingApi$,
    required this.isFetchingUsers$,
    required this.healthcheck$,
    required this.checkApiStatus,
    required this.message$,
    required this.userPage$,
    required this.users$,
    required this.fetchUsers,
    required this.deleteUser,
    required this.deletedUser$,
    required this.updatedUser$,
    required this.updateUser,
  });

  factory HomeController() {
    if (kDebugMode) {
      print('HomeController init');
    }

    final HealthcheckApi healthcheckApi = HealthcheckApi();
    final UserApi userApi = UserApi();

    final isCheckingController = BehaviorSubject<bool>.seeded(false);
    final isFetchingUsersController = BehaviorSubject<bool>.seeded(false);
    final healthcheckController = BehaviorSubject<Healthcheck>();
    final userPageController = BehaviorSubject<UserPage>();
    final usersController = BehaviorSubject<List<User>>();
    final deletedUserController = BehaviorSubject<User>();
    final updatedUserController = BehaviorSubject<User>();

    final checkApiHealthController = PublishSubject<void>();
    final fetchUsersController = PublishSubject<void>();
    final deleteUserController = PublishSubject<User>();

    final checkApiMessage$ = checkApiHealthController
        .startWith(null)
        .throttle(
          (event) => TimerStream(
            true,
            const Duration(seconds: 1),
          ),
        )
        .exhaustMap(
          (_) => healthcheckApi.retrieve({}).asStream().toEitherStream(Mappers.errorToAppError).doOn(
                listen: () => isCheckingController.add(true),
                cancel: () => isCheckingController.add(false),
                data: (result) => result.findOrNull(
                  (value) {
                    healthcheckController.add(value.data!.healthcheck!);
                    return false;
                  },
                ),
              ),
        )
        .map((event) => _responseToMessage(event, ''));

    final page$ = userPageController.stream.map((e) => e.page).shareValueSeeded(0);

    final fetchUsersMessage$ = fetchUsersController
        .startWith(null)
        .throttle(
          (event) => TimerStream(
            true,
            const Duration(seconds: 1),
          ),
        )
        .withLatestFrom(page$, (_, page) => page != null ? page + 1 : 1)
        .exhaustMap(
          (page) => userApi
              .retrieve({
                "page": page,
                "limit": 10,
              })
              .asStream()
              .toEitherStream(Mappers.errorToAppError)
              .doOn(
                listen: () => isFetchingUsersController.add(true),
                cancel: () => isFetchingUsersController.add(false),
                data: (result) => result.findOrNull(
                  (value) {
                    userPageController.add(value.data!.userPage!);
                    usersController.add(value.data!.userPage!.docs);
                    return false;
                  },
                ),
              ),
        )
        .map((event) => _responseToMessage(event, ''));

    final deleteUserMessage$ = deleteUserController
        .throttle(
          (event) => TimerStream(
            true,
            const Duration(seconds: 1),
          ),
        )
        .exhaustMap(
          (user) => userApi.remove(user.id!).asStream().toEitherStream(Mappers.errorToAppError).doOn(
                listen: () => {},
                cancel: () => {},
                data: (result) => result.findOrNull(
                  (value) {
                    deletedUserController.add(value.data!.user!);
                    return false;
                  },
                ),
              ),
        )
        .map((event) => _responseToMessage(event, 'You succesfully deleted the user'));

    final message$ = Rx.merge([
      checkApiMessage$,
      fetchUsersMessage$,
      deleteUserMessage$,
    ]).whereNotNull();

    return HomeController._(
      isCheckingApi$: isCheckingController,
      isFetchingUsers$: isFetchingUsersController,
      healthcheck$: healthcheckController,
      userPage$: userPageController,
      checkApiStatus: () => checkApiHealthController.add(null),
      fetchUsers: () => fetchUsersController.add(null),
      deleteUser: (user) => deleteUserController.add(user),
      updateUser: (user) => updatedUserController.add(user),
      message$: message$,
      users$: usersController,
      deletedUser$: deletedUserController,
      updatedUser$: updatedUserController,
    );
  }

  dispose() {
    isCheckingApi$.drain();
    isFetchingUsers$.drain();

    if (kDebugMode) {
      print('HomeController disposed');
    }
  }

  static HomeMessage? _responseToMessage(Either<AppError, Response<BaseResponse>> result, String message) {
    return result.fold(
      ifRight: (_) => HomeSuccessMessage(message),
      ifLeft: (appError) => HomeErrorMessage(appError.message!, appError.error!),
    );
  }
}
