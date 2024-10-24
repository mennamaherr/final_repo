class Booking {
  String? serviceName;
  String? serviceImage;
  DateTime? bookingDateTime;

  Booking(
      {required this.serviceName,
      required this.serviceImage,
      required this.bookingDateTime});

  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'serviceImage': serviceImage,
      'bookingDateTime': bookingDateTime!.toIso8601String(),
    };
  }
}
