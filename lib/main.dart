import 'package:flutter/material.dart';
import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'about.dart';

void main() {
  runApp(const MaterialApp(
    title: 'EMI Calculator',
    home: EMICalculator(),
    debugShowCheckedModeBanner: false,
  ));
}

class EMICalculator extends StatefulWidget {
  const EMICalculator({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EMICalculatorState createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  double principalAmount = 0.0;
  double interestRate = 0.0;
  double tenure = 0.0;

  double emi = 0.0;
  double totalInterest = 0.0;
  double totalPayment = 0.0;
  final formKey = GlobalKey<FormState>();

  void calculateEMI() {
    double principal = principalAmount;
    double rateOfInterest = interestRate / 12 / 100;
    double time = tenure;

    double numerator =
        principal * rateOfInterest * pow(1 + rateOfInterest, time);
    double denominator = newMethod(rateOfInterest, time) - 1;

    emi = numerator / denominator;
    totalPayment = emi * time;
    totalInterest = totalPayment - principal;
  }

  void resetApp() {
    setState(() {
      principalAmount = 0.0;
      interestRate = 0.0;
      tenure = 0.0;
      emi = 0.0;
      totalInterest = 0.0;
      totalPayment = 0.0;
    });
    formKey.currentState?.reset();
  }

  num newMethod(double rateOfInterest, double time) =>
      pow(1 + rateOfInterest, time);

  List<PieSeries<MonthData, String>> _createData() {
    final data = [
      MonthData('Principal', principalAmount),
      MonthData('Interest', totalInterest),
      MonthData('EMI', emi),
    ];

    return [
      PieSeries<MonthData, String>(
        dataSource: data,
        xValueMapper: (MonthData monthData, _) => monthData.month,
        yValueMapper: (MonthData monthData, _) => monthData.value,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
        ),
        pointColorMapper: (MonthData monthData, _) {
          if (monthData.month == 'Principal') {
            return const Color.fromARGB(
                255, 4, 53, 77); // Set color for Principal slice
          } else if (monthData.month == 'Interest') {
            return const Color.fromARGB(
                255, 81, 115, 157); // Set color for Interest slice
          } else if (monthData.month == 'EMI') {
            return const Color.fromARGB(
                255, 232, 227, 218); // Set color for EMI slice
          }
          return Colors.grey; // Default color for other slices
        },
      ),
    ];
  }

  Widget _buildChart() {
    if (emi == 0.0 && totalInterest == 0.0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(85.0),
          child: Text('No data available'),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'EMI Distribution',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          SizedBox(
            height: 280,
            child: SfCircularChart(
              series: _createData(),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 34, 44),
        title: const Text('EMI Calculator'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 14, 34, 44)),
              child: Center(
                child: Text(
                  'EMI Calculator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('How to use this app'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const AboutApp()),
                );
              },
            ),
            ListTile(
              title: const Text('Back to app'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 320,
            ),
            Center(
              child: RichText(
                text: const TextSpan(
                  text: 'Developer ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'aj_labs',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Principal Amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the principal amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    principalAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Interest Rate (%)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the interest rate';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    interestRate = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tenure (in months)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the tenure';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    tenure = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 53, 77)),
                child: const Text('Calculate EMI'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      calculateEMI();
                    });
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 53, 77)),
                onPressed: resetApp,
                child: const Text('Reset'),
              ),
              Visibility(
                visible:
                    emi != 0.0 || totalInterest != 0.0 || totalPayment != 0.0,
                replacement: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(120.0),
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12.0),
                    Text('Monthly EMI: ${emi.toStringAsFixed(0)}'),
                    const SizedBox(height: 9.0),
                    Text('Total Interest: ${totalInterest.toStringAsFixed(0)}'),
                    const SizedBox(height: 9.0),
                    Text('Total Payment: ${totalPayment.toStringAsFixed(0)}'),
                    const SizedBox(height: 16.0),
                    _buildChart(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MonthData {
  final String month;
  final double value;

  MonthData(this.month, this.value);
}
