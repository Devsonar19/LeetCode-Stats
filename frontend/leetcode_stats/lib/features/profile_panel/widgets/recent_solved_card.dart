import 'package:flutter/material.dart';

class RecentSolvedCard extends StatelessWidget {
  final List ques;
  const RecentSolvedCard({
    super.key,
    required this.ques,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Recently Solved",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 15,),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ques.length > 5 ? 5 : ques.length,

              itemBuilder: (context, i) {

                final q = ques[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    children: [

                      Expanded(
                        child: Text(
                          q["title"] ?? "Unknown Question",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}