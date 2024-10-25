  
   
   import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onservice/features/auth/screens/signInScreen.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      setState(() {
        userData = doc.data();
      });
    }
  }
  Future<void> signOutUser(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            UserHeader(
              name: userData!['username'] ?? 'No Name',
              imagePath: userData!['image']?? 'assets/default/default_image.jpg',
            ),
            const SizedBox(height: 20),
            UserInfoField(
              iconData: Icons.phone,
              labelText: 'Phone Number',
              initialValue: userData!['phone'] ?? '',
              onFieldSubmitted: (value) => _updateUserData('phone', value),
            ),
            UserInfoField(
              iconData: Icons.email,
              labelText: 'E-mail',
              initialValue: userData!['email'] ?? '',
              onFieldSubmitted: (value) => _updateUserData('email', value),
            ),
            UserInfoField(
              iconData: Icons.person_outline,
              labelText: 'Gender',
              initialValue: userData!['gender'] ?? '',
              onFieldSubmitted: (value) => _updateUserData('gender', value),
            ),
            UserInfoField(
              iconData: Icons.location_on,
              labelText: 'adress',
              initialValue: userData!['adress'] ?? '',
              onFieldSubmitted: (value) => _updateUserData('adress', value),
            ),
            SizedBox(height: 50,),

            ElevatedButton(
              onPressed: () => signOutUser(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff6759FF),
                minimumSize: Size(double.infinity,
                    50), // Set minimum width and height
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Future<void> _updateUserData(String field, String value) async {
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({field: value});
      _getUserData(); // Refresh the data
    }
  }
}

class UserHeader extends StatelessWidget {
  final String name;
  final String imagePath;

const UserHeader({
    super.key,
    required this.name,
    required this.imagePath,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: imagePath.startsWith('http') // Check if it's a URL
                ? NetworkImage(imagePath) // Use NetworkImage for online images
                : AssetImage(imagePath) as ImageProvider, // Use AssetImage for local images
            onBackgroundImageError: (_, __) => const Icon(Icons.error),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${FirebaseAuth.instance.currentUser!.displayName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${FirebaseAuth.instance.currentUser!.email}',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class UserInfoField extends StatelessWidget {
  final IconData iconData;
  final String labelText;
  final String initialValue;
  final Function(String) onFieldSubmitted; // Callback for updates

  const UserInfoField({
    super.key,
    required this.iconData,
    required this.labelText,
    required this.initialValue,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
    TextEditingController(text: initialValue);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(iconData, color: Color(0xff6759FF)),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none,
                ),
                controller: controller,
                onSubmitted: onFieldSubmitted, // Handle field submission
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String currentPage;
  const CustomAppBar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(currentPage == 'menu' ? 'Menu' : 'AppBar'),
    );
  }
}
   
   
   
   
   
   
   
   
   
   
   
   
   // import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:onservice/features/auth/screens/signInScreen.dart';

// class MenuPage extends StatefulWidget {
//   const MenuPage({super.key});

//   @override
//   _MenuPageState createState() => _MenuPageState();
// }

// class _MenuPageState extends State<MenuPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? user;
//   Map<String, dynamic>? userData;

//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }

//   Future<void> _getUserData() async {
//     user = _auth.currentUser;
//     if (user != null) {
//       final doc = await _firestore.collection('users').doc(user!.uid).get();
//       setState(() {
//         userData = doc.data();
//       });
//     }
//   }

//   Future<void> signOutUser(BuildContext context) async {
//     await _auth.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => SignInScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (userData == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Loading...')),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             const UserHeader(),
//             const SizedBox(height: 20),
//             UserInfoField(
//               iconData: Icons.phone,
//               labelText: 'Phone Number',
//               initialValue: userData!['phone'] ?? '',
//               onFieldSubmitted: (value) => _updateUserData('phone', value),
//             ),
//             UserInfoField(
//               iconData: Icons.email,
//               labelText: 'E-mail',
//               initialValue: userData!['email'] ?? '',
//               onFieldSubmitted: (value) => _updateUserData('email', value),
//             ),
//             UserInfoField(
//               iconData: Icons.person_outline,
//               labelText: 'Gender',
//               initialValue: userData!['gender'] ?? '',
//               onFieldSubmitted: (value) => _updateUserData('gender', value),
//             ),
//             UserInfoField(
//               iconData: Icons.cake,
//               labelText: 'Date of Birth',
//               initialValue: userData!['dob'] ?? '',
//               onFieldSubmitted: (value) => _updateUserData('dob', value),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _updateUserData(String field, String value) async {
//     if (user != null) {
//       await _firestore
//           .collection('users')
//           .doc(user!.uid)
//           .update({field: value});
//       _getUserData(); // Refresh the data
//     }
//   }
// }

// class UserHeader extends StatelessWidget {
//   const UserHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 35,
//             backgroundImage: AssetImage('assets/profile_picture.png'),
//           ),
//           SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('${FirebaseAuth.instance.currentUser!.displayName}',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text('${FirebaseAuth.instance.currentUser!.email}',
//                   style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class UserInfoField extends StatelessWidget {
//   final IconData iconData;
//   final String labelText;
//   final String initialValue;
//   final Function(String) onFieldSubmitted; // Callback for updates

//   const UserInfoField({
//     super.key,
//     required this.iconData,
//     required this.labelText,
//     required this.initialValue,
//     required this.onFieldSubmitted,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController controller =
//         TextEditingController(text: initialValue);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             Icon(iconData, color: Colors.red),
//             const SizedBox(width: 16),
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration(
//                   labelText: labelText,
//                   border: InputBorder.none,
//                 ),
//                 controller: controller,
//                 onSubmitted: onFieldSubmitted, // Handle field submission
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomAppBar extends StatelessWidget {
//   final String currentPage;
//   const CustomAppBar({super.key, required this.currentPage});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(currentPage == 'menu' ? 'Menu' : 'AppBar'),
//     );
//   }
// }
