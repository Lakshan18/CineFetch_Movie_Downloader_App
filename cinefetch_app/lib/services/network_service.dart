import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  StreamController<bool> connectionController =
      StreamController<bool>.broadcast();
  Timer? _retryTimer;

  NetworkService() {
    _init();
  }

  Future<void> _init() async {
    await _checkConnection();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Connection check failed: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final newStatus = result != ConnectivityResult.none;
    if (newStatus != _isConnected) {
      _isConnected = newStatus;
      notifyListeners();
      connectionController.add(newStatus);
    }
  }

  Stream<bool> get connectionChanges => connectionController.stream;

  Future<void> showNoInternetDialog(BuildContext context) async {
    _retryTimer?.cancel();

    if (ModalRoute.of(context)?.isCurrent != true) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF051225),
        title: const Text(
          'No Internet Connection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "Rosario",
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Please check your internet connection and try again.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: "Rosario",
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkConnection();
              _scheduleNextDialog(context);
            },
            child: const Text('Retry', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );

    _scheduleNextDialog(context);
  }

  void _scheduleNextDialog(BuildContext context) {
    _retryTimer = Timer(const Duration(seconds: 10), () {
      if (!_isConnected && ModalRoute.of(context)?.isCurrent == true) {
        showNoInternetDialog(context);
      }
    });
  }

  void disposeService() {
    _connectivitySubscription.cancel();
    connectionController.close();
    _retryTimer?.cancel();
  }
}
