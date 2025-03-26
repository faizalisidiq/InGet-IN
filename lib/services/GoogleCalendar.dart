import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleCalendarService {
  static const _scopes = [calendar.CalendarApi.calendarScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
    clientId:
        '716402388400-ov7dc9kg4ha60igl02cb8egs1ju841do.apps.googleusercontent.com', // Tambahkan Client ID di sini
  );

  Future<void> signInAndGetEvents() async {
    try {
      // Tambahkan print untuk debugging
      print('Attempting to sign in...');

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('Successfully signed in: ${account.email}');

        final GoogleSignInAuthentication auth = await account.authentication;
        print('Got authentication token');

        // Lanjutkan dengan mengambil events
        final calendarApi = await _getCalendarApi(auth);
        final events = await calendarApi.events.list('primary');

        print('Events found: ${events.items?.length}');
        events.items?.forEach((event) {
          print('Event: ${event.summary}');
        });
      } else {
        print('Sign in cancelled by user');
      }
    } catch (error) {
      print('Error in signInAndGetEvents: $error');
      // Tambahkan cara menangani error yang lebih baik
      rethrow; // Untuk debugging
    }
  }

  Future<calendar.CalendarApi> _getCalendarApi(
    GoogleSignInAuthentication auth,
  ) async {
    final credentials = AccessCredentials(
      AccessToken(
        'Bearer',
        auth.accessToken!,
        DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
      null,
      _scopes,
    );

    final client = await clientViaUserConsent(
      ClientId('716402388400-ov7dc9kg4ha60igl02cb8egs1ju841do.apps.googleusercontent.com', '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'),
      _scopes,
      (url) {
        print('Please go to the following URL and grant access:');
        print('  => $url');
      },
    );

    return calendar.CalendarApi(client);
  }
}