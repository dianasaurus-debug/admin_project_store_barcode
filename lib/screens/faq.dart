
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/accordion.dart';


class BantuanPage extends StatefulWidget {
  @override
  _BantuanPageState createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: kPrimaryLightColor, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title:Text('FAQ (Bantuan)', style: TextStyle(color: Colors.black, fontSize : 20),),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
              Accordion('Cara Order',
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam bibendum ornare vulputate. Curabitur faucibus condimentum purus quis tristique.',
                Icon(Icons.shopping_cart,
                    color: kPrimaryColor),),
              Accordion('Syarat dan ketentuan',
                'Fusce ex mi, commodo ut bibendum sit amet, faucibus ac felis. Nullam vel accumsan turpis, quis pretium ipsum. Pellentesque tristique, diam at congue viverra, neque dolor suscipit justo, vitae elementum leo sem vel ipsum',
                Icon(Icons.list,
                    color: kPrimaryColor),),
              Accordion('Contact Person',
                'Nulla facilisi. Donec a bibendum metus. Fusce tristique ex lacus, ac finibus quam semper eu. Ut maximus, enim eu ornare fringilla, metus neque luctus est, rutrum accumsan nibh ipsum in erat. Morbi tristique accumsan odio quis luctus.',
                Icon(Icons.shopping_cart,
                    color: kPrimaryColor),),
            ])
        )
    );
  }
}
