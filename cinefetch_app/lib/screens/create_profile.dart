import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateProfileProcess extends StatefulWidget {
  const CreateProfileProcess({super.key});

  @override
  State<CreateProfileProcess> createState() => _CreateProfileProcessState();
}

// const CircularProgressIndicator(),
// const SizedBox(height: 20),
// Text(
//   'Loading assets...',
//   style: TextStyle(
//     fontSize: 18,
//     color: Colors.white
//   ),
// ),

class _CreateProfileProcessState extends State<CreateProfileProcess> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF020912),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF020912),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  "assets/page_background.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              top: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logo/cine_fetch_logo_tr.png",
                          width: 100,
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
