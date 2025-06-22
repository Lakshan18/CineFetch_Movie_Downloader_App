// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class SidePanel extends StatefulWidget {
//   final VoidCallback onClose;

//   const SidePanel({super.key, required this.onClose});

//   @override
//   State<SidePanel> createState() => _SidePanelState();
// }

// class _SidePanelState extends State<SidePanel> {
//   String? username;
//   String? profileImageUrl;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // Get username from Firestore
//       final userDoc = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(user.uid)
//           .get();

//       setState(() {
//         username = userDoc.data()?['username'] ?? 'Guest';
//       });

//       // Get profile image from Storage
//       try {
//         final storageRef = FirebaseStorage.instance.ref().child(
//           'UsersProfileImages/user_upd_${user.uid}.jpg',
//         );

//         final url = await storageRef.getDownloadURL();
//         setState(() {
//           profileImageUrl = url;
//           isLoading = false;
//         });
//       } catch (e) {
//         // If custom image doesn't exist, use default
//         final defaultRef = FirebaseStorage.instance.ref().child(
//           'UsersProfileImages/user_def_default.jpg',
//         );
//         final defaultUrl = await defaultRef.getDownloadURL();
//         setState(() {
//           profileImageUrl = defaultUrl;
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() async {
//         isLoading = false;
//         username = 'Guest';
//         final defaultRef = FirebaseStorage.instance.ref().child(
//           'UsersProfileImages/user_def_default.jpg',
//         );
//         final defaultUrl = await defaultRef.getDownloadURL();

//         profileImageUrl = defaultUrl;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: const Color.fromARGB(255, 3, 17, 34),
//       child: Column(
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 3, 17, 34),
//             ),
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey[800],
//                         child: ClipOval(
//                           child: CachedNetworkImage(
//                             imageUrl: profileImageUrl!,
//                             placeholder: (context, url) =>
//                                 const CircularProgressIndicator(),
//                             errorWidget: (context, url, error) => const Icon(
//                               Icons.person,
//                               size: 40,
//                               color: Colors.white,
//                             ),
//                             fit: BoxFit.cover,
//                             width: 80,
//                             height: 80,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         username ?? 'Guest',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'Your Movie Companion',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                           fontFamily: "Quicksand",
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings, color: Colors.white),
//             title: const Text(
//               'Settings',
//               style: TextStyle(color: Colors.white),
//             ),
//             onTap: () {
//               widget.onClose();
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.info, color: Colors.white),
//             title: const Text('About', style: TextStyle(color: Colors.white)),
//             onTap: () {
//               widget.onClose();
//               showAboutDialog(
//                 context: context,
//                 applicationName: 'CineFetch',
//                 applicationVersion: '1.0.0',
//               );
//             },
//           ),
//           const Divider(color: Colors.white24),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.white),
//             title: const Text('Logout', style: TextStyle(color: Colors.white)),
//             onTap: () {
//               widget.onClose();
//             },
//           ),
//           const Spacer(),
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Version 1.0.0',
//               style: TextStyle(color: Colors.white54, fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cinefetch_app/screens/login_screen.dart';
import 'package:cinefetch_app/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SidePanel extends StatefulWidget {
  final VoidCallback onClose;

  const SidePanel({super.key, required this.onClose});

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  String? username;
  String? email;
  String? profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      setState(() {
        username = userDoc.data()?['username'] ?? 'Guest';
        email = user.email;
      });

      try {
        final storageRef = FirebaseStorage.instance.ref().child(
          'UsersProfileImages/user_upd_${user.uid}.jpg',
        );
        final url = await storageRef.getDownloadURL();
        setState(() => profileImageUrl = url);
      } catch (e) {
        final defaultRef = FirebaseStorage.instance.ref().child(
          'UsersProfileImages/user_def_default.jpg',
        );
        final defaultUrl = await defaultRef.getDownloadURL();
        setState(() => profileImageUrl = defaultUrl);
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: const Color.fromARGB(255, 2, 15, 34),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 15, 34),
              border: Border(
                bottom: BorderSide(color: Colors.blue[800]!, width: 1),
              ),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue[900],
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profileImageUrl ?? '',
                            placeholder: (context, url) => const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        username ?? 'Guest',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (email != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          email!,
                          style: TextStyle(
                            color: Colors.blue[200],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('Browse'),
                _buildMenuItem(Icons.search, 'Search', onTap: () {}),
                _buildMenuItem(Icons.filter_alt, 'Filter', onTap: () {}),

                _buildSectionHeader('Library'),
                _buildMenuItem(Icons.download, 'Downloads', onTap: () {}),
                _buildMenuItem(Icons.bookmark, 'Watchlist', onTap: () {}),
                _buildMenuItem(Icons.history, 'History', onTap: () {}),
                _buildMenuItem(Icons.favorite, 'Favorites', onTap: () {}),

                _buildSectionHeader('Quality'),
                _buildMenuItem(
                  Icons.hd,
                  'HD Only',
                  onTap: () {},
                  trailing: Switch(
                    value: false,
                    activeColor: Colors.blue,
                    onChanged: (v) {},
                  ),
                ),
                _buildMenuItem(
                  Icons.speed,
                  'Data Saver',
                  onTap: () {},
                  trailing: Switch(value: false, onChanged: (v) {}),
                ),

                _buildSectionHeader('Account'),
                _buildMenuItem(
                  Icons.settings,
                  'Settings',
                  onTap: () {
                    widget.onClose();
                  },
                ),
                _buildMenuItem(Icons.help, 'Help & Support', onTap: () {}),
                _buildMenuItem(
                  Icons.info,
                  'About',
                  onTap: () {
                    widget.onClose();
                    showAboutDialog(
                      context: context,
                      applicationName: 'CineFetch',
                      applicationVersion: '1.0.0',
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.logout,
                  'Logout',
                  onTap: () async {
                    await SessionManager.clearSession();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginProcess()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.blue[800]!, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.blue[200], fontSize: 12),
                ),
                Text(
                  '© 2025 Captain',
                  style: TextStyle(color: Colors.blue[200], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue[300],
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 24),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      minLeadingWidth: 30,
    );
  }
}
