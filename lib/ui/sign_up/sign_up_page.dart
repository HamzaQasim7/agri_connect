import 'package:agriconnect/bloc/sign_up/sign_up_cubit.dart';
import 'package:agriconnect/data/authentication/repositories/authentication_repository.dart';
import 'package:agriconnect/ui/sign_up/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/bg_leave.jpg'))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider<SignUpCubit>(
            create: (_) =>
                SignUpCubit(context.read<AuthenticationRepository>()),
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}
