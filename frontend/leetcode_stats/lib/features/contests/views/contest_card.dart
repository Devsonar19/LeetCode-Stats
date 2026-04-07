import 'package:flutter/material.dart';
import '../../../models/contest/contest.dart';
import 'contest_detail_view.dart';

class ContestCard extends StatelessWidget {
  final Contest contest;
  final Map<String, dynamic>? ranking;

  const ContestCard({super.key, required this.contest, this.ranking});

  String getStatus() {
    final now = DateTime
        .now()
        .millisecondsSinceEpoch ~/ 1000;

    if (now < contest.startTime) return "Upcoming";
    if (now > contest.startTime + contest.duration) return "Ended";

    return "Live";
  }

  String formatTime() {
    final date = DateTime.fromMillisecondsSinceEpoch(contest.startTime * 1000);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContestDetailView(contest: contest),
          ),
        );
      },
      hoverColor: Colors.transparent,

      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .cardColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 10,
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.20)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(ranking != null && ranking!.isNotEmpty) ...[
              _showPerformance(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
              ),
              _showMiddle(),
              // Full Width Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
              ),
            ],

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _showPerformance(){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GLOBAL PERFORMANCE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    "Rating ",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.teal
                    ),
                  ),
                  Text(
                    (ranking?["rating"] as num?)?.toStringAsFixed(0) ?? "-",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.teal
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Top Percentage Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFDCECE8), // Light teal background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              ranking?["topPercentage"] != null
                  ? "Top ${(ranking?["topPercentage"] as num?)?.toStringAsFixed(2) ?? "-"}%"
                  : "Unranked",
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showMiddle(){
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // World Rank
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "WORLD RANK",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "#${ranking?["globalRanking"] ?? ranking?["ranking"] ?? "-"}", // Fallbacks for ranking keys
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.teal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contests
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "CONTESTS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${ranking?["attendedContestsCount"] ?? "-"}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.teal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}