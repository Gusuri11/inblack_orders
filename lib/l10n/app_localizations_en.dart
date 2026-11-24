// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'InBlack Orders';

  @override
  String get retry => 'Retry';

  @override
  String get backToList => 'Back to orders';

  @override
  String get discard => 'Discard';

  @override
  String get unknown => 'Unknown';

  @override
  String get errorTimeout =>
      'The server took too long to respond. Please try again.';

  @override
  String get errorNetwork =>
      'Can\'t connect. Check your internet connection and try again.';

  @override
  String get errorRateLimited => 'Too many requests. Please wait a moment.';

  @override
  String get errorServer =>
      'The server is temporarily unavailable. Please try again.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get loginSubtitle => 'Sign in to track your orders';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameRequired => 'Please enter your username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get loginButton => 'Sign in';

  @override
  String loginRetryIn(int seconds) {
    return 'Try again in $seconds s';
  }

  @override
  String get loginInvalid => 'Incorrect username or password';

  @override
  String loginTooMany(int seconds) {
    return 'Too many failed attempts. Please wait $seconds seconds.';
  }

  @override
  String get sessionRevoked =>
      'For your security, your session was ended. Please sign in again.';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String sessionResume(String message) {
    return '$message We\'ll take you back to where you were.';
  }

  @override
  String get statusPending => 'Awaiting payment';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusRefunded => 'Refunded';

  @override
  String statusSemantics(String label) {
    return 'Status: $label';
  }

  @override
  String get ordersTitle => 'Orders';

  @override
  String refreshFailed(String reason) {
    return 'Couldn\'t refresh: $reason';
  }

  @override
  String newItems(int count) {
    return '$count new orders';
  }

  @override
  String get loadingOrders => 'Loading orders…';

  @override
  String get searchHint => 'Search order no., Player ID, product';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get offline => 'Offline';

  @override
  String offlineUpdated(String time) {
    return 'Offline · last updated $time';
  }

  @override
  String get localResults =>
      'Showing results from data on this device (offline); some orders may be missing';

  @override
  String emptySearch(String query) {
    return 'No orders match “$query”';
  }

  @override
  String get emptyFilter => 'No orders with the selected status';

  @override
  String get emptyAll => 'No orders yet';

  @override
  String loadMoreFailed(String reason) {
    return 'Couldn\'t load more: $reason';
  }

  @override
  String get loadingMore => 'Loading more orders';

  @override
  String get endOfList => 'You\'ve reached the end';

  @override
  String get filterAll => 'All';

  @override
  String get noProduct => 'No items';

  @override
  String moreItems(int count) {
    return ' (+$count items)';
  }

  @override
  String get pending => 'Pending send';

  @override
  String get sendFailed => 'Not sent';

  @override
  String sendState(String label) {
    return 'Send status: $label';
  }

  @override
  String copiedOrderId(String id) {
    return 'Copied order number $id';
  }

  @override
  String get loadFailed => 'Couldn\'t load this order';

  @override
  String get copyOrderId => 'Copy order number';

  @override
  String get shareOrder => 'Share order link';

  @override
  String totalSemantics(String amount) {
    return 'Total $amount';
  }

  @override
  String get orderedAt => 'Ordered';

  @override
  String get updatedAt => 'Last updated';

  @override
  String get playerId => 'Player ID';

  @override
  String get channel => 'Channel';

  @override
  String itemsTitle(int count) {
    return 'Items ($count)';
  }

  @override
  String get noItemsInOrder => 'No items';

  @override
  String get historyTitle => 'Status history';

  @override
  String get noHistory => 'No history yet';

  @override
  String notesTitle(int count) {
    return 'Notes ($count)';
  }

  @override
  String get noNotes => 'No notes yet';

  @override
  String attachmentsTitle(int count) {
    return 'Attachments ($count)';
  }

  @override
  String get noAttachments => 'No attachments';

  @override
  String get deletedBanner =>
      'This order has been removed. What you see is the last copy before it was removed.';

  @override
  String get actorSystem => 'system';

  @override
  String get actorCustomer => 'customer';

  @override
  String get actorAdmin => 'admin';

  @override
  String get actorSupport => 'support';

  @override
  String byActor(String actor) {
    return 'by $actor';
  }

  @override
  String get noteFromSupport => 'Support';

  @override
  String get noteFromYou => 'You';

  @override
  String get notFoundTitle => 'Order not found';

  @override
  String notFoundBody(String id) {
    return 'We couldn\'t find order $id. It may have been removed or the link is wrong.';
  }

  @override
  String get outboxNetwork =>
      'Not sent because the server couldn\'t be reached';

  @override
  String get outboxNotCancellable =>
      'This order can no longer be cancelled because its status changed';

  @override
  String get outboxNotFound => 'This order no longer exists';

  @override
  String get outboxValidation =>
      'The information is invalid. Please fix it and try again.';

  @override
  String get outboxConflict =>
      'The order changed while this was waiting to be sent';

  @override
  String get outboxDuplicate => 'This request duplicates an earlier one';

  @override
  String get outboxUnauthorized => 'Waiting for you to sign in again';

  @override
  String get outboxQueued => 'Pending send';

  @override
  String outboxFailedCode(String code) {
    return 'Not sent ($code)';
  }

  @override
  String get kindCancel => 'Cancel order';

  @override
  String get kindNote => 'Add note';

  @override
  String get reasonRequired => 'Please give a reason';

  @override
  String reasonTooLong(int max) {
    return 'The reason can be at most $max characters';
  }

  @override
  String get cancelDialogTitle => 'Cancel this order?';

  @override
  String cancelDialogBody(String id) {
    return 'Order $id will be cancelled. This can\'t be undone.';
  }

  @override
  String get cancelReasonLabel => 'Reason for cancelling';

  @override
  String get keepOrder => 'Keep order';

  @override
  String get confirmCancel => 'Cancel order';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get cancelQueued =>
      'Cancellation saved. It will be sent automatically when you\'re online.';

  @override
  String get pendingCancel =>
      'Cancellation pending. It will be sent automatically when you\'re online.';

  @override
  String pendingCancelRetrying(String reason) {
    return 'Cancellation pending ($reason). Retrying automatically.';
  }

  @override
  String actionFailed(String kind, String reason) {
    return '$kind failed: $reason';
  }

  @override
  String conflictAsk(String status) {
    return 'The order changed while waiting. It is now: $status. Cancel it again?';
  }

  @override
  String conflictFinal(String status) {
    return 'Couldn\'t cancel because the order is now $status';
  }

  @override
  String get cancelAgain => 'Cancel again';

  @override
  String get dontCancel => 'Don\'t cancel';

  @override
  String get acknowledge => 'OK';

  @override
  String get noteRequired => 'Please type a message';

  @override
  String noteTooLong(int max) {
    return 'At most $max characters';
  }

  @override
  String get noteLabel => 'Write a note to our team';

  @override
  String get sendNote => 'Send note';

  @override
  String get outboxTitle => 'Pending actions';

  @override
  String get sendNow => 'Send now';

  @override
  String get outboxEmpty => 'Nothing waiting to be sent';

  @override
  String get stateSending => 'Sending…';

  @override
  String get stateFailed => 'Not sent';

  @override
  String get stateConflict => 'Order changed, decision needed';

  @override
  String get stateQueued => 'Pending send';

  @override
  String get stateRequeued => 'Will retry';

  @override
  String reasonPrefix(String reason) {
    return 'Reason: $reason';
  }

  @override
  String latestServerStatus(String status) {
    return 'Latest status on server: $status';
  }

  @override
  String createdAttempts(String time, int attempts) {
    return 'Created $time · $attempts attempts';
  }

  @override
  String outboxFailedCount(int count) {
    return '$count actions not sent';
  }

  @override
  String outboxPendingCount(int count) {
    return '$count actions pending';
  }

  @override
  String get connLive => 'Live';

  @override
  String get connReconnecting => 'Reconnecting…';

  @override
  String get connOffline => 'Offline';

  @override
  String connSemantics(String label) {
    return 'Connection: $label';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsOpen => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageThai => 'ไทย';

  @override
  String get languageEnglish => 'English';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get notifications => 'Order notifications';

  @override
  String get notificationsHint =>
      'Notify me when an order is completed, cancelled or refunded';

  @override
  String get notificationsDenied =>
      'Notifications are turned off for this app. Enable them in system settings.';

  @override
  String get openSystemSettings => 'Open settings';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockHint =>
      'Require Face ID / fingerprint / device passcode after 30 s in the background';

  @override
  String get appLockUnavailable =>
      'This device has no biometrics or passcode set up';

  @override
  String get appLockReason => 'Confirm it\'s you to open InBlack Orders';

  @override
  String get appLockEnableReason => 'Confirm to turn on app lock';

  @override
  String get unlock => 'Unlock';

  @override
  String get locked => 'InBlack Orders is locked';

  @override
  String get clearImageCache => 'Clear image cache';

  @override
  String get imageCacheCleared => 'Image cache cleared';

  @override
  String version(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String get baseUrl => 'Server URL (debug)';

  @override
  String get baseUrlHint => 'Restart the app after changing it';

  @override
  String get save => 'Save';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutConfirm =>
      'Sign out? All data stored on this device, including unsent actions, will be deleted.';

  @override
  String get enableNotificationsTitle => 'Get notified about your orders?';

  @override
  String get enableNotificationsBody =>
      'We\'ll let you know when an order is completed, cancelled or refunded.';

  @override
  String get enable => 'Turn on';

  @override
  String get notNow => 'Not now';

  @override
  String get notifCompletedTitle => 'Order completed';

  @override
  String get notifCancelledTitle => 'Order cancelled';

  @override
  String get notifRefundedTitle => 'Order refunded';

  @override
  String notifBody(String id, String product) {
    return '$id · $product';
  }

  @override
  String notifSummaryTitle(int count) {
    return '$count orders updated';
  }

  @override
  String get notifChannel => 'Order updates';

  @override
  String get widgetOpenOrders => 'Open orders';
}
