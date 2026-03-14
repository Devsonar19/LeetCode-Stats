import 'package:flutter/material.dart';

class RecentSolvedCard extends StatelessWidget {
  final List ques;
  const RecentSolvedCard({super.key, required this.ques});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08)
          )
        ]
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Recent Solved",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),

          // const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ques.length > 5 ? 5 : ques.length,
              itemBuilder: (context, index){
                final q = ques[index];
                return ListTile(
                  title: Text(
                      q["title"] ?? "Error in Title",
                  ),
                  subtitle: Text(q["difficulty"] ?? ""),
                );
              }
          ),
        ]
      ),
    );
  }
}
