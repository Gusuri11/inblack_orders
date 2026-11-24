import 'package:inblack_orders/core/network/api_exception.dart';
import 'package:inblack_orders/l10n/app_localizations.dart';

String friendlyError(AppLocalizations l, ApiException e) {
  if (e.isNetworkError) return e.isTimeout ? l.errorTimeout : l.errorNetwork;
  if (e.statusCode == 429) return l.errorRateLimited;
  if (e.isServerError) return l.errorServer;
  if (e.statusCode == 401) return l.errorSessionExpired;
  return l.errorGeneric;
}
