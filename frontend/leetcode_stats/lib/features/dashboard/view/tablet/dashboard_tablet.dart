import 'package:flutter/material.dart';

class DashboardTablet extends StatelessWidget {
  const DashboardTablet({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("LeetCode Stats"),
      ),

      body: Row(
        children: [

          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: const Center(child: Text("Left Panel")),
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              child: const Center(child: Text("Stats Section")),
            ),
          )

        ],
      ),
    );
  }
}