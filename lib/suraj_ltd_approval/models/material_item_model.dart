import 'package:flutter/material.dart';

class MaterialItem {
  final String title;
  final IconData icon;
  String? route;
  bool? isDialog;

  MaterialItem(this.title, this.icon, {this.route, this.isDialog});
}
