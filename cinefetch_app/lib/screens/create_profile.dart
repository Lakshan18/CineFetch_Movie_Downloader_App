// import 'dart:io';
// import 'package:cinefetch_app/components/custom_action_message.dart';
// import 'package:cinefetch_app/components/custom_message.dart';
// import 'package:cinefetch_app/components/custom_pin_textfield.dart';
// import 'package:cinefetch_app/components/custom_textfield.dart';
// import 'package:cinefetch_app/routes/custom_page_route.dart';
// import 'package:cinefetch_app/screens/login_screen.dart';
// import 'package:cinefetch_app/services/image_picker_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CreateProfileProcess extends StatefulWidget {
//   const CreateProfileProcess({super.key});

//   @override
//   State<CreateProfileProcess> createState() => _CreateProfileProcessState();
// }

// class _CreateProfileProcessState extends State<CreateProfileProcess> {
//   final _usernameController = TextEditingController();
//   final _pinController = TextEditingController();
//   final ImagePickerService _imagePickerService = ImagePickerService();
//   File? _profileImage;
//   bool isLoading = false;

//   // Progress bar variables
//   double _progress = 0.0;
//   bool _isCreating = false;

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       setState(() => isLoading = true);
//       Navigator.pop(context); // Close the bottom sheet

//       File? imageFile;
//       if (source == ImageSource.gallery) {
//         imageFile = await _imagePickerService.pickImageFromGallery();
//       } else {
//         imageFile = await _imagePickerService.captureImageFromCamera();
//       }

//       if (imageFile != null) {
//         setState(() {
//           _profileImage = imageFile;
//         });
//       }
//     } catch (e) {
//       print('Image picker error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<bool> _handleProfileImage() async {
//     if (_profileImage != null) return true;

//     final proceedWithoutImage = await CustomActionMessage.show(
//       context: context,
//       title: "Profile Photo",
//       message:
//           "You haven't selected a profile photo. Do you want to proceed with the default image?",
//       yesText: "Proceed",
//       noText: "Cancel",
//     );

//     return proceedWithoutImage;
//   }

//   Future<void> _simulateProgress() async {
//     for (int i = 1; i <= 100; i++) {
//       await Future.delayed(const Duration(milliseconds: 40));
//       if (i == 65 || i == 92) {
//         await Future.delayed(const Duration(milliseconds: 1500));
//       }
//       setState(() {
//         _progress = i / 100.0;
//       });
//     }
//   }

//   Future<void> _startProfileCreation() async {
//     final canProceed = await _handleProfileImage();
//     if (!canProceed) return;

//     setState(() {
//       _isCreating = true;
//       _progress = 0.0;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString("userId");

//       if (userId == null) {
//         CustomMessage.show(
//           context: context,
//           message: "Something went wrong!",
//           type: MessageType.error,
//         );
//       }

//       String imageUrl;
//       String imageType;

//       if (_profileImage != null) {
//         final storageRef = FirebaseStorage.instance.ref().child(
//           "UsersProfileImages/user_upd_$userId.jpg",
//         );

//         await storageRef.putFile(_profileImage!);
//         imageUrl = await storageRef.getDownloadURL();
//         imageType = "Uploaded";
//       } else {
//         final defaultRef = FirebaseStorage.instance.ref().child(
//           "UsersProfileImages/user_def_default.png",
//         );
//         imageUrl = await defaultRef.getDownloadURL();
//         imageType = "Default";

//         final userDefRef = FirebaseStorage.instance.ref().child(
//           "UsersProfileImages/user_def_$userId.png",
//         );
//         await userDefRef.putString(imageUrl, format: PutStringFormat.dataUrl);
//       }

//       await FirebaseFirestore.instance.collection("user").doc(userId).set({
//         'username': _usernameController.text.trim(),
//         'unlock_pin': _pinController.text.trim(),
//         'profile_img_path': imageUrl,
//         'profile_img_type': imageType,
//       }, SetOptions(merge: true));

//       await _simulateProgress();

//       if (mounted) {
//         CustomMessage.show(
//           context: context,
//           message: "Profile Created Successfully!",
//           type: MessageType.success,
//         );

//         await Future.delayed(const Duration(seconds: 2));

//         Navigator.pushReplacement(
//           context,
//           SlideFadePageRoute(page: const LoginProcess()),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         CustomMessage.show(
//           context: context,
//           message: "Failed to create profile: ${e.toString()}",
//           type: MessageType.error,
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isCreating = false;
//           _progress = 0.0;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor: Color(0xFF020912),
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         backgroundColor: Color(0xFF020912),
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: Opacity(
//                 opacity: 0.09,
//                 child: Image.asset(
//                   "assets/page_background.png",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SafeArea(
//               top: true,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 30.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           "assets/logo/cine_fetch_logo_tr.png",
//                           width: 100,
//                           height: 70,
//                           fit: BoxFit.contain,
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: Container(
//                         width: double.infinity,
//                         height: double.infinity,
//                         padding: const EdgeInsets.all(20.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: isLoading
//                                       ? Container(
//                                           width: 140,
//                                           height: 140,
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: const Color.fromARGB(
//                                               255,
//                                               108,
//                                               160,
//                                               184,
//                                             ),
//                                           ),
//                                           child: const Center(
//                                             child: CircularProgressIndicator(
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<Color>(
//                                                     Colors.white,
//                                                   ),
//                                             ),
//                                           ),
//                                         )
//                                       : _profileImage != null
//                                       ? ClipOval(
//                                           child: Image.file(
//                                             _profileImage!,
//                                             width: 140,
//                                             height: 140,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         )
//                                       : Image.asset(
//                                           "assets/user_icon.png",
//                                           width: 140,
//                                           height: 140,
//                                           fit: BoxFit.contain,
//                                         ),
//                                 ),
//                                 Positioned(
//                                   bottom: 8,
//                                   right: 8,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       showModalBottomSheet(
//                                         context: context,
//                                         shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(18),
//                                           ),
//                                         ),
//                                         builder: (context) => SafeArea(
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               ListTile(
//                                                 leading: const Icon(
//                                                   Icons.photo_camera,
//                                                   color: Colors.blue,
//                                                 ),
//                                                 title: const Text(
//                                                   'Take a photo',
//                                                 ),
//                                                 onTap: () => _pickImage(
//                                                   ImageSource.camera,
//                                                 ),
//                                               ),
//                                               ListTile(
//                                                 leading: const Icon(
//                                                   Icons.photo_library,
//                                                   color: Colors.blue,
//                                                 ),
//                                                 title: const Text(
//                                                   'Choose from gallery',
//                                                 ),
//                                                 onTap: () => _pickImage(
//                                                   ImageSource.gallery,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 10),
//                                               TextButton(
//                                                 child: const Text('Cancel'),
//                                                 onPressed: () =>
//                                                     Navigator.pop(context),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       width: 45,
//                                       height: 45,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         shape: BoxShape.circle,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black26,
//                                             blurRadius: 4,
//                                             offset: Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(6.0),
//                                         child: Image.asset(
//                                           "assets/plus.png",
//                                           width: 40,
//                                           height: 40,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 25.0),
//                             MyTextField(
//                               controller: _usernameController,
//                               hinttext: "Username",
//                               obsecuretext: false,
//                               suffixIcon: false,
//                             ),
//                             const SizedBox(height: 20.0),
//                             MyPinTextField(
//                               controller: _pinController,
//                               textfieldinfo:
//                                   "** create your account key to unlock for emergency moments.!",
//                               hinttext: "Unlock-PIN",
//                               obsecuretext: true,
//                               suffixIcon: true,
//                             ),
//                             const SizedBox(height: 40.0),

//                             if (_isCreating) ...[
//                               LinearProgressIndicator(
//                                 value: _progress,
//                                 minHeight: 8,
//                                 backgroundColor: Colors.white12,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Color(0xFF1A73E8),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 "Creating...  ${(100 * _progress).toInt()}%",
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontFamily: "Quicksand",
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                             ] else
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () async {
//                                     // if (_profileImage == null) {
//                                     //   CustomMessage.show(
//                                     //     context: context,
//                                     //     message:
//                                     //         "Please select a profile photo.",
//                                     //     type: MessageType.error,
//                                     //   );
//                                     //   return;
//                                     // }
//                                     if (_usernameController.text
//                                             .trim()
//                                             .isEmpty ||
//                                         _pinController.text.trim().isEmpty) {
//                                       CustomMessage.show(
//                                         context: context,
//                                         message:
//                                             "Username and Unlock-PIN cannot be empty.",
//                                         type: MessageType.error,
//                                       );
//                                       return;
//                                     }
//                                     if (_pinController.text.length != 6) {
//                                       CustomMessage.show(
//                                         context: context,
//                                         message:
//                                             "PIN must be exactly 6 digits.",
//                                         type: MessageType.error,
//                                       );
//                                       return;
//                                     }
//                                     await _startProfileCreation();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF1A73E8),
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 14.0,
//                                       horizontal: 24.0,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     "CREATE",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontFamily: "Quicksand",
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cinefetch_app/components/custom_action_message.dart';
import 'package:cinefetch_app/components/custom_message.dart';
import 'package:cinefetch_app/components/custom_pin_textfield.dart';
import 'package:cinefetch_app/components/custom_textfield.dart';
import 'package:cinefetch_app/routes/custom_page_route.dart';
import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:cinefetch_app/services/image_picker_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfileProcess extends StatefulWidget {
  const CreateProfileProcess({super.key});

  @override
  State<CreateProfileProcess> createState() => _CreateProfileProcessState();
}

class _CreateProfileProcessState extends State<CreateProfileProcess> {
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? _profileImage;
  bool isLoading = false;
  double _progress = 0.0;
  bool _isCreating = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => isLoading = true);
      Navigator.pop(context);

      File? imageFile;
      if (source == ImageSource.gallery) {
        imageFile = await _imagePickerService.pickImageFromGallery();
      } else {
        imageFile = await _imagePickerService.captureImageFromCamera();
      }

      if (imageFile != null) {
        setState(() => _profileImage = imageFile);
      }
    } catch (e) {
      CustomMessage.show(
        context: context,
        message: "Failed to pick image: ${e.toString()}",
        type: MessageType.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool> _handleProfileImage() async {
    if (_profileImage != null) return true;

    return await CustomActionMessage.show(
      context: context,
      title: "Profile Photo",
      message:
          "You haven't selected a profile photo. Do you want to proceed with the default image?",
      yesText: "Proceed",
      noText: "Cancel",
    );
  }

  Future<void> _simulateProgress() async {
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (i == 65 || i == 92) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }
      if (mounted) {
        setState(() => _progress = i / 100.0);
      }
    }
  }

  Future<void> _startProfileCreation() async {
    if (_usernameController.text.trim().isEmpty ||
        _pinController.text.trim().isEmpty) {
      CustomMessage.show(
        context: context,
        message: "Username and Unlock-PIN cannot be empty.",
        type: MessageType.error,
      );
      return;
    }

    if (_pinController.text.length != 6) {
      CustomMessage.show(
        context: context,
        message: "PIN must be exactly 6 digits.",
        type: MessageType.error,
      );
      return;
    }

    final canProceed = await _handleProfileImage();
    if (!canProceed) return;

    setState(() {
      _isCreating = true;
      _progress = 0.0;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId");

      if (userId == null) {
        CustomMessage.show(
          context: context,
          message: "User ID not found. Please try again.",
          type: MessageType.error,
        );
        return;
      }

      String imageUrl;
      String imageType;

      if (_profileImage != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
          "UsersProfileImages/user_upd_$userId.jpg",
        );

        await storageRef.putFile(_profileImage!);
        imageUrl = await storageRef.getDownloadURL();
        imageType = "uploaded";
      } else {
        final defaultRef = FirebaseStorage.instance.ref().child(
          "UsersProfileImages/user_def_default.jpg",
        );

        try {
          imageUrl = await defaultRef.getDownloadURL();
        } catch (e) {
          final byteData = await rootBundle.load('assets/user_icon.png');
          final buffer = byteData.buffer.asUint8List();
          await defaultRef.putData(buffer);
          imageUrl = await defaultRef.getDownloadURL();
        }

        imageType = "default";
      }

      final progressFuture = _simulateProgress();

      await FirebaseFirestore.instance.collection("user").doc(userId).set({
        'username': _usernameController.text.trim(),
        'unlock_pin': _pinController.text.trim(),
        'profile_img_path': imageUrl,
        'profile_img_type': imageType,
      }, SetOptions(merge: true));

      await progressFuture;

      if (mounted) {
        CustomMessage.show(
          context: context,
          message: "Profile Created Successfully!",
          type: MessageType.success,
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          SlideFadePageRoute(page: const LoginProcess()),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomMessage.show(
          context: context,
          message: "Failed to create profile: ${e.toString()}",
          type: MessageType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
          _progress = 0.0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: const Color(0xFF020912),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF020912),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/logo/cine_fetch_logo_tr.png",
                          width: 100,
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: isLoading
                                      ? Container(
                                          width: 140,
                                          height: 140,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(
                                              255,
                                              108,
                                              160,
                                              184,
                                            ),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : _profileImage != null
                                      ? ClipOval(
                                          child: Image.file(
                                            _profileImage!,
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          "assets/user_icon.png",
                                          width: 140,
                                          height: 140,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(18),
                                          ),
                                        ),
                                        builder: (context) => SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.photo_camera,
                                                  color: Colors.blue,
                                                ),
                                                title: const Text(
                                                  'Take a photo',
                                                ),
                                                onTap: () => _pickImage(
                                                  ImageSource.camera,
                                                ),
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.photo_library,
                                                  color: Colors.blue,
                                                ),
                                                title: const Text(
                                                  'Choose from gallery',
                                                ),
                                                onTap: () => _pickImage(
                                                  ImageSource.gallery,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Image.asset(
                                          "assets/plus.png",
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25.0),
                            MyTextField(
                              controller: _usernameController,
                              hinttext: "Username",
                              obsecuretext: false,
                              suffixIcon: false,
                            ),
                            const SizedBox(height: 20.0),
                            MyPinTextField(
                              controller: _pinController,
                              textfieldinfo:
                                  "** create your account key to unlock for emergency moments.!",
                              hinttext: "Unlock-PIN",
                              obsecuretext: true,
                              suffixIcon: true,
                            ),
                            const SizedBox(height: 40.0),
                            if (_isCreating) ...[
                              LinearProgressIndicator(
                                value: _progress,
                                minHeight: 8,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF1A73E8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Creating...  ${(100 * _progress).toInt()}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ] else
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _startProfileCreation,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A73E8),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 24.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "CREATE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
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
