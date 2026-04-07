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

  Future<void> openContest(BuildContext context) async {
    final url = "https://leetcode.com/contest/${contest.slug}";
    await launchUrl(Uri.parse(url));
  }
  String getStatus() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (now < contest.startTime) return "Upcoming";
    if (now > contest.startTime + contest.duration) return "Ended";
    return "Live";
  }

  Color getStatusColor() {
    final status = getStatus();
    if (status == "Live") return Colors.green.shade600;
    if (status == "Upcoming") return Colors.orange.shade600;
    return Colors.grey.shade600;
  }
  String formatDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(contest.startTime * 1000);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String formatTimeOnly() {
    final date = DateTime.fromMillisecondsSinceEpoch(contest.startTime * 1000);
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Contest Details",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade100,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.trophy,
                      color: Colors.orange,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    contest.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getStatus().toUpperCase(),
                      style: TextStyle(
                        color: getStatusColor(),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: "Date",
                    value: formatDate(),
                    color: Colors.blue,
                    context: context,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.punch_clock,
                    title: "Time",
                    value: formatTimeOnly(),
                    color: Colors.purple,
                    context: context,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              icon: Icons.timer,
              title: "Duration",
              value: formatDuration(),
              color: Colors.teal,
              isFullWidth: true,
              context: context,
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => openContest(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2B4B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "View on LeetCode",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 12),
                  FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required MaterialColor color,
    bool isFullWidth = false,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 15,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
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
