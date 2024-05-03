import 'package:equatable/equatable.dart';

import '../authentication/models/confirmed_password.dart';
import '../authentication/models/email.dart';
import '../authentication/models/name.dart';
import '../authentication/models/password.dart';

enum ConfirmPasswordValidationError { invalid }

enum FormzStatus {
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
  pure,
  isValidated,
  valid,
  invalid
}

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Name name;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;

  @override
  List<Object> get props => [name, email, password, confirmedPassword, status];

  SignUpState copyWith({
    Name? name,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzStatus? status,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }
}
