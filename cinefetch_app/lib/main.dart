import 'dart:async';
import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      title: 'Cine Fetch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() async {
    for (int i = 0; i <= 64; i++) {
      await Future.delayed(const Duration(milliseconds: 15));
      setState(() {
        progress = i / 100;
      });
    }
    setState(() {
      loadingText = "Fetching the latest movie magic...";
    });
    await Future.delayed(const Duration(seconds: 2));

    for (int i = 65; i <= 88; i++) {
      await Future.delayed(const Duration(milliseconds: 15));
      setState(() {
        progress = i / 100;
      });
    }
    setState(() {
      loadingText = "Setting up your experience...";
    });
    await Future.delayed(const Duration(seconds: 2));

    for (int i = 89; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        progress = i / 100;
      });
    }
    setState(() async {
      loadingText = "Almost Done!";
      progress = 1.0;
      await Future.delayed(const Duration(seconds: 1));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginProcess(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF051225),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: Color(0xFF051225),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
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
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          SizedBox(height: 10),
                          Text(
                            loadingText,
                            style: TextStyle(
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