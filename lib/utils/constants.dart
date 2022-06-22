import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ghulam_app/models/rekomendasi.dart';

const API_URL = 'https://bestoreghulam.my.id/api';
const IMG_URL = 'https://bestoreghulam.my.id/img/';

const kPrimaryColor = Color(0xFF194739);
const kPrimaryLightColor = Color(0xFF2db861);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF194739), Color(0xFF2db861)],
);
const kSecondaryColor = Color(0xFFacc0c0);
const kTextColor = Color(0xFFd0e2e3);
List<Rekomendasi> list_label_bobot = [
  Rekomendasi('Tidak Penting', 1),
  Rekomendasi('Kurang Penting', 2),
  Rekomendasi('Cukup Penting', 3),
  Rekomendasi('Penting', 4),
  Rekomendasi('Sangat Penting', 5),
];
String textAbout = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s '
    'standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.';
formatBytes(bytes, decimals) {
  if (bytes == 0) return 0.0;
  var k = 1024,
      dm = decimals <= 0 ? 0 : decimals,
      sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
      i = (log(bytes) / log(k)).floor();

  return (((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i]);
}