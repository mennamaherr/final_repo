import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onservice/screens/menu_page.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  // الحصول على userId الخاص بالمستخدم الحالي
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    String? userId = getCurrentUserId();

    if (userId == null) {
      return Scaffold(
        body: const Center(
          child: Text('Please log in to view your bookings'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(width: 12),
                      const Text(
                        'Bookings',
                        style: TextStyle(fontSize: 24, fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // StreamBuilder لجلب البيانات من Firestore
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('appointments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error fetching bookings'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No bookings found.'));
                      }

                      final bookingDocs = snapshot.data!.docs;

                      return Column(
                        children: bookingDocs.map((doc) {
                          var bookingData = doc.data() as Map<String, dynamic>;
                          DateTime bookingDateTime =
                              DateTime.parse(bookingData['date']);
                          String serviceImage =
                              bookingData['serviceImageUrl']; // الصورة المحفوظة
                          String serviceName = bookingData['serviceName'];

                          return BookingdetailsWidget(
                            dateTime: bookingDateTime,
                            serviceImageUrl: serviceImage,
                            bookingDoc: doc,
                            serviceName: serviceName,
                            // تمرير الصورة
                          );
                        }).toList(),
                      );
                    },
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

class BookingdetailsWidget extends StatelessWidget {
  final DateTime? dateTime;
  final String? serviceImageUrl;
  final DocumentSnapshot bookingDoc; // لتحديد المستند الخاص بالحجز
  final String? serviceName;
  const BookingdetailsWidget({
    super.key,
    required this.dateTime,
    required this.serviceImageUrl,
    required this.bookingDoc,
    required this.serviceName,
  });

  // حذف الحجز من Firestore
  Future<void> deleteBooking(BuildContext context) async {
    await bookingDoc.reference.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking canceled successfully')),
    );
  }

  // تعديل الحجز عن طريق عرض AwesomeDialog
  void editBooking(BuildContext context) {
    DateTime selectedDate = dateTime ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(dateTime ?? DateTime.now());

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      title: 'Edit Booking',
      body: Column(
        children: [
          // اختيار التاريخ
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2024),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                selectedDate = pickedDate;
              }
            },
            child: Text('Select Date: ${selectedDate.toLocal()}'),
          ),
          // اختيار الوقت
          ElevatedButton(
            onPressed: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (pickedTime != null) {
                selectedTime = pickedTime;
              }
            },
            child: Text('Select Time: ${selectedTime.format(context)}'),
          ),
        ],
      ),
      btnOkOnPress: () async {
        // تحديث التاريخ والوقت في Firestore
        final newDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        await bookingDoc.reference.update({
          'date': newDateTime.toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking updated successfully')),
        );
      },
      btnCancelOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$serviceName'??'Selected Service',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  dateTime != null
                      ? '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'
                      : 'null-null-null',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                Icon(Icons.access_time, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  dateTime != null
                      ? '${dateTime!.hour}:${dateTime!.minute}'
                      : 'null:null',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(serviceImageUrl!) ??
                      NetworkImage(
                          'https://superdevresources.com/wp-content/uploads/2023/04/home-services-app.jpg'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => deleteBooking(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => editBooking(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
