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
    final user = profile ?? {};

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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Details",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Text(
                "COUNTRY ",
              ),
              Chip(label: Text("${innerDetails["countryName"] ?? "N/A"}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
            ],
          ),

          Row(
            children: [
              Text(
                "SCHOOL ",
              ),
              Chip(label: Text("${innerDetails["school"] ?? "N/A"}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
            ],
          ),

          Row(
            children: [
              Text(
                "BIRTHDAY ",
              ),
              Chip(label: Text("${innerDetails["birthday"] ?? "N/A"}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
            ],
          ),



          const SizedBox(height: 10),

          Text(
              "Skills",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          if(skills.isNotEmpty)
            Wrap(
              spacing: 5,
              children:
              (innerDetails["skillTags"] as List)
                .map((data) => Chip(
                    label: Text(
                        data,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ))
                .toList(),
            )
          else
            const Chip(label: Text("No Skills")),

          const SizedBox(height: 10),

          Row(
            children: [
              if(github.isNotEmpty) ...[
                TextButton.icon(
                  style: TextButton.styleFrom(
                    side: BorderSide(color: color),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                    onPressed: () => openUrl(github),
                    label: Text("GitHub", style: Theme.of(context).textTheme.titleSmall,),
                    icon: FaIcon(FontAwesomeIcons.github, color: color,),
                ),
              ],
              const Spacer(),

              if(linkedin.isNotEmpty) ...[
                TextButton.icon(
                  style: TextButton.styleFrom(
                    side: BorderSide(color: color),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                    onPressed: () => openUrl(linkedin),
                    label: Text("LinkedIn", style: Theme.of(context).textTheme.titleSmall,),
                    icon: FaIcon(FontAwesomeIcons.linkedin, color: color,),
                ),
              ],
              const Spacer(),

              if(twitter.isNotEmpty) ...[
                TextButton.icon(
                  style: TextButton.styleFrom(
                    side: BorderSide(color: color),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                    onPressed: () => openUrl(twitter),
                    label: Text("Twitter", style: Theme.of(context).textTheme.titleSmall,),
                    icon: FaIcon(FontAwesomeIcons.xTwitter, color: color,),
                ),
              ],
            ],
          )

        ]
      ),
    );
  }
}
