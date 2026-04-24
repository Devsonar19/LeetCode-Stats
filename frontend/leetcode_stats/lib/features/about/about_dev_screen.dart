import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDevScreen extends StatelessWidget {
  const AboutDevScreen({super.key});

  Future<void> openUrl(String urlString, String url) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Developer",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000), // Caps width on ultra-wide screens
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // --- DESKTOP VIEW ---
                if (constraints.maxWidth >= 750) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Profile
                      Expanded(
                        flex: 4,
                        child: _buildProfileCard(context),
                      ),
                      const SizedBox(width: 20),
                      // Right Column: Skills & Project
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildSkillsCard(context),
                            const SizedBox(height: 20),
                            _buildProjectCard(context),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // --- MOBILE / APP VIEW ---
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileCard(context),
                    const SizedBox(height: 20),
                    _buildSkillsCard(context),
                    const SizedBox(height: 20),
                    _buildProjectCard(context),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _DecoratedCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage(
                "assets/images/my_profile.jpeg",
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Dev Sonar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "FLUTTER DEVELOPER",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "I Develop, Design, and Code in Flutter as well as Backends in Python",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: colorScheme.outlineVariant, thickness: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                context,
                FontAwesomeIcons.solidEnvelope,
                'mailto:devsonar19@outlook.com',
                'Email',
              ),
              const SizedBox(width: 16),
              _buildSocialIcon(
                context,
                FontAwesomeIcons.linkedinIn,
                'https://www.linkedin.com/in/dev-sonar-656677281/',
                'LinkedIn',
              ),
              const SizedBox(width: 16),
              _buildSocialIcon(
                context,
                FontAwesomeIcons.github,
                'https://github.com/devsonar19',
                'GitHub',
              ),
              const SizedBox(width: 16),
              _buildSocialIcon(
                context,
                FontAwesomeIcons.code,
                'https://leetcode.com/Dev_Sonar19/',
                'LeetCode',
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, FaIconData icon, String url, String tooltipLabel) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltipLabel, // This is the text that shows on hover
      waitDuration: const Duration(milliseconds: 300), // Optional: slight delay before showing
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => openUrl(context as String, url),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: FaIcon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skills = [
      "Flutter",
      "Dart",
      "Firebase",
      "Python",
      "FastAPI",
      "REST APIs",
      "Git"
    ];

    return _DecoratedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SKILLS",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children:
                skills.map((skill) => _buildSkillChip(context, skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _DecoratedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why I Built This.",
            style: TextStyle(
              fontSize: 26,
              height: 1.1,
              letterSpacing: -0.5,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "I built this app to create a seamless, customized way to track LeetCode progress. Generic dashboards didn't offer the detailed analytics or the aesthetic experience I wanted for my daily problem-solving routine or motivation needed. So I made my own solution and my biggest driver for this project is to implement HeatMap HomeScreen Widget, so you can easily and quickly take a glance at your progress and feel good.",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecoratedCard extends StatelessWidget {
  final Widget child;

  const _DecoratedCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: child,
    );
  }
}
