import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SecProfileDetails extends StatelessWidget {
  final Map<String, dynamic>? profile;
  const SecProfileDetails({super.key, required this.profile});

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = profile ?? {};
    final profileDetails = (user["profile"] is Map)
        ? Map<String, dynamic>.from(user["profile"])
        : Map<String, dynamic>.from(user);

    final github = user["githubUrl"] ?? "";
    final linkedin = user["linkedinUrl"] ?? "";
    final twitter = user["twitterUrl"] ?? "";
    final skills = profileDetails["skillTags"] ?? [];
    final color = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.20),
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

          Text(
            "Country: ${profileDetails["countryName"] ?? "Null"}",
          ),

          Text(
            "School: ${profileDetails["school"] ?? "N/A"}",
          ),

          Text(
            "BirthDay: ${profileDetails["birthday"] ?? "N/A"}",
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
              (profileDetails["skillTags"] as List)
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
            const Text("No Skills"),

          const SizedBox(height: 10),

          Row(
            children: [
              if(github.isNotEmpty)
                Text("GitHub"),
                TextButton.icon(
                    onPressed: () => openUrl(github),
                    label: Text("GitHub", style: Theme.of(context).textTheme.titleSmall,),
                    icon: FaIcon(FontAwesomeIcons.github, color: color,),
                ),

              if(linkedin.isNotEmpty)
                Text("LinkedIn"),
                TextButton.icon(
                    onPressed: () => openUrl(linkedin),
                    label: Text("LinkedIn", style: Theme.of(context).textTheme.titleSmall,),
                    icon: FaIcon(FontAwesomeIcons.linkedin, color: color,),
                ),

              if(twitter.isNotEmpty)
                Text("X"),
                TextButton.icon(
                    onPressed: () => openUrl(twitter),
                    label: Text("Twitter", style: Theme.of(context).textTheme.titleSmall,),
                    icon: FaIcon(FontAwesomeIcons.xTwitter, color: color,),
                )
            ],
          )

        ]
      ),
    );
  }
}
