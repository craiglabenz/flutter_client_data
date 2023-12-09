import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Interface of the AppConfigRepository's `service` field.
// ignore: one_member_abstracts
abstract class BaseLiveAppConfigService {
  Stream<Map<String, dynamic>> appConfig();
}

/// Real implementation of the AppConfigRepository's `service` field.
class FirestoreAppConfigService extends BaseLiveAppConfigService {
  FirestoreAppConfigService() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<Map<String, dynamic>> appConfig() => _firestore
      .doc('global/app_config')
      .snapshots()
      .map((snapshot) => snapshot.data() ?? <String, Object?>{})
      .asBroadcastStream();
}

/// Fake implementation of the AppConfigRepository's `service` field.
class FakeAppConfigService extends BaseLiveAppConfigService {
  FakeAppConfigService()
      : _appConfigController = StreamController<Map<String, dynamic>>();

  final StreamController<Map<String, dynamic>> _appConfigController;

  void add(Map<String, dynamic> val) => _appConfigController.add(val);

  @override
  Stream<Map<String, dynamic>> appConfig() =>
      _appConfigController.stream.asBroadcastStream();
}
