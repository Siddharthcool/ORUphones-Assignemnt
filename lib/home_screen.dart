import 'package:assignment/Widgets/appbar.dart';
import 'package:assignment/Widgets/banner.dart';
import 'package:assignment/Widgets/circular_items.dart';
import 'package:assignment/Widgets/get_notified.dart';
import 'package:assignment/Widgets/top_brands.dart';
import 'package:assignment/model/homeview_model.dart';
import 'package:assignment/Widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeScreen extends StackedView<HomeViewModel> {
  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: CustomAppBar(
      viewModel: viewModel,
      categories: ["Sell Used Phones", 
      "Buy Used Phones", 
      "Compare Prices", 
      "My Profile", 
      "My Listing",
      "Services",
      "Register your Store",
      "Get the App"],
    ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search phone with make, model...',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('|', style: TextStyle(fontSize: 20)),
                      Icon(Icons.mic)
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
             BannerWidget(bannerImages: [
            'lib/images/oru.png',
            'lib/images/oru.png',
            'lib/images/oru.png',
            'lib/images/oru.png',
            'lib/images/oru.png',
          ]),
          SizedBox(height: 5),
          CircleItemsWidget(
            circleItems: [
              {"text": "Buy used phones", "icon": Icons.shopping_cart},
              {"text": "Sell used phones", "icon": Icons.sell},
              {"text": "Compare prices", "icon": Icons.compare},
              {"text": "My profile", "icon": Icons.person},
              {"text": "My listings", "icon": Icons.list},
              {"text": "Open store", "icon": Icons.store},
              {"text": "Services", "icon": Icons.build},
              {"text": "Device health check", "icon": Icons.health_and_safety},
              {"text": "Battery health check", "icon": Icons.battery_full},
              {"text": "IMEI verification", "icon": Icons.verified},
              {"text": "Device details", "icon": Icons.info},
              {"text": "Data wipe", "icon": Icons.delete},
              {"text": "Underworld phones", "icon": Icons.phone_android},
              {"text": "Premium phones", "icon": Icons.star},
              {"text": "Like new phones", "icon": Icons.thumb_up},
              {"text": "Refurbished phones", "icon": Icons.replay},
              {"text": "Verified phones", "icon": Icons.verified_user},
              {"text": "My negotiation", "icon": Icons.handshake},
              {"text": "My favourite", "icon": Icons.favorite},
            ],
          ),
          TopBrandsWidget(
            brandLogos: [
              'lib/images/apple.png',
              'lib/images/google.png',
              'lib/images/honor.png',
              'lib/images/hauwie.png',
              'lib/images/infinix.png',
              'lib/images/lenovo.png',
            ],
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Text(
                "Best deals in India",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  _buildSortFilterButton(Icons.sort, "Sort"),
                  SizedBox(width: 8),
                  _buildSortFilterButton(Icons.filter_list, "Filter"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return ProductCard(
                    imageUrl: 'lib/images/oru.png',
                    title: 'iPhone 13 Pro',
                    specs: '128GB | 6GB RAM',
                    condition: 'Like New',
                    price: '₹65,000',
                    location: 'Mumbai, India',
                  );
                },
              ),
            ),
            GetNotifiedSection(),
            
            Container(
              color: Colors.green[900],
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Download App",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset('lib/images/oru.png', height: 80),
                          SizedBox(height: 5),
                          Image.asset('lib/images/playstore.png', height: 40),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Image.asset('lib/images/oru.png', height: 80),
                          SizedBox(height: 5),
                          Image.asset('lib/images/apple store.png', height: 40),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Invite a Friend",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: 280,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Invite a friend to ORUphones application.\nTap to copy the link to download",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10), // Space between text and image
                        Image.asset(
                          "lib/images/store.png", // Replace with your image URL
                          height: 100, // Adjust height as needed
                          width: 100, // Adjust width as needed
                          
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortFilterButton(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
