import 'package:agriconnect/app_theme.dart';
import 'package:agriconnect/bloc/authentication/authentication.dart';
import 'package:agriconnect/ui/login/login_page.dart';
import 'package:agriconnect/ui/profile/avatar.dart';
import 'package:agriconnect/ui/profile/user_info_field.dart';
import 'package:agriconnect/ui/widgets/tab_page.dart';
import 'package:agriconnect/utils/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends TabPage {
  const UserProfilePage({Key? key, required String pageTitle})
      : super(key: key, pageTitle: pageTitle);

  @override
  _UserProfilePagePageState createState() => _UserProfilePagePageState();
}

class _UserProfilePagePageState extends TabPageState<UserProfilePage> {
  @override
  void initState() {
    tabListView.add(Avatar());
    tabListView.add(UserInfoField(
      name: 'Name',
      icon: Icons.account_circle,
      field: 'displayName',
    ));
    tabListView.add(UserInfoField(
      name: 'Email',
      icon: Icons.email,
      field: 'email',
    ));
    tabListView.add(_LogOutButton());
    super.initState();
  }
}

class _LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: SizedBox(
          height: 45,
          width: 200,
          child: ElevatedButton(
            child: const Text(
              'LOG OUT',
              style: AppTheme.bodyText1,
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: const Color(0xFFFFD600),
            ),
            onPressed: () async {
              LoginPage.route();
              await context.read<MessageHandler>().deleteToken().then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User log out successfully')));
              });
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            },
          ),
        ),
      ),
    );
  }
}
