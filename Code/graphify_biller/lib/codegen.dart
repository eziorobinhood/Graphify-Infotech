// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:graphify_biller/adgen.dart';
import 'package:graphify_biller/view/components/rowtext.dart';

class CodeDescGen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  final String invoicenumber;
  const CodeDescGen({
    Key? key,
    required this.name,
    required this.phone,
    required this.address,
    required this.invoicenumber,
  }) : super(key: key);

  @override
  State<CodeDescGen> createState() => CodeDescGenState();
}

class CodeDescGenState extends State<CodeDescGen> {
  TextEditingController rate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController gst = TextEditingController();

  List<Map<String, String>> tabledata = [];
  double totalval = 0.0;

  void addrow() {
    String rateforrow = rate.text;
    String descforrow = description.text;
    String gstforrow = gst.text;
    double calculatedRate =
        ((int.parse(rateforrow) * (int.parse(gstforrow) / 100)) +
            int.parse(rateforrow));

    if (rateforrow.isNotEmpty &&
        descforrow.isNotEmpty &&
        gstforrow.isNotEmpty) {
      setState(() {
        tabledata.add({
          'Description': descforrow,
          "Rate": rateforrow,
          "GST": gstforrow,
          "Calculated Rate": calculatedRate.toString(),
        });
        totalval += calculatedRate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Technical Invoice Description',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.jost().fontFamily),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(

            // width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha((0.5 * 255).toInt()),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                'images/GraphifyInfotech.png',
                width: 200,
                height: 100,
              ),
            ),

            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha((0.5 * 255).toInt()),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text("Enter 0 if tax is not applicable",
                  style: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily,
                      fontSize: 20,
                      color: Colors.red)),
            ),

            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha((0.5 * 255).toInt()),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SizedBox(
                  child: RowFields(
                description: description,
                rate: rate,
                gst: gst,
                onButtonPressed: () {
                  addrow();
                },
              )),
            ),
            DataTableTheme(
              data: DataTableThemeData(
                headingTextStyle: TextStyle(
                    fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                dataTextStyle: TextStyle(
                    fontFamily: GoogleFonts.jost().fontFamily, fontSize: 16),
                dataRowHeight: 50,
                columnSpacing: 10,
                horizontalMargin: 16,
                dividerThickness: 1,
              ),
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.1,
                horizontalMargin: 16,
                columns: [
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Rate',
                      style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                          fontSize: 20),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'GST',
                      style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                          fontSize: 20),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Calculated Rate',
                      style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                          fontSize: 20),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      ' ',
                      style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                          fontSize: 20),
                    ),
                  ),
                ],
                rows: tabledata.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> row = entry.value;
                  return DataRow(cells: [
                    DataCell(Text(row['Description'] ?? '')),
                    DataCell(Text(row['Rate'] ?? '')),
                    DataCell(Text(row['GST'] ?? '-')),
                    DataCell(Text(row['Calculated Rate'] ?? '')),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Call a function here to delete the row at 'index'
                          _deleteRow(index);
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
            //Updated Totalvalue -  - - - - -- -  - -- - - - - - - - -- - - - - - - -  - - -- -  - - - -
            Text(
              'Total: $totalval',
              style: TextStyle(
                  fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue, overlayColor: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdGenRate(
                                invoicenumber: widget.invoicenumber,
                                name: widget.name,
                                phone: widget.phone,
                                address: widget.address,
                                tabledata: tabledata,
                                totalcodeval: totalval,
                              )));
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Next",
                    style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 20),
                  ),
                ))
          ],
        )),
      ),
    );
  }

  void _deleteRow(int index) {
    setState(() {
      tabledata.removeAt(index);
      totalval = 0.0;
      for (var row in tabledata) {
        totalval += double.parse(row['Calculated Rate'] ?? '0');
      }
    });
  }
}
