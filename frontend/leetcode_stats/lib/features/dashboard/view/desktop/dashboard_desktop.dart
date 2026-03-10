import 'package:flutter/material.dart';

class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Row(

        children: [

          Container(
            width: 250,
            color: Colors.grey.shade200,
            child: const Center(child: Text("Sidebar")),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              child: const Center(child: Text("Dashboard Content")),
            ),
          )

        ],
      ),
    );
  }
}