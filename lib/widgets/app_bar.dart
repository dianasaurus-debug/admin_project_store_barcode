import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghulam_app/daftar_favorit.dart';
import 'package:ghulam_app/pencarian.dart';

class BottomNavbar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xfff5c32b),
      currentIndex: 0,
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
        }
      },
      items: [
        BottomNavigationBarItem(
          title: Text('Cari'),
          icon: Icon(Icons.search, size: 35),
        ),
        BottomNavigationBarItem(
          title: Text('Favorit'),
          icon: Icon(Icons.favorite_border_outlined,  size: 35),
        ),
        BottomNavigationBarItem(
          title: Text('Booking'),
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