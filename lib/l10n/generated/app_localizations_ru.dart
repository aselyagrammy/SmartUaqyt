// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SmartUaqyt';

  @override
  String get home => 'Главная';

  @override
  String get about => 'О приложении';

  @override
  String get interactivePageTitle => 'Весёлая страница';

  @override
  String get goToInteractivePage => 'Перейти на весёлую страницу';

  @override
  String get greeting => 'Добро пожаловать в СмартУақыт!';

  @override
  String get longPressedMessage => 'Вы долго нажали! 👆';

  @override
  String get hidden => 'Скрыто 👀';

  @override
  String get recentTimings => 'Последние замеры';

  @override
  String get session => 'Сеанс';

  @override
  String get timeLabel => 'Время';

  @override
  String get settingsPageTitle => 'Настройки';

  @override
  String get themeLabel => 'Тема';

  @override
  String get languageLabel => 'Язык';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get systemTheme => 'Системная';

  @override
  String get appDescriptionTitle => 'Описание приложения';

  @override
  String get appDescription =>
      'Simple Stopwatch — это лёгкое и простое в использовании приложение для измерения времени, позволяющее пользователям точно отслеживать время. Благодаря интуитивному интерфейсу пользователь может запускать, останавливать и сбрасывать секундомер одним нажатием. Идеально подходит для тренировок, учебы или любых действий, где важен контроль времени.';

  @override
  String get creditsTitle => 'Кредиты';

  @override
  String get credits =>
      'Разработано Askar, Alimzhan, Aselya в рамках курса «Кросс-платформенная разработка» в Astana IT University.\nНаставник (преподаватель): доцент Абзал Кызырканов';

  @override
  String get guestNotice =>
      'Вы используете гостевой режим. Некоторые функции могут быть недоступны.';

  @override
  String get guestNoticeDescription =>
      'Уведомление, показываемое, когда пользователь в гостевом режиме';
}
