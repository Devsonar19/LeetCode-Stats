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
            icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.20),
                      blurRadius: 12,
                      offset: const Offset(0,4),
                    )
                  ]
                ),

                child: Center(
                  child: Text(
                    "Total Badges : ${badges.length}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ),

          Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                  itemCount: badges.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, i){
                    final badge = badges[i];
                    String icon = badge["icon"]?.toString() ?? "";
                    String name = badge["displayName"]?.toString() ?? "Badge";

                    if(icon.isNotEmpty && !icon.startsWith("http")){
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
                            offset: const Offset(0,4),
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
                                  placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.badge, size: 60),
                                )
                              : const Icon(Icons.badge, size: 50),
                          ),
                          const SizedBox(height: 5),


                          Text(
                              name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                          )
                        ],
                      ),
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}
