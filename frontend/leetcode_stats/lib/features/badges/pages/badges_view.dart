import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BadgesView extends StatelessWidget {
  final List badges;
  const BadgesView({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Badges"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BADGE ACHIEVEMENTS",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Total Badges",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${badges.length}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: badges.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 140,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, i) {
                    final badge = badges[i];
                    String icon = badge["icon"]?.toString() ?? "";
                    String name = badge["displayName"]?.toString() ?? "Badge";

                    if (icon.isNotEmpty && !icon.startsWith("http")) {
                      icon = "https://leetcode.com$icon";
                    }

                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.10),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: icon.isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl: icon,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.badge, size: 60),
                            )
                                : const Icon(Icons.badge, size: 50),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
