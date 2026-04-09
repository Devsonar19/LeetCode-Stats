import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SecProfileDetails extends StatelessWidget {
  final Map<String, dynamic>? profile;
  const SecProfileDetails({super.key, required this.profile});

  Future<void> openUrl(String url) async {
    url = url.trim();
    if (url.isEmpty || url == "https://") {
      debugPrint("Invalid URL: $url");
      return;
    }

    if (!url.startsWith("http")) {
      url = "https://$url";
    }

    final uri = Uri.tryParse(url);

    if (uri == null || uri.host.isEmpty) {
      debugPrint("Invalid URI: $url");
      return;
    }

    debugPrint("Opening URL: $url");

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final root = profile ?? {};
    final user = root["profile"] ?? {};

    debugPrint("=== RAW user keys: ${user.keys.toList()}");
    debugPrint("=== user[profile] type: ${user["profile"]?.runtimeType}");
    debugPrint("=== user[profile] value: ${user["profile"]}");

    final innerDetails = (user["profile"] is Map)
        ? Map<String, dynamic>.from(user["profile"])
        : <String, dynamic>{};

    final github = (user["githubUrl"] ?? "").toString().trim();
    final linkedin = (user["linkedinUrl"] ?? "").toString().trim();
    final twitter = (user["twitterUrl"] ?? "").toString().trim();
    final skills = innerDetails["skillTags"] ?? [];
    final color = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
          )
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Identity Info",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    user["username"] ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildInfoRow(Icons.public,"COUNTRY", innerDetails["countryName"] ?? "N/A"),

          _buildInfoRow(Icons.school,"SCHOOL", innerDetails["school"] ?? "N/A"),

          _buildInfoRow(Icons.cake,"BIRTHDAY", innerDetails["birthday"] ?? "N/A"),

          const SizedBox(height: 20),

          Text(
            "Skills",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 10),

          if(skills.isNotEmpty)...[
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: (innerDetails["skillTags"] as List)
                  .map((data) =>
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.toString(),
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              )
                  .toList(),
            )
          ]else...[
            const Text(
              "No skills added.",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (github.isNotEmpty) ...[
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: color.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => openUrl(github),
                    label: Text("GitHub",
                        style: Theme.of(context).textTheme.titleSmall),
                    icon: FaIcon(FontAwesomeIcons.github, size: 18, color: color),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (linkedin.isNotEmpty) ...[
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: color.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => openUrl(linkedin),
                    label: Text("LinkedIn",
                        style: Theme.of(context).textTheme.titleSmall),
                    icon: FaIcon(FontAwesomeIcons.linkedin, size: 18, color: color),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (twitter.isNotEmpty) ...[
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: color.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => openUrl(twitter),
                    label: Text("Twitter",
                        style: Theme.of(context).textTheme.titleSmall),
                    icon: FaIcon(FontAwesomeIcons.xTwitter, size: 18, color: color),
                  ),
                ),
              ],
            ],
          ),
        ]
      ),
    );
  }


  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey.shade400),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
