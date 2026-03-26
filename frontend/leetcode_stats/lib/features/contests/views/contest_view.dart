import 'package:flutter/material.dart';

import 'contest_card.dart';

class ContestView extends StatelessWidget {
  final List contest;
  const ContestView({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contests"),
        centerTitle: true,
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return ContestCard(contest: contest[index]);
          },
          separatorBuilder: (_,_) => const Divider(thickness: 5,),
          itemCount: contest.length,
      ),
    );
  }
}
