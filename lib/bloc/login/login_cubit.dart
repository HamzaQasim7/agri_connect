import 'package:agriconnect/bloc/authentication/authentication.dart';
import 'package:agriconnect/data/authentication/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import '../sign_up/sign_up_state.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;
  void emailChanged(String value) {
    final email = Email.dirty(value);

    final isValid = Formz.validate([
      email,
      state.password,
    ]);

    emit(
      state.copyWith(
        email: email,
        status: isValid ? FormzStatus.pure : FormzStatus.isValidated,
      ),
    );
  }

  // void emailChanged(String value) {
  //   final email = Email.dirty(value);
  //   emit(state.copyWith(
  //     email: email,
  //     status: Formz.validate([email, state.password]),
  //   ));
  // }
  void passwordChanged(String value) {
    final password = Password.dirty(value);

    final isValid = Formz.validate([
      state.email,
      password,
    ]);

    emit(
      state.copyWith(
        password: password,
        status: isValid ? FormzStatus.pure : FormzStatus.isValidated,
      ),
    );
  }
  // void passwordChanged(String value) {
  //   final password = Password.dirty(value);
  //   emit(state.copyWith(
  //     password: password,
  //     status: Formz.validate([state.email, password]),
  //   ));
  // }

  Future<void> logInWithCredentials() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> logInWithGoogle(BuildContext context) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithGoogle(context);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } on NoSuchMethodError {
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
}
