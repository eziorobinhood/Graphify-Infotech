// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:graphify_biller/pdfgen.dart';
import 'package:graphify_biller/view/components/rowtext.dart';

class AdGenRate extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  final String invoicenumber;
  final List<Map<String, String>> tabledata;
  final double totalcodeval;
  const AdGenRate({
    Key? key,
    required this.name,
    required this.phone,
    required this.address,
    required this.invoicenumber,
    required this.tabledata,
    required this.totalcodeval,
  }) : super(key: key);

  @override
  State<AdGenRate> createState() => _AdGenRateState();
}

class _AdGenRateState extends State<AdGenRate> {
  TextEditingController rate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController days = TextEditingController();
  TextEditingController serviceCharge = TextEditingController();

  TextEditingController gst = TextEditingController();
  List<Map<String, String>> addata = [];
  double totaladvalue = 0.0;
  void addrow() {
    String rateforrow = rate.text;
    String descforrow = description.text;
    String gstforrow = gst.text;
    String daysforads = days.text;
    double gstcalc = double.parse(rateforrow) * (double.parse(gstforrow) / 100);
    double calculatedrate = gst.text == "0"
        ? double.parse(rateforrow) * double.parse(daysforads)
        : (double.parse(rateforrow) + gstcalc) * double.parse(daysforads);

    if (rateforrow.isNotEmpty &&
        descforrow.isNotEmpty &&
        gstforrow.isNotEmpty &&
        daysforads.isNotEmpty) {
      setState(() {
        addata.add({
          'Description': descforrow,
          "Rate": rateforrow,
          "Days for ads to be displayed": daysforads,
          "GST": gstforrow,
          "Calculated Rate": calculatedrate.toString()

          //Last added --------------------------------------------------------------------------
          //-------------------------------------------------
          //-------------------------------------
        });
        totaladvalue += calculatedrate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marketing Invoice Description',
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
                  child: AdFields(
                description: description,
                rate: rate,
                gst: gst,
                onButtonPressed: () {
                  addrow();
                },
                numberofdays: days,
              )),
            ),
            DataTable(
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
                )),
                DataColumn(
                    label: Text(
                  'Rate',
                  style: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'GST',
                  style: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'Days for ads to be displayed',
                  style: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'Calculated Rate',
                  style: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                )),
              ],
              rows: addata.map((row) {
                return DataRow(cells: [
                  DataCell(Text(
                    row['Description'] ?? '',
                    style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 16),
                  )),
                  DataCell(Text(
                    row['Rate'] ?? '',
                    style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 16),
                  )),
                  DataCell(Text(
                    row['GST'] ?? '',
                    style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 16),
                  )),
                  DataCell(Text(
                    row['Days for ads to be displayed'] ?? '',
                    style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 16),
                  )),
                  DataCell(Text(
                    row['Calculated Rate'] ?? '',
                    style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 16),
                  )),
                ]);
              }).toList(),
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
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Service Charges Per month:  ',
                        style: TextStyle(
                            fontFamily: GoogleFonts.jost().fontFamily,
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: serviceCharge,
                          decoration: InputDecoration(
                              hintText: 'Enter Service Charge',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Enter 0 if Service Charges are not applicalble',
                      style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                          fontSize: 18,
                          color: Colors.red)),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue, overlayColor: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfGeneratorPage(
                                totalcost: totaladvalue + widget.totalcodeval,
                                servicecost: double.parse(serviceCharge.text),
                                name: widget.name,
                                phno: widget.phone,
                                address: widget.address,
                                tabledata: widget.tabledata,
                                addata: addata,
                                invoicenumber: widget.invoicenumber,
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
                )),
            SizedBox(height: 20),
          ],
        )),
      ),
    );
  }
}
