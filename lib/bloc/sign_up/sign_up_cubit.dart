import 'package:bloc/bloc.dart';
import 'package:agriconnect/bloc/authentication/authentication.dart';
import 'package:agriconnect/bloc/sign_up/sign_up_state.dart';
import 'package:agriconnect/data/authentication/repositories/authentication_repository.dart';
import 'package:formz/formz.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;
  void nameChanged(String value) {
    final name = Name.dirty(value);
    final isValid = Formz.validate([
      name,
      state.email,
      state.password,
      state.confirmedPassword,
    ]);

    final status = isValid ? FormzStatus.valid : FormzStatus.invalid;

    emit(state.copyWith(
      name: name,
      status: status,
    ));
  }

  // void nameChanged(String value) {
  //   final name = Name.dirty(value);
  //   emit(state.copyWith(
  //     name: name,
  //     status: Formz.validate([
  //       name,
  //       state.email,
  //       state.password,
  //       state.confirmedPassword,
  //     ]),
  //   ));
  // }
  void emailChanged(String value) {
    final email = Email.dirty(value);

    final isValid = Formz.validate([
      state.name,
      email,
      state.password,
      state.confirmedPassword,
    ]);
    final status = isValid ? FormzStatus.valid : FormzStatus.invalid;
    emit(
      state.copyWith(
        email: email,
        status: status,
      ),
    );
  }
  // void emailChanged(String value) {
  //   final email = Email.dirty(value);
  //   emit(state.copyWith(
  //     email: email,
  //     status: Formz.validate([
  //       state.name,
  //       email,
  //       state.password,
  //       state.confirmedPassword,
  //     ]),
  //   ));
  // }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );

    final isValid = Formz.validate([
      state.name,
      state.email,
      password,
      confirmedPassword,
    ]);
    final status = isValid ? FormzStatus.valid : FormzStatus.invalid;
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: status,
      ),
    );
  }
  // void passwordChanged(String value) {
  //   final password = Password.dirty(value);
  //   final confirmedPassword = ConfirmedPassword.dirty(
  //     password: password.value,
  //     value: state.confirmedPassword.value,
  //   );
  //   emit(state.copyWith(
  //     password: password,
  //     confirmedPassword: confirmedPassword,
  //     status: Formz.validate([
  //       state.name,
  //       state.email,
  //       password,
  //       state.confirmedPassword,
  //     ]),
  //   ));
  // }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );

    final isValid = Formz.validate([
      state.name,
      state.email,
      state.password,
      confirmedPassword,
    ]);
    final status = isValid ? FormzStatus.valid : FormzStatus.invalid;
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: status,
      ),
    );
  }
  // void confirmedPasswordChanged(String value) {
  //   final confirmedPassword = ConfirmedPassword.dirty(
  //     password: state.password.value,
  //     value: value,
  //   );
  //   emit(state.copyWith(
  //     confirmedPassword: confirmedPassword,
  //     status: Formz.validate([
  //       state.name,
  //       state.email,
  //       state.password,
  //       confirmedPassword,
  //     ]),
  //   ));
  // }
  //
  // Future<void> signUpFormSubmitted() async {
  //   if (!(state.status == FormzStatus.isValidated))
  //     return; // Use FormzStatus.valid to access the static getter
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     await _authenticationRepository.signUp(
  //       name: state.name.value,
  //       email: state.email.value,
  //       password: state.password.value,
  //     );
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } on Exception {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }

  Future<void> signUpFormSubmitted() async {
    if (state.status != FormzStatus.valid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        name: state.name.value,
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
