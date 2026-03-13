import 'package:flutter/material.dart';

class BadgesCard extends StatelessWidget {
  final List badges;
  const BadgesCard({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    final recentBadges = badges.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0,4),
          )
        ]
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Badges",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.arrow_forward),

              ),
            ],
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentBadges.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),

              itemBuilder: (context, index) {
                final badge = recentBadges[index];

                String icon = badge["icon"]?.toString() ?? "";

                /// Fixing broken URLs
                if (!icon.startsWith("http")) {
                  icon = "https://leetcode.com$icon";
                }

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Image.network(
                        icon,
                        height: 60,
                        width: 60,
                      ),
                    ),

                    const SizedBox(height: 5),

                    SizedBox(
                      width: 60,
                      child: Text(
                        badge["displayNames"],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
