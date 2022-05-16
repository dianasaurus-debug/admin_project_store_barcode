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