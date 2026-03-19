import 'package:flutter/material.dart';

class WidgetHeatmap extends StatelessWidget {
  final List<int> data;
  const WidgetHeatmap({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: Offset(0, 0.10)
          )
        ]
      ),

      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (_, i){
            final val = data[i];
            return Container(
              decoration: BoxDecoration(
                color: _color(val),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }
      ),
    );
  }

  Color _color(int val){
    if(val == 0) return Colors.grey[200]!;
    if(val < 3) return Colors.green[200]!;
    if(val < 6) return Colors.green[400]!;
    return Colors.green[600]!;
  }
}
