import 'package:flutter/material.dart';

class FAQSection extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "How do I buy a used phone?",
      "answer":
          "You can browse listings, check the specifications, and contact the seller through the app."
    },
    {
      "question": "Are the phones verified?",
      "answer":
          "Yes, ORUverified listings are checked for quality and authenticity before approval."
    },
    {
      "question": "Can I return a purchased phone?",
      "answer":
          "Returns depend on the seller's policy. Please review the listing details before purchasing."
    },
    {
      "question": "How do I sell my phone?",
      "answer":
          "Go to the 'Sell Used Phones' section, enter your phone details, and upload images."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: faqs.map((faq) {
              return ExpansionTile(
                title: Text(
                  faq["question"]!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                    child: Text(
                      faq["answer"]!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
        ],
      ),
    );
  }
}
