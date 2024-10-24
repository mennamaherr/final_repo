import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onservice/screens/appointment_booked.dart';

class ModelBottomSheet extends StatefulWidget {
  const ModelBottomSheet({super.key, required this.image,required this.name});
  final String? image;
  final String? name;
  @override
  State<ModelBottomSheet> createState() => _ModelBottomSheetState();
}

class _ModelBottomSheetState extends State<ModelBottomSheet> {
  DateTime date = DateTime.now();
  TimeOfDay time = const TimeOfDay(hour: 00, minute: 00);
  bool isButtonActive = false;
  String? serviceImageUrl;
  String? nameService;
  // رابط الصورة الخاص بالخدمة

  // وظيفة لحفظ البيانات في Firestore لكل مستخدم
  Future<void> saveDataToFirestore(DateTime dateTime, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // مجموعة المستخدمين
          .doc(userId) // مستند المستخدم الحالي
          .collection('appointments') // مجموعة المواعيد
          .add({
        'date': dateTime.toIso8601String(),
        'serviceImageUrl': serviceImageUrl, // حفظ رابط الصورة
        'timestamp': FieldValue.serverTimestamp(),
        'serviceName': nameService
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment: $e')),
      );
    }
  }

  // الحصول على الـ User ID للمستخدم الذي قام بتسجيل الدخول
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceImageUrl = widget.image;
    nameService = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 20,
                width: 4,
                decoration: BoxDecoration(
                  color: const Color(0xffCABDFF),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 15),
              const Text('Select your Date & time?',
                  style: TextStyle(fontSize: 18, fontFamily: 'Inter'))
            ],
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (newDate != null) {
                setState(() {
                  date = newDate;
                });
              }
            },
            child: selectDateWidget(),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (newTime != null) {
                setState(() {
                  time = newTime;
                  isButtonActive = true;
                });
              }
            },
            child: const SelectTimeWidget(),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                const Icon(Icons.date_range_outlined,
                    size: 22, color: Color.fromARGB(231, 26, 29, 31)),
                Text(
                  '  ${date.day}/${date.month}/${date.year}  ${time.hour}:${time.minute} ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(231, 26, 29, 31),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: 343,
              height: 48,
              child: ElevatedButton(
                onPressed: isButtonActive
                    ? () async {
                        DateTime dateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );

                        // الحصول على الـ userId الحالي
                        String? userId = getCurrentUserId();

                        if (userId != null) {
                          await saveDataToFirestore(dateTime, userId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const AppointmentBooked();
                              },
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'User not logged in. Please log in first.')),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: const Color(0xff6759FF),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: const Text('Book Now'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectDateWidget() {
    return  Container(
        width: 327,
        height: 72,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Color(0xffFFBC99)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.date_range_outlined,
                size: 24,
                color: Color(0xff434355),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATE',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        color: Color(0xff6F767E)),
                  ),
                  Text(
                    'Select your Date',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Inter',
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      

    );
  }
}

class SelectTimeWidget extends StatelessWidget {
  const SelectTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 72,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: const Color(0xffB5E4CA)),
      child:const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.timelapse,
              size: 24,
              color: Color(0xff434355),
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIME',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      color: Color(0xff6F767E)),
                ),
                Text(
                  'Select your Time',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
