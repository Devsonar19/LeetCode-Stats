import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyQuestionCard extends StatelessWidget {
  final Map<String, dynamic>? question;
  const DailyQuestionCard({super.key, required this.question});


  void openUrl(String url) {
    if(!url.startsWith("http")){
      url = "https://leetcode.com$url";
    }
    launchUrl(Uri.parse(url),);
  }

  //using leetcode's colors
  Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF00B8A3);
      case 'medium':
        return const Color(0xFFFFC01E);
      case 'hard':
        return const Color(0xFFFF375F);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = question?["question"]["title"] ?? "Error";
    final date = question?["date"] ?? "Error";
    final difficulty = question?["question"]["difficulty"] ?? "Error";
    final url = question?["link"] ?? "Error";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "TODAY'S QUESTION",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Colors.brown.shade500,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: getDifficultyColor(difficulty),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  difficulty.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Date: $date",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => openUrl(url),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A97F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "SOLVE CHALLENGE",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
