import 'package:flutter/material.dart';
import 'package:leetcode_stats/features/recently_solved/pages/recently_solved_tile.dart';

class RecentlySolvedView extends StatelessWidget {
  final List recentlySolved;
  const RecentlySolvedView({super.key, required this.recentlySolved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recently Solved"),
        centerTitle: true,
      ),

      body: ListView.separated(
          itemBuilder: (context, index){
            final item = recentlySolved[index];
            return RecentlySolvedTile(item: item);
          },
          separatorBuilder: (_,_) => const SizedBox(height: 10,),
          itemCount: recentlySolved.length,
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
