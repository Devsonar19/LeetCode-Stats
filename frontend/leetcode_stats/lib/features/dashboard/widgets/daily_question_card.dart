import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyQuestionCard extends StatelessWidget {
  final Map<String, dynamic>? question;
  const DailyQuestionCard({super.key, required this.question});


  void openUrl(String url) {
    if(!url.startsWith("http")){
      url = "https://leetcode.com$url";
    }
    launchUrl(Uri.parse(url),);
  }

  @override
  Widget build(BuildContext context) {
    final title = question?["question"]["title"] ?? "Error";
    final date = question?["date"] ?? "Error";
    final difficulty = question?["question"]["difficulty"] ?? "Error";
    final url = question?["link"] ?? "Error";



    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.20),
            blurRadius: 10,
            offset: const Offset(0,4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  "Today's Question",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(flex: 1,),

              IconButton(
                  onPressed: (){
                    openUrl(url);
                  },
                  icon: FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 15,),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            if(difficulty == 'Easy')...[
                              Text(
                                difficulty,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green
                                ),
                              ),
                            ],
                            if(difficulty == 'Medium')...[
                              Text(
                                difficulty,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber
                                ),
                              ),
                            ],
                            if(difficulty == 'Hard')...[
                              Text(
                                difficulty,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                date,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),


                      ]
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
