// import 'dart:async';

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '/core/logger.dart';
import '/features/auth_screen/view/auth_screen.dart';

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

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    bool connected =
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);

    // 👇 Add a real connectivity check (works inside Winlator)
    if (connected) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
          _handleConnected();
          return;
        }
      } catch (_) {
        _handleDisconnected();
        return;
      }
    }
    _handleDisconnected();
  }

  void _handleConnected() {
    if (!_isConnected) {
      _isConnected = true;
      logInfo('Connected to Internet');
      Navigator.pushReplacementNamed(context, AuthScreen.path);
    }
  }

  void _handleDisconnected() {
    if (_isConnected) {
      _isConnected = false;
      logInfo('No Internet Connection');
      Navigator.pushReplacementNamed(context, ConnectionCheckerScreen.path);
    } else {
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
                  children: const [
                    Icon(Icons.wifi_off, size: 80, color: Colors.red),
                    SizedBox(height: 20),
                    Text(
                      'No Internet Connection',
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Waiting for connection...',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
      ),
    );
  }
}

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import '/features/auth_screen/view/auth_screen.dart';
// import '/core/logger.dart';

// class ConnectionCheckerScreen extends StatefulWidget {
//   static const String path = '/connection_checker';

//   const ConnectionCheckerScreen({super.key});

//   @override
//   State<ConnectionCheckerScreen> createState() =>
//       _ConnectionCheckerScreenState();
// }

// class _ConnectionCheckerScreenState extends State<ConnectionCheckerScreen> {
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<List<ConnectivityResult>> _subscription;
//   bool _isConnected = false;

//   @override
//   void initState() {
//     super.initState();
//     _startMonitoring();
//   }

//   void _startMonitoring() {
//     _subscription = _connectivity.onConnectivityChanged.listen((results) {
//       _updateConnectionStatus(results);
//     });
//     _checkInitialConnection();
//   }

//   Future<void> _checkInitialConnection() async {
//     var results = await _connectivity.checkConnectivity();
//     _updateConnectionStatus(results);
//   }

//   void _updateConnectionStatus(List<ConnectivityResult> results) {
//     bool connected =
//         results.contains(ConnectivityResult.ethernet) ||
//         results.contains(ConnectivityResult.mobile) ||
//         results.contains(ConnectivityResult.wifi);
//     if (connected && !_isConnected) {
//       _isConnected = true;
//       logInfo('Connected to Internet');

//       /// Navigate to Auth or Landing page
//       Navigator.pushReplacementNamed(context, AuthScreen.path);
//     } else if (!connected && _isConnected) {
//       _isConnected = false;
//       logInfo('No Internet Connection');

//       /// Stay on no internet page
//       Navigator.pushReplacementNamed(context, ConnectionCheckerScreen.path);
//     } else if (!connected && !_isConnected) {
//       setState(() {}); // rebuild to show no internet
//     }
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child:
//             _isConnected
//                 ? const CircularProgressIndicator()
//                 : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.wifi_off, size: 80, color: Colors.red),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'No Internet Connection',
//                       style: TextStyle(fontSize: 24, color: Colors.red),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Waiting for connection...',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 20),
//                     const CircularProgressIndicator(),
//                   ],
//                 ),
//       ),
//     );
//   }
// }
