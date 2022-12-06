import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'item_model.dart';

class SpendingChart extends StatelessWidget {
  final List<Item> items;
  const SpendingChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};
    for (var element in items) {
      spending.update(
        element.category,
        (value) => value + element.price,
        ifAbsent: (() => element.price),
      );
    }
    return Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 360.0,
            child: Column(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: spending
                          .map(//returns a new map
                              (category, amountSpent) => MapEntry(
                                    //creates an entry with key and value
                                    category,
                                    PieChartSectionData(
                                      //this populate each sections of the pie chart with values
                                      color: getCategoryColor(
                                          category), //the color this section should be
                                      radius: 100.0, //
                                      title:
                                          '\$${amountSpent.toStringAsFixed(2)}',
                                      value:
                                          amountSpent, //this section should occupy (value/sumOfValue)/360
                                    ),
                                  ))
                          .values
                          .toList(), //creates a list of spending map values, i.e price
                      sectionsSpace: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Wrap(
                  spacing: 8.0, 
                  runSpacing: 8.0, 
                  children: spending.keys
                      .map((category) => _Indicator(
                            color: getCategoryColor(category),
                            text: category,
                          ))
                      .toList(),
                )
              ],
            )));
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Entertainment':
        return Colors.red[400]!;
      case 'Personal':
        return Colors.green[400]!;
      case 'Transportation':
        return Colors.blue[400]!;
      case 'Food':
        return Colors.purple[400]!;
      default:
        return Colors.orange[400]!;
    }
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  const _Indicator({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        const SizedBox(width: 4.0),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500),),
      ],
    );
  }
}
