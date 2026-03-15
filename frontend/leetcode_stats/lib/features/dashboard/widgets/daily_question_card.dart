import 'package:flutter/material.dart';

class DailyQuestionCard extends StatelessWidget {
  final Map<String, dynamic>? question;
  const DailyQuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final title = question?["question"]["title"] ?? "Error";
    final date = question?["date"] ?? "";

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 10,
            offset: const Offset(0,4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Question",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        )
                      ]
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
