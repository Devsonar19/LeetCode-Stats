import 'package:flutter/material.dart';
import '../../../models/contest/contest.dart';
import 'contest_detail_view.dart';

class ContestCard extends StatelessWidget {
  final Contest contest;
  final Map<String, dynamic>? ranking;
  const ContestCard({super.key, required this.contest, this.ranking});

  String getStatus(){
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if(now < contest.startTime) return "Upcoming";
    if(now > contest.startTime + contest.duration) return "Ended";

    return "Live";
  }

  String formatTime(){
    final date = DateTime.fromMillisecondsSinceEpoch(contest.startTime * 1000);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    final status = getStatus();
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContestDetailView(contest: contest),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow:[
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 10,
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.20)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(ranking != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _showStat(
                    "Rating",
                      (ranking!["rating"] as num)?.toStringAsFixed(0) ?? "-",
                  ),
                  _showStat(
                    "Ranking",
                      "#${ranking!["globalRanking"] ?? "-"}",
                  ),
                ],
              ),
                const SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _showStat(
                      "Top %",
                      "${(ranking!["topPercentage"] as num?)?.toStringAsFixed(2) ?? "-"}%",
                    ),
                    _showStat(
                      "Contest",
                      "${ranking!["attendedContestsCount"] ?? "-"}",
                    ),
                  ]
                ),

                const SizedBox(height: 10,),
                const Divider(),
                const SizedBox(height: 10,),
            ],

            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.orange,
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contest.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(formatTime()),
                    ],
                  ),
                ),

                Chip(label: Text(getStatus()))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
