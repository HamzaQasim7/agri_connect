import 'package:farmassist/app_theme.dart';
import 'package:farmassist/bloc/sign_up/sign_up_cubit.dart';
import 'package:farmassist/ui/extensions/custom_snackbar.dart';
import 'package:farmassist/ui/extensions/keyboard_dismissable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/sign_up/sign_up_state.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          context.showCustomSnackBar('Sign Up Failure');
        } else if (state.status == FormzStatus.submissionInProgress) {
          context.showCustomSnackBar('Sign up in progress');
        } else if (state.status == FormzStatus.submissionSuccess) {
          context.showCustomSnackBar('Successfully sign up');
        } else {}
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _NameInput(),
              const SizedBox(height: 12.0),
              _EmailInput(),
              const SizedBox(height: 12.0),
              _PasswordInput(),
              const SizedBox(height: 12.0),
              _ConfirmPasswordInput(),
              const SizedBox(height: 12.0),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Container(
          width: 300,
          child: TextField(
            key: const Key('signUpForm_nameInput_textField'),
            onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_circle),
              labelText: 'Name',
              helperText: '',
              errorText: state.name.isNotValid == FormzStatus.invalid
                  ? 'Please enter your name'
                  : null,
            ),
            onTapOutside: (event) {
              context.dismissKeyboard();
            },
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          width: 300,
          child: TextField(
            key: const Key('signUpForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<SignUpCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              helperText: '',
              errorText: state.name.isNotValid == FormzStatus.invalid
                  ? 'Invalid email'
                  : null,
            ),
            onTapOutside: (event) {
              context.dismissKeyboard();
            },
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput({super.key});

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;
  void onToggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          width: 300,
          child: TextField(
            key: const Key('signUpForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<SignUpCubit>().passwordChanged(password),
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_rounded),
              labelText: 'Password',
              helperText: '',
              errorText: state.name.isNotValid == FormzStatus.invalid
                  ? null
                  : 'Password must contain at least 8 characters, including at least 1 letter and 1 number',
              suffixIcon: IconButton(
                  onPressed: () {
                    onToggleObscureText();
                  },
                  icon: _obscureText
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off)),
            ),
            onTapOutside: (event) {
              context.dismissKeyboard();
            },
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatefulWidget {
  @override
  State<_ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<_ConfirmPasswordInput> {
  bool _obscureText = true;
  void onToggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return Container(
          width: 300,
          child: TextField(
            key: const Key('signUpForm_confirmedPasswordInput_textField'),
            onChanged: (confirmPassword) => context
                .read<SignUpCubit>()
                .confirmedPasswordChanged(confirmPassword),
            obscureText: _obscureText,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_rounded),
                labelText: 'Confirm password',
                helperText: '',
                errorText: state.name.isNotValid == FormzStatus.invalid
                    ? 'Passwords do not match'
                    : null,
                suffixIcon: IconButton(
                    onPressed: () {
                      onToggleObscureText();
                    },
                    icon: _obscureText
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off))),
            onTapOutside: (event) {
              context.dismissKeyboard();
            },
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == FormzStatus.submissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 45,
                width: 200,
                child: ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  child: const Text(
                    'SIGN UP',
                    style: AppTheme.bodyText1,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color(0xFFFFD600),
                  ),
                  onPressed: state.status == FormzStatus.valid
                      ? () {
                          print('Sign up button tapped');
                          context
                              .read<SignUpCubit>()
                              .signUpFormSubmitted()
                              .onError((error, stackTrace) {
                            print('Error in the sign up button');
                          });
                        }
                      : null,
                ),
              );
      },
    );
  }
}

class _SgnUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionSuccess) {
          // Handle successful sign-up, e.g., show a SnackBar or navigate to a new screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign-up successful!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state.status == FormzStatus.submissionFailure) {
          // Handle sign-up failure, e.g., show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign-up failed. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            key: const Key('signUpForm_continue_raisedButton'),
            child: state.status == FormzStatus.submissionInProgress
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'SIGN UP',
                    style: AppTheme.bodyText1,
                  ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: const Color(0xFFFFD600),
            ),
            onPressed: state.status == FormzStatus.valid
                ? () {
                    context.read<SignUpCubit>().signUpFormSubmitted();
                  }
                : null,
          ),
        );
      },
    );
  }
}
