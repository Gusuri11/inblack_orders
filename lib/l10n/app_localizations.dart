import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'InBlack Orders'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @backToList.
  ///
  /// In en, this message translates to:
  /// **'Back to orders'**
  String get backToList;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect. Check your internet connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment.'**
  String get errorRateLimited;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server is temporarily unavailable. Please try again.'**
  String get errorServer;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to track your orders'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get usernameRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginRetryIn.
  ///
  /// In en, this message translates to:
  /// **'Try again in {seconds} s'**
  String loginRetryIn(int seconds);

  /// No description provided for @loginInvalid.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password'**
  String get loginInvalid;

  /// No description provided for @loginTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please wait {seconds} seconds.'**
  String loginTooMany(int seconds);

  /// No description provided for @sessionRevoked.
  ///
  /// In en, this message translates to:
  /// **'For your security, your session was ended. Please sign in again.'**
  String get sessionRevoked;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @sessionResume.
  ///
  /// In en, this message translates to:
  /// **'{message} We\'ll take you back to where you were.'**
  String sessionResume(String message);

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get statusPending;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get statusRefunded;

  /// No description provided for @statusSemantics.
  ///
  /// In en, this message translates to:
  /// **'Status: {label}'**
  String statusSemantics(String label);

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @refreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh: {reason}'**
  String refreshFailed(String reason);

  /// No description provided for @newItems.
  ///
  /// In en, this message translates to:
  /// **'{count} new orders'**
  String newItems(int count);

  /// No description provided for @loadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Loading orders…'**
  String get loadingOrders;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search order no., Player ID, product'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @offlineUpdated.
  ///
  /// In en, this message translates to:
  /// **'Offline · last updated {time}'**
  String offlineUpdated(String time);

  /// No description provided for @localResults.
  ///
  /// In en, this message translates to:
  /// **'Showing results from data on this device (offline); some orders may be missing'**
  String get localResults;

  /// No description provided for @emptySearch.
  ///
  /// In en, this message translates to:
  /// **'No orders match “{query}”'**
  String emptySearch(String query);

  /// No description provided for @emptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No orders with the selected status'**
  String get emptyFilter;

  /// No description provided for @emptyAll.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get emptyAll;

  /// No description provided for @loadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more: {reason}'**
  String loadMoreFailed(String reason);

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more orders'**
  String get loadingMore;

  /// No description provided for @endOfList.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end'**
  String get endOfList;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @noProduct.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noProduct;

  /// No description provided for @moreItems.
  ///
  /// In en, this message translates to:
  /// **' (+{count} items)'**
  String moreItems(int count);

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending send'**
  String get pending;

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Not sent'**
  String get sendFailed;

  /// No description provided for @sendState.
  ///
  /// In en, this message translates to:
  /// **'Send status: {label}'**
  String sendState(String label);

  /// No description provided for @copiedOrderId.
  ///
  /// In en, this message translates to:
  /// **'Copied order number {id}'**
  String copiedOrderId(String id);

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this order'**
  String get loadFailed;

  /// No description provided for @copyOrderId.
  ///
  /// In en, this message translates to:
  /// **'Copy order number'**
  String get copyOrderId;

  /// No description provided for @shareOrder.
  ///
  /// In en, this message translates to:
  /// **'Share order link'**
  String get shareOrder;

  /// No description provided for @totalSemantics.
  ///
  /// In en, this message translates to:
  /// **'Total {amount}'**
  String totalSemantics(String amount);

  /// No description provided for @orderedAt.
  ///
  /// In en, this message translates to:
  /// **'Ordered'**
  String get orderedAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get updatedAt;

  /// No description provided for @playerId.
  ///
  /// In en, this message translates to:
  /// **'Player ID'**
  String get playerId;

  /// No description provided for @channel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get channel;

  /// No description provided for @itemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String itemsTitle(int count);

  /// No description provided for @noItemsInOrder.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItemsInOrder;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Status history'**
  String get historyTitle;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes ({count})'**
  String notesTitle(int count);

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get noNotes;

  /// No description provided for @attachmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Attachments ({count})'**
  String attachmentsTitle(int count);

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments'**
  String get noAttachments;

  /// No description provided for @deletedBanner.
  ///
  /// In en, this message translates to:
  /// **'This order has been removed. What you see is the last copy before it was removed.'**
  String get deletedBanner;

  /// No description provided for @actorSystem.
  ///
  /// In en, this message translates to:
  /// **'system'**
  String get actorSystem;

  /// No description provided for @actorCustomer.
  ///
  /// In en, this message translates to:
  /// **'customer'**
  String get actorCustomer;

  /// No description provided for @actorAdmin.
  ///
  /// In en, this message translates to:
  /// **'admin'**
  String get actorAdmin;

  /// No description provided for @actorSupport.
  ///
  /// In en, this message translates to:
  /// **'support'**
  String get actorSupport;

  /// No description provided for @byActor.
  ///
  /// In en, this message translates to:
  /// **'by {actor}'**
  String byActor(String actor);

  /// No description provided for @noteFromSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get noteFromSupport;

  /// No description provided for @noteFromYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get noteFromYou;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find order {id}. It may have been removed or the link is wrong.'**
  String notFoundBody(String id);

  /// No description provided for @outboxNetwork.
  ///
  /// In en, this message translates to:
  /// **'Not sent because the server couldn\'t be reached'**
  String get outboxNetwork;

  /// No description provided for @outboxNotCancellable.
  ///
  /// In en, this message translates to:
  /// **'This order can no longer be cancelled because its status changed'**
  String get outboxNotCancellable;

  /// No description provided for @outboxNotFound.
  ///
  /// In en, this message translates to:
  /// **'This order no longer exists'**
  String get outboxNotFound;

  /// No description provided for @outboxValidation.
  ///
  /// In en, this message translates to:
  /// **'The information is invalid. Please fix it and try again.'**
  String get outboxValidation;

  /// No description provided for @outboxConflict.
  ///
  /// In en, this message translates to:
  /// **'The order changed while this was waiting to be sent'**
  String get outboxConflict;

  /// No description provided for @outboxDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This request duplicates an earlier one'**
  String get outboxDuplicate;

  /// No description provided for @outboxUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you to sign in again'**
  String get outboxUnauthorized;

  /// No description provided for @outboxQueued.
  ///
  /// In en, this message translates to:
  /// **'Pending send'**
  String get outboxQueued;

  /// No description provided for @outboxFailedCode.
  ///
  /// In en, this message translates to:
  /// **'Not sent ({code})'**
  String outboxFailedCode(String code);

  /// No description provided for @kindCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get kindCancel;

  /// No description provided for @kindNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get kindNote;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please give a reason'**
  String get reasonRequired;

  /// No description provided for @reasonTooLong.
  ///
  /// In en, this message translates to:
  /// **'The reason can be at most {max} characters'**
  String reasonTooLong(int max);

  /// No description provided for @cancelDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get cancelDialogTitle;

  /// No description provided for @cancelDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Order {id} will be cancelled. This can\'t be undone.'**
  String cancelDialogBody(String id);

  /// No description provided for @cancelReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancelling'**
  String get cancelReasonLabel;

  /// No description provided for @keepOrder.
  ///
  /// In en, this message translates to:
  /// **'Keep order'**
  String get keepOrder;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get confirmCancel;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @cancelQueued.
  ///
  /// In en, this message translates to:
  /// **'Cancellation saved. It will be sent automatically when you\'re online.'**
  String get cancelQueued;

  /// No description provided for @pendingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation pending. It will be sent automatically when you\'re online.'**
  String get pendingCancel;

  /// No description provided for @pendingCancelRetrying.
  ///
  /// In en, this message translates to:
  /// **'Cancellation pending ({reason}). Retrying automatically.'**
  String pendingCancelRetrying(String reason);

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'{kind} failed: {reason}'**
  String actionFailed(String kind, String reason);

  /// No description provided for @conflictAsk.
  ///
  /// In en, this message translates to:
  /// **'The order changed while waiting. It is now: {status}. Cancel it again?'**
  String conflictAsk(String status);

  /// No description provided for @conflictFinal.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t cancel because the order is now {status}'**
  String conflictFinal(String status);

  /// No description provided for @cancelAgain.
  ///
  /// In en, this message translates to:
  /// **'Cancel again'**
  String get cancelAgain;

  /// No description provided for @dontCancel.
  ///
  /// In en, this message translates to:
  /// **'Don\'t cancel'**
  String get dontCancel;

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get acknowledge;

  /// No description provided for @noteRequired.
  ///
  /// In en, this message translates to:
  /// **'Please type a message'**
  String get noteRequired;

  /// No description provided for @noteTooLong.
  ///
  /// In en, this message translates to:
  /// **'At most {max} characters'**
  String noteTooLong(int max);

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Write a note to our team'**
  String get noteLabel;

  /// No description provided for @sendNote.
  ///
  /// In en, this message translates to:
  /// **'Send note'**
  String get sendNote;

  /// No description provided for @outboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending actions'**
  String get outboxTitle;

  /// No description provided for @sendNow.
  ///
  /// In en, this message translates to:
  /// **'Send now'**
  String get sendNow;

  /// No description provided for @outboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting to be sent'**
  String get outboxEmpty;

  /// No description provided for @stateSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get stateSending;

  /// No description provided for @stateFailed.
  ///
  /// In en, this message translates to:
  /// **'Not sent'**
  String get stateFailed;

  /// No description provided for @stateConflict.
  ///
  /// In en, this message translates to:
  /// **'Order changed, decision needed'**
  String get stateConflict;

  /// No description provided for @stateQueued.
  ///
  /// In en, this message translates to:
  /// **'Pending send'**
  String get stateQueued;

  /// No description provided for @stateRequeued.
  ///
  /// In en, this message translates to:
  /// **'Will retry'**
  String get stateRequeued;

  /// No description provided for @reasonPrefix.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String reasonPrefix(String reason);

  /// No description provided for @latestServerStatus.
  ///
  /// In en, this message translates to:
  /// **'Latest status on server: {status}'**
  String latestServerStatus(String status);

  /// No description provided for @createdAttempts.
  ///
  /// In en, this message translates to:
  /// **'Created {time} · {attempts} attempts'**
  String createdAttempts(String time, int attempts);

  /// No description provided for @outboxFailedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} actions not sent'**
  String outboxFailedCount(int count);

  /// No description provided for @outboxPendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} actions pending'**
  String outboxPendingCount(int count);

  /// No description provided for @connLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get connLive;

  /// No description provided for @connReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get connReconnecting;

  /// No description provided for @connOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get connOffline;

  /// No description provided for @connSemantics.
  ///
  /// In en, this message translates to:
  /// **'Connection: {label}'**
  String connSemantics(String label);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsOpen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsOpen;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get languageThai;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Order notifications'**
  String get notifications;

  /// No description provided for @notificationsHint.
  ///
  /// In en, this message translates to:
  /// **'Notify me when an order is completed, cancelled or refunded'**
  String get notificationsHint;

  /// No description provided for @notificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for this app. Enable them in system settings.'**
  String get notificationsDenied;

  /// No description provided for @openSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSystemSettings;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @appLockHint.
  ///
  /// In en, this message translates to:
  /// **'Require Face ID / fingerprint / device passcode after 30 s in the background'**
  String get appLockHint;

  /// No description provided for @appLockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This device has no biometrics or passcode set up'**
  String get appLockUnavailable;

  /// No description provided for @appLockReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you to open InBlack Orders'**
  String get appLockReason;

  /// No description provided for @appLockEnableReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to turn on app lock'**
  String get appLockEnableReason;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'InBlack Orders is locked'**
  String get locked;

  /// No description provided for @clearImageCache.
  ///
  /// In en, this message translates to:
  /// **'Clear image cache'**
  String get clearImageCache;

  /// No description provided for @imageCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Image cache cleared'**
  String get imageCacheCleared;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({build})'**
  String version(String version, String build);

  /// No description provided for @baseUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL (debug)'**
  String get baseUrl;

  /// No description provided for @baseUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Restart the app after changing it'**
  String get baseUrlHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out? All data stored on this device, including unsent actions, will be deleted.'**
  String get logoutConfirm;

  /// No description provided for @enableNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified about your orders?'**
  String get enableNotificationsTitle;

  /// No description provided for @enableNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when an order is completed, cancelled or refunded.'**
  String get enableNotificationsBody;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get enable;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @notifCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order completed'**
  String get notifCompletedTitle;

  /// No description provided for @notifCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get notifCancelledTitle;

  /// No description provided for @notifRefundedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order refunded'**
  String get notifRefundedTitle;

  /// No description provided for @notifBody.
  ///
  /// In en, this message translates to:
  /// **'{id} · {product}'**
  String notifBody(String id, String product);

  /// No description provided for @notifSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} orders updated'**
  String notifSummaryTitle(int count);

  /// No description provided for @notifChannel.
  ///
  /// In en, this message translates to:
  /// **'Order updates'**
  String get notifChannel;

  /// No description provided for @widgetOpenOrders.
  ///
  /// In en, this message translates to:
  /// **'Open orders'**
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
  // Lookup logic when only language code is specified.
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
