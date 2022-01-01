import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/model/StatisticModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class MonthlyChart extends StatelessWidget {

  final List<Detail> models;
  final bool animate;
  final charts.Color color;


  MonthlyChart(this.models, this.animate, this.color);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      createSeriesFromData(models),
      animate: animate,
      animationDuration: Duration(microseconds: 500),
      dateTimeFactory: charts.LocalDateTimeFactory(),
    );
  }

  List<charts.Series<dynamic, DateTime>> createSeriesFromData(List<Detail> models) {

    final data = models.map((e) => TimeSeriesSales(DateFormat("dd/MM/yyyy").parse(e.date),
        int.parse(e.num.toString()))).toList();
    
    return [
      new charts.Series<TimeSeriesSales,DateTime>(
          id: "Data",
          colorFn: (_,__) => color,
          domainFn: (sales,_) => sales.time,
          measureFn: (sales,_) => sales.sales,
          data: data,
      ),
    ];
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);


}