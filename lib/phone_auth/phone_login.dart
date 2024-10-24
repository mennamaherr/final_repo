import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otp_screen.dart';


class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({super.key});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  TextEditingController phoneController = TextEditingController();
  bool isLoadin = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () {
          myDialogBox(context);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Image.network(
                "https://static.vecteezy.com/system/resources/thumbnails/010/829/986/small/phone-icon-in-trendy-flat-style-free-png.png",
                height: 32,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 30),
            const Text(
              "Sign in with Phone",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  void myDialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      const Text(
                        "Phone Authentication",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "+207123456789",
                      labelText: "Enter the Phone Number",
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoadin
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6759FF)),
                      onPressed: () async {
                        setState(() {
                          isLoadin = true;
                        });
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phoneController.text,
                          verificationCompleted: (phoneAuthCredential) {},
                          verificationFailed: (error) {
                            print(error);
                          },
                          codeSent: (verificationId, forceResendingToken) {
                            setState(() {
                              isLoadin = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                  verificationId: verificationId,
                                ),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (verificationId) {},
                        );
                      },
                      child: const Text(
                        "Send Code",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
          );
        });
  }
}