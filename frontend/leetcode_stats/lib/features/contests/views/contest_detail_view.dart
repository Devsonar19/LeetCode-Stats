import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/contest/contest.dart';

class ContestDetailView extends StatelessWidget {
  final Contest contest;
  const ContestDetailView({super.key, required this.contest});

  String formatTime(){
    final date = DateTime.fromMillisecondsSinceEpoch(contest.startTime * 1000);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  String formatDuration(){
    final hours = contest.duration ~/ 3600;
    final minutes = (contest.duration % 3600) ~/ 60;
    return "${hours}h ${minutes}m";
  }

  Future<void> openContest() async {
    final url = "https://leetcode.com/contest/${contest.slug}";
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contest.title),
        centerTitle: true,
      ),

      body: Padding(
          padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: const Text("Start Time"),
              subtitle: Text(formatTime()),
              trailing: FaIcon(FontAwesomeIcons.calendar),
            ),
            ListTile(
              title: const Text("Duration"),
              subtitle: Text(formatDuration()),
              trailing: FaIcon(FontAwesomeIcons.clock),
            ),
            const SizedBox(height: 15,),

            ElevatedButton(
              onPressed: openContest,
              child: const Text("Join")
            ),
          ],
        ),
      ),
    );
  }
}
