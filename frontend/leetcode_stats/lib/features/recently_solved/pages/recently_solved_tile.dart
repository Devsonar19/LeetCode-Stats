import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentlySolvedTile extends StatelessWidget {
  final dynamic item;
  final bool isDisabled;
  const RecentlySolvedTile({super.key, this.item, this.isDisabled = false});

  String formatTime(int timestamp){
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.day}-${date.month}-${date.year}";
  }

  void openProblem(String slug)async{
    final url = "https://leetcode.com/problems/$slug";
    await launchUrl(Uri.parse(url));
  }


  @override
  Widget build(BuildContext context) {
    final title = item["title"] ?? "Unknown";
    final slug = item["slug"] ?? "";
    final timestamp = int.tryParse(item["timestamp"].toString()) ?? 0;

    if(item.isEmpty){
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 0),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.lock_outline,
              color: Colors.grey.shade500,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Recently solved questions are private",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }


    return InkWell(
      onTap: () => openProblem(slug),
      borderRadius: BorderRadius.circular(20),

      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 0),
            )
          ],
        ),

        child: Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      formatTime(timestamp),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      )
                    )

                  ],
                )
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 15,),
            ),
          ],
        ),
      ),
    );
  }
}
