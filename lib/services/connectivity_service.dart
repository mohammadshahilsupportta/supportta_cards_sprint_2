import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '/features/auth_screen/view/auth_screen.dart';
import '/core/logger.dart';

class ConnectionCheckerScreen extends StatefulWidget {
  static const String path = '/connection_checker';

  const ConnectionCheckerScreen({super.key});

  @override
  State<ConnectionCheckerScreen> createState() =>
      _ConnectionCheckerScreenState();
}

class _ConnectionCheckerScreenState extends State<ConnectionCheckerScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    var results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool connected =
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
    if (connected && !_isConnected) {
      _isConnected = true;
      logInfo('Connected to Internet');

      /// Navigate to Auth or Landing page
      Navigator.pushReplacementNamed(context, AuthScreen.path);
    } else if (!connected && _isConnected) {
      _isConnected = false;
      logInfo('No Internet Connection');

      /// Stay on no internet page
      Navigator.pushReplacementNamed(context, ConnectionCheckerScreen.path);
    } else if (!connected && !_isConnected) {
      setState(() {}); // rebuild to show no internet
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _isConnected
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 80, color: Colors.red),
                    const SizedBox(height: 20),
                    const Text(
                      'No Internet Connection',
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Waiting for connection...',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
      ),
    );
  }
}
