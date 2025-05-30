// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SmartUaqyt';

  @override
  String get home => 'Home';

  @override
  String get about => 'About';

  @override
  String get interactivePageTitle => 'Fun Page';

  @override
  String get goToInteractivePage => 'Go to Fun Page';

  @override
  String get greeting => 'Welcome to SmartUaqyt!';

  @override
  String get longPressedMessage => 'You\'ve long pressed! 👆';

  @override
  String get hidden => 'Hidden 👀';

  @override
  String get recentTimings => 'Recent Timings';

  @override
  String get session => 'Session';

  @override
  String get timeLabel => 'Time';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get themeLabel => 'Theme';

  @override
  String get languageLabel => 'Language';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get appDescriptionTitle => 'App Description';

  @override
  String get appDescription =>
      'Simple Stopwatch is a lightweight and easy-to-use timing app that allows users to measure time precisely. With its intuitive interface, users can start, stop, and reset the stopwatch with just one tap. Ideal for timing workouts, studying, or any activity where tracking time matters.';

  @override
  String get creditsTitle => 'Credits';

  @override
  String get credits =>
      'Developed by Askar, Alimzhan, Aselya in the scope of the course “Cross-platform Development” at Astana IT University.\nMentor (Teacher): Assistant Professor Abzal Kyzyrkanov';

  @override
  String get guestNotice =>
      'You are using guest mode. Some features may be unavailable.';

  @override
  String get guestNoticeDescription => 'Notice shown when the user is a guest';
}
