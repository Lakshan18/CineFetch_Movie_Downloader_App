// import 'dart:async';
// import 'package:cinefetch_app/screens/home_screen.dart';
// import 'package:cinefetch_app/screens/login_screen.dart';
// import 'package:cinefetch_app/services/session_manager.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => ChangeNotifierProvider(
//         create: (context) => ThemeProvider(),
//         child: const MyApp(),
//       ),
//     ),
//   );
// }

// class ThemeProvider with ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.dark;

//   ThemeMode get themeMode => _themeMode;

//   void toggleTheme(bool isDark) {
//     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           builder: DevicePreview.appBuilder,
//           locale: DevicePreview.locale(context),
//           debugShowCheckedModeBanner: false,
//           home: const SplashScreen(),
//           title: 'Cine Fetch',
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.blue,
//               brightness: Brightness.light,
//             ),
//             visualDensity: VisualDensity.adaptivePlatformDensity,
//           ),
//           darkTheme: ThemeData.dark().copyWith(
//             scaffoldBackgroundColor: const Color(0xFF020912),
//             appBarTheme: const AppBarTheme(
//               backgroundColor: const Color(0xFF020912),
//             ),
//           ),
//           themeMode: themeProvider.themeMode,
//         );
//       },
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   double progress = 0.0;
//   String loadingText = "Loading...";
//   bool _sessionChecked = false;
//   bool _hasSession = false;
//   bool _hasInternetConnection = false;
//   bool _connectionChecked = false;
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;

//   @override
//   void initState() {
//     super.initState();
//     _initConnectivity();
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
//     _startProgress();
//   }

//   @override
//   void dispose() {
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }

//   Future<void> _initConnectivity() async {
//     try {
//       var connectivityResult = await Connectivity().checkConnectivity();
//       _updateConnectionStatus(connectivityResult);
//     } on PlatformException catch (e) {
//       debugPrint('Could not check connectivity status: $e');
//       setState(() {
//         _connectionChecked = true;
//       });
//     }
//   }

//   void _updateConnectionStatus(ConnectivityResult result) {
//     setState(() {
//       _hasInternetConnection = result != ConnectivityResult.none;
//       _connectionChecked = true;
//     });
//   }

//   Future<void> _checkSession() async {
//     if (!_hasInternetConnection) return;
    
//     final session = await SessionManager.getSession();
//     setState(() {
//       _hasSession = session != null;
//       _sessionChecked = true;
//     });
//   }

//   void _showNoInternetDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF051225),
//         title: const Text(
//           'No Internet Connection',
//           style: TextStyle(color: Colors.white),
//         ),
//         content: const Text(
//           'Please check your internet connection and try again.',
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _initConnectivity(); // Re-check connection
//             },
//             child: const Text(
//               'Retry',
//               style: TextStyle(color: Colors.blue),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _startProgress() async {
//     // Wait for connection check to complete
//     while (!_connectionChecked) {
//       await Future.delayed(const Duration(milliseconds: 100));
//     }

//     if (!_hasInternetConnection) {
//       _showNoInternetDialog();
//       return;
//     }

//     // Start normal progress flow only if there's internet
//     for (int i = 0; i <= 64; i++) {
//       await Future.delayed(const Duration(milliseconds: 15));
//       if (!mounted) return;
//       setState(() {
//         progress = i / 100;
//       });
//     }
    
//     setState(() {
//       loadingText = "Fetching the latest movie magic...";
//     });
//     await Future.delayed(const Duration(seconds: 2));

//     for (int i = 65; i <= 88; i++) {
//       await Future.delayed(const Duration(milliseconds: 15));
//       if (!mounted) return;
//       setState(() {
//         progress = i / 100;
//       });
//     }
    
//     setState(() {
//       loadingText = "Setting up your experience...";
//     });
//     await Future.delayed(const Duration(seconds: 2));

//     for (int i = 89; i <= 100; i++) {
//       await Future.delayed(const Duration(milliseconds: 30));
//       if (!mounted) return;
//       setState(() {
//         progress = i / 100;
//       });
//     }

//     setState(() {
//       loadingText = "Almost Done!";
//       progress = 1.0;
//     });

//     await _checkSession();
//     while (!_sessionChecked) {
//       await Future.delayed(const Duration(milliseconds: 100));
//     }

//     if (mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => _hasSession ? const HomeScreen() : const LoginProcess(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Color(0xFF051225),
//         statusBarIconBrightness: Brightness.dark,
//       ),
//     );

//     return SafeArea(
//       top: true,
//       bottom: false,
//       child: Scaffold(
//         backgroundColor: const Color(0xFF051225),
//         body: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 100,
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'version 1.0',
//                     style: TextStyle(fontSize: 12, color: Color(0xFF898989)),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Stack(
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       "assets/logo/Cine_Fetch_Logo.png",
//                       fit: BoxFit.cover,
//                       width: 180,
//                       height: 160,
//                     ),
//                   ),
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 38,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (_connectionChecked && _hasInternetConnection)
//                             LinearProgressIndicator(
//                               value: progress,
//                               backgroundColor: Colors.white24,
//                               valueColor: const AlwaysStoppedAnimation<Color>(
//                                 Colors.blue,
//                               ),
//                             )
//                           else if (!_hasInternetConnection)
//                             const Icon(
//                               Icons.wifi_off,
//                               color: Colors.red,
//                               size: 40,
//                             ),
//                           const SizedBox(height: 10),
//                           Text(
//                             loadingText,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }









// import 'dart:async';
// import 'package:cinefetch_app/screens/home_screen.dart';
// import 'package:cinefetch_app/screens/login_screen.dart';
// import 'package:cinefetch_app/services/session_manager.dart';
// import 'package:cinefetch_app/services/network_service.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => ThemeProvider()),
//           ChangeNotifierProvider(create: (_) => NetworkService()),
//         ],
//         child: const MyApp(),
//       ),
//     ),
//   );
// }

// class ThemeProvider with ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.dark;

//   ThemeMode get themeMode => _themeMode;

//   void toggleTheme(bool isDark) {
//     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           builder: (context, child) {
//             return Consumer<NetworkService>(
//               builder: (context, networkService, child) {
//                 // Show connectivity dialog when connection is lost
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (!networkService.isConnected && 
//                       ModalRoute.of(context)?.isCurrent == true) {
//                     networkService.showNoInternetDialog(context);
//                   }
//                 });
//                 return child!;
//               },
//               child: child,
//             );
//           },
//           locale: DevicePreview.locale(context),
//           debugShowCheckedModeBanner: false,
//           home: const SplashScreen(),
//           title: 'Cine Fetch',
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.blue,
//               brightness: Brightness.light,
//             ),
//             visualDensity: VisualDensity.adaptivePlatformDensity,
//           ),
//           darkTheme: ThemeData.dark().copyWith(
//             scaffoldBackgroundColor: const Color(0xFF020912),
//             appBarTheme: const AppBarTheme(
//               backgroundColor: Color(0xFF020912),
//             ),
//           ),
//           themeMode: themeProvider.themeMode,
//         );
//       },
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   double progress = 0.0;
//   String loadingText = "Loading...";
//   bool _sessionChecked = false;
//   bool _hasSession = false;
//   bool _progressStarted = false;
//   late StreamSubscription<bool> _connectionSubscription;
//   bool _dialogShowing = false;

//   @override
//   void initState() {
//     super.initState();
//     final networkService = Provider.of<NetworkService>(context, listen: false);
    
//     _connectionSubscription = networkService.connectionChanges.listen((isConnected) {
//       if (isConnected) {
//         if (_dialogShowing) {
//           Navigator.of(context).pop(); // Dismiss the dialog if showing
//           _dialogShowing = false;
//         }
//         _startProgress();
//       } else {
//         _handleNoConnection(networkService);
//       }
//     });
    
//     if (networkService.isConnected) {
//       _startProgress();
//     } else {
//       _handleNoConnection(networkService);
//     }
//   }

//   void _handleNoConnection(NetworkService networkService) {
//     if (!_dialogShowing) {
//       _dialogShowing = true;
//       networkService.showNoInternetDialog(context).then((_) {
//         _dialogShowing = false;
//       });
//     }
//     // Reset progress flags to allow restart when connection returns
//     _progressStarted = false;
//   }

//   @override
//   void dispose() {
//     _connectionSubscription.cancel();
//     super.dispose();
//   }

//   Future<void> _checkSession() async {
//     final networkService = Provider.of<NetworkService>(context, listen: false);
//     if (!networkService.isConnected) return;
    
//     final session = await SessionManager.getSession();
//     if (mounted) {
//       setState(() {
//         _hasSession = session != null;
//         _sessionChecked = true;
//       });
//     }
//   }

//   void _startProgress() {
//     if (_progressStarted && progress > 0) return;
//     _progressStarted = true;
    
//     setState(() {
//       progress = 0.0;
//       loadingText = "Loading...";
//     });

//     _runProgress();
//   }

//   Future<void> _runProgress() async {
//     final networkService = Provider.of<NetworkService>(context, listen: false);
    
//     // Progress animation
//     for (int i = 0; i <= 64; i++) {
//       await Future.delayed(const Duration(milliseconds: 15));
//       if (!mounted || !networkService.isConnected) {
//         _progressStarted = false;
//         return;
//       }
//       setState(() => progress = i / 100);
//     }
    
//     setState(() => loadingText = "Fetching the latest movie magic...");
//     await Future.delayed(const Duration(seconds: 2));

//     for (int i = 65; i <= 88; i++) {
//       await Future.delayed(const Duration(milliseconds: 15));
//       if (!mounted || !networkService.isConnected) {
//         _progressStarted = false;
//         return;
//       }
//       setState(() => progress = i / 100);
//     }
    
//     setState(() => loadingText = "Setting up your experience...");
//     await Future.delayed(const Duration(seconds: 2));

//     for (int i = 89; i <= 100; i++) {
//       await Future.delayed(const Duration(milliseconds: 30));
//       if (!mounted || !networkService.isConnected) {
//         _progressStarted = false;
//         return;
//       }
//       setState(() => progress = i / 100);
//     }

//     setState(() {
//       loadingText = "Almost Done!";
//       progress = 1.0;
//     });

//     await _checkSession();
//     while (!_sessionChecked && mounted && networkService.isConnected) {
//       await Future.delayed(const Duration(milliseconds: 100));
//     }

//     if (mounted && networkService.isConnected) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => _hasSession ? const HomeScreen() : const LoginProcess(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final networkService = Provider.of<NetworkService>(context);

//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Color(0xFF051225),
//         statusBarIconBrightness: Brightness.dark,
//       ),
//     );

//     return SafeArea(
//       top: true,
//       bottom: false,
//       child: Scaffold(
//         backgroundColor: const Color(0xFF051225),
//         body: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 100,
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'version 1.0',
//                     style: TextStyle(fontSize: 12, color: Color(0xFF898989)),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Stack(
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       "assets/logo/Cine_Fetch_Logo.png",
//                       fit: BoxFit.cover,
//                       width: 180,
//                       height: 160,
//                     ),
//                   ),
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 38,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           networkService.isConnected
//                               ? LinearProgressIndicator(
//                                   value: progress,
//                                   backgroundColor: Colors.white24,
//                                   valueColor: const AlwaysStoppedAnimation<Color>(
//                                     Colors.blue,
//                                   ),
//                                 )
//                               : const Icon(
//                                   Icons.wifi_off,
//                                   color: Colors.red,
//                                   size: 40,
//                                 ),
//                           const SizedBox(height: 10),
//                           Text(
//                             loadingText,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'dart:async';
import 'package:cinefetch_app/screens/home_screen.dart';
import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:cinefetch_app/services/session_manager.dart';
import 'package:cinefetch_app/services/network_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => NetworkService()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          builder: (context, child) {
            return Consumer<NetworkService>(
              builder: (context, networkService, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!networkService.isConnected && 
                      ModalRoute.of(context)?.isCurrent == true) {
                    networkService.showNoInternetDialog(context);
                  }
                });
                return child!;
              },
              child: child,
            );
          },
          locale: DevicePreview.locale(context),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          title: 'Cine Fetch',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF020912),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF020912),
            ),
          ),
          themeMode: themeProvider.themeMode,
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.0;
  String loadingText = "Loading...";
  bool _sessionChecked = false;
  bool _hasSession = false;
  bool _progressStarted = false;
  late StreamSubscription<bool> _connectionSubscription;
  bool _dialogShowing = false;

  @override
  void initState() {
    super.initState();
    final networkService = Provider.of<NetworkService>(context, listen: false);
    
    _connectionSubscription = networkService.connectionChanges.listen((isConnected) {
      if (isConnected) {
        if (_dialogShowing) {
          Navigator.of(context).pop();
          _dialogShowing = false;
        }
        _startProgress();
      } else {
        _handleNoConnection(networkService);
      }
    });
    
    if (networkService.isConnected) {
      _startProgress();
    } else {
      _handleNoConnection(networkService);
    }
  }

  void _handleNoConnection(NetworkService networkService) {
    if (!_dialogShowing) {
      _dialogShowing = true;
      networkService.showNoInternetDialog(context).then((_) {
        _dialogShowing = false;
      });
    }
    _progressStarted = false;
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  Future<void> _checkSession() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    if (!networkService.isConnected) return;
    
    final session = await SessionManager.getSession();
    if (mounted) {
      setState(() {
        _hasSession = session != null;
        _sessionChecked = true;
      });
    }
  }

  void _startProgress() {
    if (_progressStarted && progress > 0) return;
    _progressStarted = true;
    
    setState(() {
      progress = 0.0;
      loadingText = "Loading...";
    });

    _runProgress();
  }

  Future<void> _runProgress() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    
    for (int i = 0; i <= 64; i++) {
      await Future.delayed(const Duration(milliseconds: 15));
      if (!mounted || !networkService.isConnected) {
        _progressStarted = false;
        return;
      }
      setState(() => progress = i / 100);
    }
    
    setState(() => loadingText = "Fetching the latest movie magic...");
    await Future.delayed(const Duration(seconds: 2));

    for (int i = 65; i <= 88; i++) {
      await Future.delayed(const Duration(milliseconds: 15));
      if (!mounted || !networkService.isConnected) {
        _progressStarted = false;
        return;
      }
      setState(() => progress = i / 100);
    }
    
    setState(() => loadingText = "Setting up your experience...");
    await Future.delayed(const Duration(seconds: 2));

    for (int i = 89; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted || !networkService.isConnected) {
        _progressStarted = false;
        return;
      }
      setState(() => progress = i / 100);
    }

    setState(() {
      loadingText = "Almost Done!";
      progress = 1.0;
    });

    await _checkSession();
    while (!_sessionChecked && mounted && networkService.isConnected) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (mounted && networkService.isConnected) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _hasSession ? const HomeScreen() : const LoginProcess(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final networkService = Provider.of<NetworkService>(context);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF051225),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF051225),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'version 1.0',
                    style: TextStyle(fontSize: 12, color: Color(0xFF898989)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/logo/Cine_Fetch_Logo.png",
                      fit: BoxFit.cover,
                      width: 180,
                      height: 160,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 38,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          networkService.isConnected
                              ? LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                )
                              : const Icon(
                                  Icons.wifi_off,
                                  color: Colors.red,
                                  size: 40,
                                ),
                          const SizedBox(height: 10),
                          Text(
                            loadingText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}