import 'package:agriconnect/app_theme.dart';
import 'package:flutter/material.dart';

const _avatarSize = 48.0;

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.photo}) : super(key: key);

  final String? photo;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppTheme.white,
      foregroundColor: AppTheme.darkerText,
      radius: _avatarSize,
      backgroundImage: photo != null ? NetworkImage(photo!) : null,
      child: photo == null
          ? const Icon(Icons.person_outline, size: _avatarSize)
          : null,
    );
  }
}
