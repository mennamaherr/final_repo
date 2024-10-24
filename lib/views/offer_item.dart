import 'package:flutter/material.dart';
import 'package:onservice/models/OfferModel.dart';
import 'package:onservice/views/OffersListView.dart';

class OfferItem extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onTap;

  const OfferItem({required this.offer, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        height: 200, // Set the height of the container to 200
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Row(
          children: [
            // Left half for the text
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center vertically
                  children: [
                    // "Appliance Repair" title (or dynamic category)
                    Row(
                      children: [
                        Text(
                          offer.offerName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        // Info icon
                        InfoIcon(offer: offer)
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    // Main offer text "Get 25%"
                    Text(
                      "Get ${offer.offerAmount}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // "Grab Offer" button
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Grab Offer'),
                    ),
                  ],
                ),
              ),
            ),
            // Right half for the image
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                child: Image.network(
                  offer.image,
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
