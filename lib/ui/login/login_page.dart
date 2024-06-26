import 'package:agriconnect/bloc/login/login_cubit.dart';
import 'package:agriconnect/data/authentication/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Colors.transparent, title: const Text('Login')),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/bg_leave.jpg'))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
