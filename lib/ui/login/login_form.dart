import 'package:agriconnect/app_theme.dart';
import 'package:agriconnect/bloc/login/login_cubit.dart';
import 'package:agriconnect/ui/extensions/keyboard_dismissable.dart';
import 'package:agriconnect/ui/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/sign_up/sign_up_state.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Failure')),
          );
        }
      },
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/agri_connect_logo.png',
                  height: 120,
                ),
              ),
              const SizedBox(height: 18.0),
              _EmailInput(),
              const SizedBox(height: 12.0),
              _PasswordInput(),
              const SizedBox(height: 12.0),
              _LoginButton(),
              const SizedBox(height: 24.0),
              _SignUpButton(),
              const SizedBox(height: 24.0),
              _GoogleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          width: 300,
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              helperText: '',
              // errorText: state.email.isValid ? null : 'Invalid email',
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          width: 300,
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: _obscureText,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_rounded),
                labelText: 'Password',
                helperText: '',
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

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == FormzStatus.submissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 45,
                width: 200,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  child: const Text('LOG IN', style: AppTheme.bodyText1),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color(0xFFFFD600),
                  ),
                  onPressed: () =>
                      context.read<LoginCubit>().logInWithCredentials(),
                ),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 200,
      child: ElevatedButton(
        key: const Key('loginForm_createAccount_flatButton'),
        child: const Text('CREATE ACCOUNT', style: AppTheme.bodyText1),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: const Color(0xFFFFD600),
        ),
        onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 200,
      child: TextButton(
        key: const Key('loginForm_googleLogin_raisedButton'),
        child: Image.asset(
          'assets/images/btn_google_signin.png',
          scale: 1.85,
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: AppTheme.white,
        ),
        // onPressed: () {
        //   GoogleSignInHelper go = GoogleSignInHelper();
        //   go.signInWithGoogle(context);
        // },
        onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      ),
    );
  }
}
