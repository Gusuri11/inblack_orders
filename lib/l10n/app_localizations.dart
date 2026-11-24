import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';


abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  String get appTitle;

  String get retry;

  String get backToList;

  String get discard;

  String get unknown;

  String get errorTimeout;

  String get errorNetwork;

  String get errorRateLimited;

  String get errorServer;

  String get errorSessionExpired;

  String get errorGeneric;

  String get loginSubtitle;

  String get usernameLabel;

  String get usernameRequired;

  String get passwordLabel;

  String get passwordRequired;

  String get showPassword;

  String get hidePassword;

  String get loginButton;

  String loginRetryIn(int seconds);

  String get loginInvalid;

  String loginTooMany(int seconds);

  String get sessionRevoked;

  String get sessionExpired;

  String sessionResume(String message);

  String get statusPending;

  String get statusPaid;

  String get statusInProgress;

  String get statusCompleted;

  String get statusCancelled;

  String get statusRefunded;

  String statusSemantics(String label);

  String get ordersTitle;

  String refreshFailed(String reason);

  String newItems(int count);

  String get loadingOrders;

  String get searchHint;

  String get clearSearch;

  String get offline;

  String offlineUpdated(String time);

  String get localResults;

  String emptySearch(String query);

  String get emptyFilter;

  String get emptyAll;

  String loadMoreFailed(String reason);

  String get loadingMore;

  String get endOfList;

  String get filterAll;

  String get noProduct;

  String moreItems(int count);

  String get pending;

  String get sendFailed;

  String sendState(String label);

  String copiedOrderId(String id);

  String get loadFailed;

  String get copyOrderId;

  String get shareOrder;

  String totalSemantics(String amount);

  String get orderedAt;

  String get updatedAt;

  String get playerId;

  String get channel;

  String itemsTitle(int count);

  String get noItemsInOrder;

  String get historyTitle;

  String get noHistory;

  String notesTitle(int count);

  String get noNotes;

  String attachmentsTitle(int count);

  String get noAttachments;

  String get deletedBanner;

  String get actorSystem;

  String get actorCustomer;

  String get actorAdmin;

  String get actorSupport;

  String byActor(String actor);

  String get noteFromSupport;

  String get noteFromYou;

  String get notFoundTitle;

  String notFoundBody(String id);

  String get outboxNetwork;

  String get outboxNotCancellable;

  String get outboxNotFound;

  String get outboxValidation;

  String get outboxConflict;

  String get outboxDuplicate;

  String get outboxUnauthorized;

  String get outboxQueued;

  String outboxFailedCode(String code);

  String get kindCancel;

  String get kindNote;

  String get reasonRequired;

  String reasonTooLong(int max);

  String get cancelDialogTitle;

  String cancelDialogBody(String id);

  String get cancelReasonLabel;

  String get keepOrder;

  String get confirmCancel;

  String get cancelOrder;

  String get cancelQueued;

  String get pendingCancel;

  String pendingCancelRetrying(String reason);

  String actionFailed(String kind, String reason);

  String conflictAsk(String status);

  String conflictFinal(String status);

  String get cancelAgain;

  String get dontCancel;

  String get acknowledge;

  String get noteRequired;

  String noteTooLong(int max);

  String get noteLabel;

  String get sendNote;

  String get outboxTitle;

  String get sendNow;

  String get outboxEmpty;

  String get stateSending;

  String get stateFailed;

  String get stateConflict;

  String get stateQueued;

  String get stateRequeued;

  String reasonPrefix(String reason);

  String latestServerStatus(String status);

  String createdAttempts(String time, int attempts);

  String outboxFailedCount(int count);

  String outboxPendingCount(int count);

  String get connLive;

  String get connReconnecting;

  String get connOffline;

  String connSemantics(String label);

  String get settingsTitle;

  String get settingsOpen;

  String get language;

  String get languageThai;

  String get languageEnglish;

  String get theme;

  String get themeSystem;

  String get themeLight;

  String get themeDark;

  String get notifications;

  String get notificationsHint;

  String get notificationsDenied;

  String get openSystemSettings;

  String get appLock;

  String get appLockHint;

  String get appLockUnavailable;

  String get appLockReason;

  String get appLockEnableReason;

  String get unlock;

  String get locked;

  String get clearImageCache;

  String get imageCacheCleared;

  String version(String version, String build);

  String get baseUrl;

  String get baseUrlHint;

  String get save;

  String get logout;

  String get logoutConfirm;

  String get enableNotificationsTitle;

  String get enableNotificationsBody;

  String get enable;

  String get notNow;

  String get notifCompletedTitle;

  String get notifCancelledTitle;

  String get notifRefundedTitle;

  String notifBody(String id, String product);

  String notifSummaryTitle(int count);

  String get notifChannel;

  String get widgetOpenOrders;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
