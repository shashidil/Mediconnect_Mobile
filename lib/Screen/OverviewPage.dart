import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Model/MostSoldMedicineDTO.dart';
import '../Model/OrderQuantityByMonthDTO.dart';
import '../Sevices/API/ReportAPI.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final ReportAPI reportAPI = ReportAPI();
  late Future<List<MostSoldMedicineDTO>> top5Medicines;
  late Future<List<OrderQuantityByMonthDTO>> orderQuantities;

  @override
  void initState() {
    super.initState();
    top5Medicines = reportAPI.fetchTop5Medicines();
    orderQuantities = reportAPI.fetchOrderQuantitiesByLast12Months();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<MostSoldMedicineDTO>>(
                future: top5Medicines,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return SizedBox(
                      height: 300, // Fixed height to avoid infinite size issue
                      child: PieChart(
                        PieChartData(
                          sections: snapshot.data!.map((medicine) {
                            return PieChartSectionData(
                              title: '${medicine.medicationName}\n${medicine.totalQuantity}',
                              value: medicine.totalQuantity.toDouble(),
                              color: Colors.blue, // Customize the color
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Color of the title text
                              ),
                              radius: 100, // Customize the size of each slice
                            );
                          }).toList(),
                        ),
                      )
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<OrderQuantityByMonthDTO>>(
                future: orderQuantities,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return SizedBox(
                      height: 300, // Fixed height to avoid infinite size issue
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitles: (value) {
                                return value.toInt().toString();
                              },
                              // textStyle: const TextStyle(
                              //   color: Colors.black,
                              //   fontWeight: FontWeight.bold,
                              //   fontSize: 12,
                              // ),
                            ),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 1:
                                    return 'Jan';
                                  case 2:
                                    return 'Feb';
                                  case 3:
                                    return 'Mar';
                                  case 4:
                                    return 'Apr';
                                  case 5:
                                    return 'May';
                                  case 6:
                                    return 'Jun';
                                  case 7:
                                    return 'Jul';
                                  case 8:
                                    return 'Aug';
                                  case 9:
                                    return 'Sep';
                                  case 10:
                                    return 'Oct';
                                  case 11:
                                    return 'Nov';
                                  case 12:
                                    return 'Dec';
                                  default:
                                    return '';
                                }
                              },
                              // textStyle: const TextStyle(
                              //   color: Colors.black,
                              //   fontWeight: FontWeight.bold,
                              //   fontSize: 12,
                              // ),
                              reservedSize: 40,
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                          barGroups: snapshot.data!.map((orderQuantity) {
                            return BarChartGroupData(
                              x: orderQuantity.month,
                              barRods: [
                                BarChartRodData(
                                  y: orderQuantity.orderCount.toDouble(),
                                  colors: [Colors.blue], // Bar color
                                  width: 20, // Bar width
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      )




                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
