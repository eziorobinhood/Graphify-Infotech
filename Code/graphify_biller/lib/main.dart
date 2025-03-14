import 'package:flutter/material.dart';
import 'package:graphify_biller/home.dart';
import 'package:graphify_biller/pdfgen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Graphify Infotech',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: PdfGeneratorPage(
          name: 'Rahuram',
          phno: '89712873132',
          address: 'dasjjkhdkjahs',
          invoicenumber: '213187382',
          tabledata: [],
          addata: [],
          servicecost: 8000,
          totalcost: 45000,
        ));
  }
}
