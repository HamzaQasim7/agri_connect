import 'dart:async';

import 'package:agriconnect/data/authentication/models/user.dart';
import 'package:agriconnect/data/authentication/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _appUserSubscription = _authenticationRepository.appUser.listen(
      (appUser) => add(AuthenticationUserChanged(appUser)),
    );
    // Register the event handler for AuthenticationUserChanged
    on<AuthenticationUserChanged>(
      (event, emit) => emit(_mapAuthenticationUserChangedToState(event)),
    );
    // Register the event handler for AuthenticationLogoutRequested
    on<AuthenticationLogoutRequested>(
      (event, emit) async {
        await _authenticationRepository.logOut();
      },
    );
  }

  late final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AppUser> _appUserSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      await Future.delayed(const Duration(seconds: 1));
      yield await _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
    // Add the event handler here
    on<AuthenticationUserChanged>(
        (event, emit) => emit(_mapAuthenticationUserChangedToState(event)));
  }

  @override
  Future<void> close() {
    _appUserSubscription.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) {
    return event.appUser != AppUser.empty
        ? AuthenticationState.authenticated(event.appUser)
        : const AuthenticationState.unauthenticated();
  }
}
