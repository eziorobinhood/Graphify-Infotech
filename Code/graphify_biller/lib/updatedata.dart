// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphify_biller/home.dart';
import 'package:screenshot/screenshot.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
// ignore: deprecated_member_use
import 'dart:js' as js;

class InvoiceUpdate extends StatefulWidget {
  const InvoiceUpdate(
      {super.key,
      required this.name,
      required this.phno,
      required this.address,
      required this.invoicenumber,
      required this.totalcost,
      required this.balanceamount,
      required this.advancepaid});
  final String name;
  final String phno;
  final String address;
  final String invoicenumber;
  final String balanceamount;
  final double totalcost;
  final double advancepaid;

  @override
  State<InvoiceUpdate> createState() => _InvoiceUpdateState();
}

class _InvoiceUpdateState extends State<InvoiceUpdate> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice History: ${widget.name}[${widget.invoicenumber}]'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  alignment: Alignment.centerLeft,
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
                  margin: EdgeInsets.all(20),
                  padding: const EdgeInsets.all(40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(
                          "Client Information",
                          style: TextStyle(
                              fontFamily: GoogleFonts.jost().fontFamily,
                              fontSize: 24),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Invoice Number: ",
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                            Text(widget.invoicenumber,
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Recipient Name: ",
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                            Text(widget.name,
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Phone Number: ",
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                            Text(widget.phno,
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Address: ",
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                            Text(widget.address,
                                style: TextStyle(
                                    fontFamily: GoogleFonts.jost().fontFamily)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
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
                  margin: EdgeInsets.all(20),
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text(
                        "Company Information",
                        style: TextStyle(
                            fontFamily: GoogleFonts.jost().fontFamily,
                            fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      Image.asset('images/GraphifyInfotech.png'),
                      SizedBox(height: 20),
                      Text(
                        "No.4, Vadavalli Road, West Zone, Coimbatore -641007,Tamil Nadu.",
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "+91 90428 95697 / +91 96777 04249",
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "info@graphifyinfotech.com",
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "www.graphifyinfotech.com",
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Payment Information",
              style: TextStyle(
                  fontFamily: GoogleFonts.jost().fontFamily, fontSize: 24),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: EdgeInsets.all(40),
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
                    child: Text(
                      "Total Amount: ${widget.totalcost}/-",
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 18,
                      ),
                    )),
                SizedBox(
                  width: 30,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: EdgeInsets.all(40),
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
                    child: Text(
                      "Advance Paid: ${widget.advancepaid}/-",
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                        fontSize: 18,
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: (double.tryParse(widget.balanceamount) ?? 0) > 0
                          ? Colors.deepOrange.withAlpha((0.5 * 255).toInt())
                          : Colors.green,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  "Balance amount: ${widget.balanceamount}/-",
                  style: TextStyle(
                    fontFamily: GoogleFonts.jost().fontFamily,
                    fontSize: 18,
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, overlayColor: Colors.black),
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Go to Homepage',
                    style: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: _isLoading ? 1 : 0,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void postData() {
    print("Advance Paid: ");
  }
}
