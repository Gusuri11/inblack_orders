import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inblack_orders/app/router.dart';
import 'package:inblack_orders/core/notifications/local_notifications.dart';
import 'package:inblack_orders/core/notifications/notification_providers.dart';

String? deepLinkToLocation(Uri uri) {
  if (uri.scheme != 'inblack') return null;
  final segments = [
    if (uri.host.isNotEmpty) uri.host,
    ...uri.pathSegments.where((s) => s.isNotEmpty),
  ];
  if (segments.isEmpty || segments.first != 'orders') return null;
  if (segments.length == 1) {
    final statuses = (uri.queryParameters['status'] ?? '')
        .split(',')
        .map((s) => s.trim().toUpperCase())
        .where((s) => RegExp(r'^[A-Z_]{1,40}$').hasMatch(s))
        .toList();
    return statuses.isEmpty
        ? '/orders'
        : '/orders?status=${statuses.join(',')}';
  }
  if (segments.length == 2) {
    final id = segments[1];
    if (id.isEmpty || id.length > 64) return null;
    return '/orders/${Uri.encodeComponent(id)}';
  }
  return null;
}

String? safeRedirectTarget(String? from) {
  if (from == null || from.isEmpty) return null;
  final uri = Uri.tryParse(from);
  if (uri == null || uri.hasScheme || uri.hasAuthority) return null;
  if (!uri.path.startsWith('/orders')) return null;
  return from;
}

abstract interface class LinkSource {
  Future<Uri?> initial();
  Stream<Uri> get links;
}

class AppLinkSource implements LinkSource {
  AppLinkSource([AppLinks? links]) : _links = links ?? AppLinks();

  final AppLinks _links;

  @override
  Future<Uri?> initial() async {
    try {
      return await _links.getInitialLink();
    } on Object {
      return null;
    }
  }

  @override
  Stream<Uri> get links => _links.uriLinkStream;
}

class NotificationLinkSource implements LinkSource {
  NotificationLinkSource(this._presenter);

  final LocalNotificationPresenter _presenter;

  @override
  Future<Uri?> initial() async {
    final payload = await _presenter.launchPayload();
    return payload == null ? null : Uri.tryParse(payload);
  }

  @override
  Stream<Uri> get links =>
      _presenter.taps.map(Uri.tryParse).where((u) => u != null).cast<Uri>();
}

class MergedLinkSource implements LinkSource {
  MergedLinkSource(this._sources);

  final List<LinkSource> _sources;

  @override
  Future<Uri?> initial() async {
    for (final s in _sources) {
      final uri = await s.initial();
      if (uri != null) return uri;
    }
    return null;
  }

  @override
  Stream<Uri> get links {
    final controller = StreamController<Uri>();
    final subs = <StreamSubscription<Uri>>[];
    controller
      ..onListen = () {
        for (final s in _sources) {
          subs.add(
            s.links.listen(controller.add, onError: controller.addError),
          );
        }
      }
      ..onCancel = () async {
        for (final sub in subs) {
          await sub.cancel();
        }
      };
    return controller.stream;
  }
}

final linkSourceProvider = Provider<LinkSource>(
  (ref) => MergedLinkSource([
    AppLinkSource(),
    NotificationLinkSource(ref.watch(notificationPresenterProvider)),
  ]),
);

class DeepLinkListener extends ConsumerStatefulWidget {
  const DeepLinkListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends ConsumerState<DeepLinkListener> {
  StreamSubscription<Uri>? _sub;
  Uri? _last;
  DateTime _lastAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    final source = ref.read(linkSourceProvider);
    unawaited(source.initial().then((uri) => uri == null ? null : _open(uri)));
    _sub = source.links.listen(_open, onError: (Object _) {});
  }

  void _open(Uri uri) {
    final now = DateTime.now();
    if (uri == _last && now.difference(_lastAt) < const Duration(seconds: 2)) {
      return;
    }
    _last = uri;
    _lastAt = now;
    final location = deepLinkToLocation(uri);
    if (location == null || !mounted) return;
    ref.read(routerProvider).go(location);
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
