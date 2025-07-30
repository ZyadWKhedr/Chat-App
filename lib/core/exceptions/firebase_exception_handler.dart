import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExceptionHandler {
  /// Returns localized message or null if not handled.
  static String? getMessage(BuildContext context, FirebaseAuthException e) {
    final loc = AppLocalizations.of(context)!;
    final code = e.code.replaceAll('.', '');

    switch (code) {
      case 'invalidemail':
        return loc.authInvalidEmail;
      case 'usernotfound':
        return loc.authUserNotFound;
      case 'wrongpassword':
        return loc.authWrongPassword;
      case 'emailalreadyinuse':
        return loc.authEmailAlreadyInUse;
      case 'weakpassword':
        return loc.authWeakPassword;
      case 'networkrequestfailed':
        return loc.authNetworkRequestFailed;
      default:
        return null; // unknown error, let caller handle
    }
  }
}
