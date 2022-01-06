// import 'package:darurat_app/login_pemilik_kos.dart';
// import 'package:darurat_app/register_pemilik_kos.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:ghulam_app/pencarian.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';

class FavoritPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FavoritPageState();
}
class FavoritPageState extends State<FavoritPage> {
  Widget build(BuildContext context) {


    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.black,
      padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
      primary: Color(0xfff5c32b),
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30,90,30,15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Favorit', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 25),
            //element
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child:
                          Image(image: AssetImage('images/sample_kos.jpeg'),fit: BoxFit.cover,)
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text('Putra', style: TextStyle(color: Colors.black)),
                      ),
                      Text('Kost keputih Tipe B'),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size:20),
                          Text('Sukolilo')
                        ],
                      ),
                      Row(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Rp 600000',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              children: const <TextSpan>[
                                TextSpan(text: ' / Bulan', style: TextStyle(fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 3),

                          Row(
                            children: [
                              Icon(Icons.star, size:20,color: Color(0xfff5c32b),),
                              Text('5.0')
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
            //space
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child:
                          Image(image: AssetImage('images/sample_kos.jpeg'),fit: BoxFit.cover,)
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: Text('Putra', style: TextStyle(color: Colors.black)),
                        ),
                        Text('Kost keputih Tipe B'),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size:20),
                            Text('Sukolilo')
                          ],
                        ),
                        Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Rp 600000',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                children: const <TextSpan>[
                                  TextSpan(text: ' / Bulan', style: TextStyle(fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 3),

                            Row(
                              children: [
                                Icon(Icons.star, size:20,color: Color(0xfff5c32b),),
                                Text('5.0')
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ],
            ),
            //space
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child:
                          Image(image: AssetImage('images/sample_kos.jpeg'),fit: BoxFit.cover,)
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: Text('Putra', style: TextStyle(color: Colors.black)),
                        ),
                        Text('Kost keputih Tipe B'),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size:20),
                            Text('Sukolilo')
                          ],
                        ),
                        Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Rp 600000',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                children: const <TextSpan>[
                                  TextSpan(text: ' / Bulan', style: TextStyle(fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 3),

                            Row(
                              children: [
                                Icon(Icons.star, size:20,color: Color(0xfff5c32b),),
                                Text('5.0')
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ],
            ),
            //space
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child:
                          Image(image: AssetImage('images/sample_kos.jpeg'),fit: BoxFit.cover,)
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: Text('Putra', style: TextStyle(color: Colors.black)),
                        ),
                        Text('Kost keputih Tipe B'),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size:20),
                            Text('Sukolilo')
                          ],
                        ),
                        Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Rp 600000',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                children: const <TextSpan>[
                                  TextSpan(text: ' / Bulan', style: TextStyle(fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 3),

                            Row(
                              children: [
                                Icon(Icons.star, size:20,color: Color(0xfff5c32b),),
                                Text('5.0')
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ],
            ),
            //space
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child:
                          Image(image: AssetImage('images/sample_kos.jpeg'),fit: BoxFit.cover,)
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: Text('Putra', style: TextStyle(color: Colors.black)),
                        ),
                        Text('Kost keputih Tipe B'),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size:20),
                            Text('Sukolilo')
                          ],
                        ),
                        Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Rp 600000',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                children: const <TextSpan>[
                                  TextSpan(text: ' / Bulan', style: TextStyle(fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 3),

                            Row(
                              children: [
                                Icon(Icons.star, size:20,color: Color(0xfff5c32b),),
                                Text('5.0')
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(current : 1),
    );
  }
}
