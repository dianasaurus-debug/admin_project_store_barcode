import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghulam_app/screens/beranda.dart';
import 'package:ghulam_app/screens/daftar_favorit.dart';
import 'package:ghulam_app/screens/history.dart';
import 'package:ghulam_app/screens/profile.dart';
import 'package:ghulam_app/screens/scan_page.dart';
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
      showUnselectedLabels: false,
      onTap: (value) {
        switch (value) {
          case 0:
            Route route = MaterialPageRoute(
                builder: (context) => HomePage());
            Navigator.push(context, route);
            break;
          case 1:
            Route route = MaterialPageRoute(
                builder: (context) => ScanPage());
            Navigator.push(context, route);
            break;
          case 2:
            Route route = MaterialPageRoute(
                builder: (context) => HistoryPage());
            Navigator.push(context, route);
            break;
          case 3:
            Route route = MaterialPageRoute(
                builder: (context) => ProfilePage());
            Navigator.push(context, route);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home, size: 25),
        ),
        BottomNavigationBarItem(
          label: 'Scan',
          icon: Icon(Icons.qr_code_scanner,  size: 25),
        ),
        BottomNavigationBarItem(
          label: 'Histori',
          icon: Icon(Icons.calendar_today_sharp,  size: 25),
        ),
        BottomNavigationBarItem(
          label: 'Profil',
          icon: Icon(Icons.person_outline_outlined,  size: 25),
        ),
      ],
    );
  }
}