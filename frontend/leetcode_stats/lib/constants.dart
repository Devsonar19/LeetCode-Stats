import 'package:flutter/material.dart';

var defaultAppBar = AppBar(
  backgroundColor: Colors.deepPurple.shade900,
  title: const Text(
  "LeetCode Stats Mobile",
  style: TextStyle(
  color: Colors.white,
  )
  ),
  centerTitle: true,
);

var defaultDrawer = Drawer(
  backgroundColor: Colors.grey.shade600,
  child: Column(
      children: [
        DrawerHeader(child: Icon(Icons.favorite_border_rounded))
      ]
  ),
);

var defaultBackgroundColor = Colors.deepPurple.shade200;