import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../badges/pages/badges_view.dart';

class BadgesCard extends StatelessWidget {
  final List badges;
  const BadgesCard({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    final recentBadges = badges.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.20),
            blurRadius: 12,
            offset: const Offset(0,4),
          )
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.20)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text(
                    "Badges",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BadgesView(badges: badges),
                          ),
                        );
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      )
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recentBadges.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),

                itemBuilder: (context, index) {
                  final badge = recentBadges[index];

                  String icon = badge["icon"]?.toString() ?? "";
                  String name = badge["displayName"]?.toString() ?? "Badge";

                  /// Fixing broken URLs
                  if (icon.isNotEmpty && !icon.startsWith("http")) {
                    icon = "https://leetcode.com$icon";
                  }

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),


                        child: icon.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: icon,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) =>
                                  const SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 5,),),
                                  ),
                              errorWidget: (context, url, error) => const Icon(Icons.badge, size: 60),
                            )
                          : const Icon(Icons.badge, size: 60),
                      ),

                      const SizedBox(height: 5),

                      SizedBox(
                        width: 60,
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
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
      ),
    );
  }
}
