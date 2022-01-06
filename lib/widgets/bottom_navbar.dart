import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghulam_app/daftar_favorit.dart';
import 'package:ghulam_app/pencarian.dart';
import 'package:ghulam_app/utils/constants.dart';

class BottomNavbar extends StatelessWidget {
  final int current;
  BottomNavbar({Key? key, required this.current}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPrimaryLightColor,
      unselectedItemColor: kPrimaryColor,
      currentIndex: current,
      onTap: (value) {
        switch (value) {
          case 0:
            Route route = MaterialPageRoute(
                builder: (context) => PencarianPage());
            Navigator.push(context, route);
            break;
          case 1:
            Route route = MaterialPageRoute(
                builder: (context) => FavoritPage());
            Navigator.push(context, route);
            break;
          case 2:
            Route route = MaterialPageRoute(
                builder: (context) => FavoritPage());
            Navigator.push(context, route);
            break;
          case 3:
            Route route = MaterialPageRoute(
                builder: (context) => FavoritPage());
            Navigator.push(context, route);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.search, size: 35),
        ),
        BottomNavigationBarItem(
          title: Text('Cart'),
          icon: Icon(Icons.shopping_cart,  size: 35),
        ),
        BottomNavigationBarItem(
          title: Text('Histori'),
          icon: Icon(Icons.calendar_today_sharp,  size: 35),
        ),
        BottomNavigationBarItem(
          title: Text('Profil'),
          icon: Icon(Icons.person_outline_outlined,  size: 35),
        ),
      ],
    );
  }
}