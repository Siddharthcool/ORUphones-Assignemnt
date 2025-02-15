import 'package:flutter/material.dart';
import 'package:assignment/model/homeview_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeViewModel viewModel;
  final List<String> categories;

  CustomAppBar({required this.viewModel, required this.categories});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset('lib/images/oru.png', height: 40),
      ),
      actions: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text('India', style: TextStyle(fontSize: 16)),
                  Icon(Icons.location_on, size: 20),
                ],
              ),
            ),
            viewModel.user != null
                ? IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () => viewModel.logout(context),
                  )
                : IconButton(
                    icon: Icon(Icons.login),
                    onPressed: () => viewModel.navigateToLogin(context),
                  ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(90);
}
