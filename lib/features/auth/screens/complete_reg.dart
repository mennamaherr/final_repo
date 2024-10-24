
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onservice/LogIn%20with%20google/google_auth.dart';
//import '../../logIn_with_google/google_auth.dart';
import 'signInScreen.dart';
class CompleteReg extends StatefulWidget {
  const CompleteReg({super.key});

  @override
  State<CompleteReg> createState() => _CompleteRegState();
}

class _CompleteRegState extends State<CompleteReg> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var formkey = GlobalKey<FormState>();
  String dropdownValue = 'Male';

  String? validatePhone(String value) {
    String pattern = r'^[0-9]{10,15}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return "Phone number must not be empty";
    } else if (!regex.hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  void _completeSignUp() async {
    String adress = addressController.text;
    String phone = phoneController.text;
    User? user = _auth.currentUser;

    if (user != null && adress.isNotEmpty && phone.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'adress': adress,
          'phone': phone,
          'gender': dropdownValue,
        });
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Verification email sent to ${user.email}. Please check your inbox."),
            ),
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
      } catch (e) {
        print("Error completing sign up: $e");
      }
    } else {
      print("Please fill in all fields");
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 0.0,
                left: 30.0,
                bottom: 24.0,
                right: 24.0,
              ),
              child: Column(
                children: [
                  Text(
                    "Complete Your Profile",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Don't worry, only you can see your personal data.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  bottom: 24.0,
                  right: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    const Text("Address"),
                    TextFormField(
                      controller: addressController,
                      style: const TextStyle(fontSize: 14),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter your address",
                        labelText: "Your address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Phone Number"),
                    TextFormField(
                      controller: phoneController,
                      style: const TextStyle(fontSize: 14),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        labelText: "Your phone number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) => validatePhone(value!),
                    ),
                    const SizedBox(height: 20),
                    const Text("Gender"),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: const Color(0xff6759FF),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female', 'other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),

),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _completeSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6759FF),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Complete",
                        style: TextStyle(fontSize: 19, color: Colors.white),
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









// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../../LogIn with google/google_auth.dart';
// import 'signInScreen.dart';



// class CompleteReg extends StatefulWidget {
//   const CompleteReg({super.key});

//   @override
//   State<CompleteReg> createState() => _CompleteRegState();
// }

// class _CompleteRegState extends State<CompleteReg> {
//   final FirebaseAuth _auth=FirebaseAuth.instance;
//   final FirebaseFirestore _firestore=FirebaseFirestore.instance;
//   final AuthService _authService=AuthService();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   var formkey = GlobalKey<FormState>();
//   String dropdownValue = 'Male';

//   void _completeSignUp() async {
//     String adress = addressController.text;
//     String phone = phoneController.text;
//     User? user=_auth.currentUser;

//     if (user !=null && adress.isNotEmpty &&phone.isNotEmpty) {
//       await _firestore.collection('users').doc(user.uid).update({
//         'adress': adress,
//         'phone': phone,
//       });
//       print(emailController.text);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SignInScreen(),
//         ),
//       );

//     } else {
//       print("Please fill in all fields");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(
//                 top: 0.0,
//                 left: 30.0,
//                 bottom: 24.0,
//                 right: 24.0,
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     "Complete Your Profile",
//                     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "Don't worry, only you can see your personal data.",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400, color: Colors.grey
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//             Form(
//               key: formkey,
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 24.0,
//                   bottom: 24.0,
//                   right: 24.0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     SizedBox(
//                       height: 25,
//                     ),
//                     const Text("Address"),
//                     TextFormField(
//                       controller: addressController,
//                       style: const TextStyle(fontSize: 14),
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         hintText: "Enter your address",
//                         labelText: "Your address",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your address';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     const Text("Phone Number"),
//                     TextFormField(
//                       controller: phoneController,
//                       style: const TextStyle(fontSize: 14),
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         hintText: "Enter your phone number",
//                         labelText: "Your phone number",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     const Text("Gender"),
//                     DropdownButton<String>(

//                       isExpanded: true,
//                       value: dropdownValue,
//                       icon: const Icon(Icons.arrow_drop_down_sharp),
//                       iconSize: 24,
//                       elevation: 16,
//                       style: const TextStyle(color: Colors.black),
//                       underline: Container(
//                         height: 2,
//                         color: const Color(0xff6759FF),
//                       ),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                       items: <String>['Male', 'Female', 'Other']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),

//                     const SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: ()async {
//                         _completeSignUp();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xff6759FF),
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                       child: const Text(
//                         "Complete",
//                         style: TextStyle(fontSize: 19, color: Colors.white),
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

