// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_interceptor/http_interceptor.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGeneratorPage extends StatefulWidget {
  final String name;
  final String phno;
  final String address;
  final String invoicenumber;
  final List<Map<String, String>> tabledata;
  final List<Map<String, String>> addata;
  final double servicecost;
  final double totalcost;
  const PdfGeneratorPage({
    Key? key,
    required this.name,
    required this.phno,
    required this.address,
    required this.invoicenumber,
    required this.tabledata,
    required this.addata,
    required this.servicecost,
    required this.totalcost,
  }) : super(key: key);

  @override
  State<PdfGeneratorPage> createState() => _PdfGeneratorPageState();
}

class _PdfGeneratorPageState extends State<PdfGeneratorPage> {
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController advancepaid = TextEditingController();

  Future<void> _generatePdf() async {
    setState(() {
      _isLoading = true;
    });
    final pdf = pw.Document();
    final ByteData imageData = await rootBundle.load('images/Template.png');
    final Uint8List imageList = imageData.buffer.asUint8List();
    final image = pw.MemoryImage(imageList);
    final ByteData logoData =
        await rootBundle.load('images/GraphifyInfotech.png');
    final Uint8List logoList = logoData.buffer.asUint8List();
    final logoimage = pw.MemoryImage(logoList);
    final ByteData remainingTemplate =
        await rootBundle.load('images/RemainingTemplate.png');
    final Uint8List remainingTemplateList =
        remainingTemplate.buffer.asUint8List();
    final remainingTemplateImage = pw.MemoryImage(remainingTemplateList);
    final ByteData roundtable = await rootBundle.load('images/RoundTable.jpg');
    final Uint8List roundtableList = roundtable.buffer.asUint8List();
    final roundtableImage = pw.MemoryImage(roundtableList);

    final ByteData pdffont = await rootBundle.load('fonts/Jost-Regular.ttf');
    final ByteData pdffontbold =
        await rootBundle.load('fonts/Jost-SemiBold.ttf');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(child: pw.Image(image, fit: pw.BoxFit.cover)),
              pw.Center(
                  child: pw.Container(
                margin: pw.EdgeInsets.only(top: 100),
                padding:
                    const pw.EdgeInsets.all(20), // Add padding to the container
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'INVOICE',
                            style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                font: pw.Font.ttf(pdffontbold)),
                          ),
                          pw.Text(
                            'Invoice Number: ${widget.invoicenumber}',
                            style: pw.TextStyle(
                                fontSize: 10, font: pw.Font.ttf(pdffont)),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                              '${DateFormat("dd-MM-yyyy").format(DateTime.now())} ',
                              style: pw.TextStyle(
                                  fontSize: 10, font: pw.Font.ttf(pdffont))),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            'BILL TO:',
                            style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                font: pw.Font.ttf(pdffontbold)),
                          ),
                          pw.SizedBox(
                            width: 200,
                            child: pw.Text(
                                '${widget.name}\n${widget.phno}\n${widget.address}',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    height: 10.0,
                                    font: pw.Font.ttf(pdffont))),
                          )
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('GST : 33BLRPG0044B2ZO',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  height: 10.0,
                                  font: pw.Font.ttf(pdffont))),
                          pw.Image(logoimage, width: 200, height: 60),
                          pw.SizedBox(height: 10),
                          pw.Text(
                              'No.4, Vadavalli Road, West Zone,\nCoimbatore -641007,Tamil Nadu.\n+91 90428 95697 / +91 96777 04249\ninfo@graphifyinfotech.com\nwww.graphifyinfotech.com',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  height: 10.0,
                                  font: pw.Font.ttf(pdffont))),
                        ],
                      ),
                    ]),
              )),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 300, left: 30, right: 30),
                child: pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>[
                      'Description',
                      'Rate',
                      'GST in %',
                      'Calculated Rate'
                    ],
                    ...widget.tabledata.map((e) => [
                          e['Description'] ?? '',
                          e['Rate'] ?? '',
                          e['GST in %'] ?? '',
                          e['Calculated Rate'] ?? '',
                        ]),
                  ],
                  headerStyle: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      font: pw.Font.ttf(pdffontbold)),
                  cellStyle: pw.TextStyle(font: pw.Font.ttf(pdffont)),
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColors.blue,
                  ),
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 470, left: 30, right: 30),
                child: pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>[
                      'Description',
                      'Rate',
                      'GST in %',
                      'Days for ads \nto be displayed',
                      'Calculated Rate'
                    ],
                    ...widget.addata.map((e) => [
                          e['Description'] ?? '',
                          e['Rate'] ?? '',
                          e['GST in %'] ?? '',
                          e['Days for ads to be displayed'] ?? '',
                          e['Calculated Rate'] ?? '',
                        ]),
                  ],
                  headerStyle: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      font: pw.Font.ttf(pdffontbold)),
                  cellStyle: pw.TextStyle(font: pw.Font.ttf(pdffont)),
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColors.blue,
                  ),
                ),
              ),
              pw.Align(
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue,
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    margin: pw.EdgeInsets.only(top: 450, left: 300, right: 30),
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(
                        'Service Charges Per Month - ${widget.servicecost}/-',
                        style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                  ),
                  alignment: pw.Alignment.center),
              pw.Align(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue,
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    margin: pw.EdgeInsets.only(top: 520, left: 300, right: 30),
                    child: pw.Text(
                        'Grand Total - ${widget.totalcost + widget.servicecost}/-',
                        style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                  ),
                  alignment: pw.Alignment.center),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 600, left: 30, right: 30),
                child: pw.Text('Account details:',
                    style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        font: pw.Font.ttf(pdffontbold))),
              ),
              pw.Container(
                width: 200,
                margin: pw.EdgeInsets.only(top: 620, left: 30, right: 30),
                child: pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Name', 'GRAPHIFY INFOTECH'],
                    <String>['Account Number', '259790795697'],
                    <String>['Bank Name', 'Indusind Bank'],
                    <String>['IFSC Code', 'INDB0000859'],
                  ],
                  cellStyle:
                      pw.TextStyle(fontSize: 10, font: pw.Font.ttf(pdffont)),
                ),
              ),
              pw.Align(
                  child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 750, left: 30, right: 30),
                    child: pw.Text('Thank You For Your Business',
                        style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                  ),
                  alignment: pw.Alignment.center),
            ],
          );
        },
      ),
    );
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(children: [
            pw.Positioned.fill(
                child: pw.Image(remainingTemplateImage, fit: pw.BoxFit.cover)),
            pw.Center(
                child: pw.Container(
              margin: pw.EdgeInsets.only(top: 50),
              padding:
                  const pw.EdgeInsets.all(20), // Add padding to the container
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [pw.Image(logoimage, width: 200, height: 60)],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.SizedBox(height: 10),
                        pw.Text(
                            'No.4, Vadavalli Road, West Zone,\nCoimbatore -641007,Tamil Nadu.\n\n+91 90428 95697 / +91 96777 04249\n\ninfo@graphifyinfotech.com\n\nwww.graphifyinfotech.com',
                            style: pw.TextStyle(
                                fontSize: 10,
                                height: 10.0,
                                font: pw.Font.ttf(pdffont))),
                      ],
                    ),
                  ]),
            )),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 200, left: 30, right: 30),
                  child: pw.Text('SUPPORT AND MAINTENANCE',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          font: pw.Font.ttf(pdffontbold)))),
            ),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 230, left: 30, right: 30),
                  child: pw.Text('Terms and Conditions',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          font: pw.Font.ttf(pdffontbold)))),
            ),
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 240, left: 20),
                    child: pw.Text(
                        '\n1. Client Responsibilities\n\nThe Client agrees to:',
                        style: pw.TextStyle(
                            height: 20,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),

            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 320),
                  child: pw.Column(children: [
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            'Provide all necessary inputs, materials, and access for executing the project, including credentials for webs social media accounts, or ad platforms. Respond promptly to approval requests, queries, or feedback to avoid delays in service delivery.',
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            'Ensure that hosting, domain, and other third-party services linked to digital marketing campaigns are active and up to date.',
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            'Comply with applicable advertising policies (e.g., platform-specific policies such as Google Ads or Meta Ads',
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            'Inform Graphify Infotech promptly of any changes to their brand, business goals, or ongoing campaigns that may affect the services',
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                  ])),
            ),
            //-----------------------------------Client Responsibilities over-----------------------
            //-------------------------------Payment Terms Starts------------------------------------
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 470, left: 20),
                    child: pw.Text('2. Payment Terms:',
                        style: pw.TextStyle(
                            height: 20,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 490),
                  child: pw.Column(children: [
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            'The agreed service fees, including retainer or AMC (Annual Maintenance Contract), must be paid in advance or as per the mutually agreed payment schedule.',
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            'Customization requests or additional tasks beyond the agreed scope will be charged on an hourly or project basis, with prior client approval.',
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Payments for ad budgets are the Client's responsibility unless otherwise agreed. Payment for all invoices is due within 15 days of issuance.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            'Late payments may result in service suspension. All payments are non-refundable',
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                  ])),
            ),
            //--------------------------------Payment Terms Over-------------------------------------
            //--------------------------------Campaign and Service Delivery Starts---------------------------------
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 650, left: 20),
                    child: pw.Text('3. Campaign and Service Delivery:',
                        style: pw.TextStyle(
                            fontSize: 12,
                            height: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 680),
                  child: pw.Column(children: [
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Campaign timelines and deliverables are estimates and may vary depending on factors beyond Graphify Infotech's control (e.g., platform review delays). Any changes in campaign scope or strategy will be discussed and documented in advance.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Results from digital marketing efforts (e.g., ad performance, SEO rankings) depend on external factors like competition, algorithm updates, and user behavior, which are outside Graphify Infotech's control.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                  ])),
            )
          ]);
        }));

    //---------------------------------------- Third page Starts-----------------------------------

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(children: [
            pw.Positioned.fill(
                child: pw.Image(remainingTemplateImage, fit: pw.BoxFit.cover)),
            pw.Center(
                child: pw.Container(
              margin: pw.EdgeInsets.only(top: 50),
              padding:
                  const pw.EdgeInsets.all(20), // Add padding to the container
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [pw.Image(logoimage, width: 200, height: 60)],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.SizedBox(height: 10),
                        pw.Text(
                            'No.4, Vadavalli Road, West Zone,\nCoimbatore -641007,Tamil Nadu.\n\n+91 90428 95697 / +91 96777 04249\n\ninfo@graphifyinfotech.com\n\nwww.graphifyinfotech.com',
                            style: pw.TextStyle(
                                fontSize: 10,
                                height: 10.0,
                                font: pw.Font.ttf(pdffont))),
                      ],
                    ),
                  ]),
            )),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 200, left: 30, right: 30),
                  child: pw.Text('SUPPORT AND MAINTENANCE',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          font: pw.Font.ttf(pdffontbold)))),
            ),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 230, left: 30, right: 30),
                  child: pw.Text('Terms and Conditions',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          font: pw.Font.ttf(pdffontbold)))),
            ),
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 260, left: 20),
                    child: pw.Text('4. Confidentiality',
                        style: pw.TextStyle(
                            fontSize: 12,
                            height: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),

            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 290),
                  child: pw.Column(children: [
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Graphify Infotech will maintain strict confidentiality of the Client's data, including campaign metrics, credentials, and proprietary information.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Confidentiality obligations will remain in effect even after the termination of this agreement.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "The Client agrees not to disclose any strategies or proprietary methods used by Graphify Infotech to third parties.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                  ])),
            ),
            //-----------------------------------Confidentiality over-----------------------
            //-------------------------------Limitation of Liablity Starts------------------------------------
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 400, left: 20),
                    child: pw.Text('5. Limitation of Liability',
                        style: pw.TextStyle(
                            fontSize: 12,
                            height: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 430),
                  child: pw.Column(children: [
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Graphify Infotech will not be liable for: Performance issues caused by third-party services, platforms, or hosting providers.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Loss of ad accounts, social media accounts, or campaign data due to non-compliance with platform policies by the Client.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Errors or delays resulting from incomplete or incorrect information provided by the Client. Any indirect, consequential, or incidental damages arising from digital marketing services.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                  ])),
            ),
            //--------------------------------Limitation of Liability Over-------------------------------------
            //--------------------------------Service Termination Starts---------------------------------
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 530, left: 20),
                    child: pw.Text('6. Service Termination:',
                        style: pw.TextStyle(
                            fontSize: 12,
                            height: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 560),
                  child: pw.Column(children: [
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Either party may terminate this agreement with a 30-day written notice.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Upon termination, the Client is required to settle any outstanding payments before the release of final deliverables.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Support services and access to campaign data will cease upon termination.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                  ])),
            ),

            //--------------------------------Service Termination Over-------------------------------------
            //-------------------------------- Compliance with Policies Starts---------------------------------

            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 650, left: 20),
                    child: pw.Text('7. Compliance with Policies',
                        style: pw.TextStyle(
                            fontSize: 12,
                            height: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 690),
                  child: pw.Column(children: [
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "The Client agrees to comply with all applicable advertising, social media, and data protection regulations.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                    pw.Bullet(
                        margin: pw.EdgeInsets.only(left: 20, right: 20),
                        text:
                            "Graphify Infotech reserves the right to refuse or terminate services if the Client's campaigns violate any law or platform policies.",
                        style: pw.TextStyle(
                            fontSize: 10,
                            height: 20,
                            font: pw.Font.ttf(pdffont))),
                    pw.SizedBox(height: 10),
                  ])),
            ),
          ]);
        }));

    //-----------------------------------------End of third page------------------------
    //-------------------------------------------Fourth page starts----------------------

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(children: [
            pw.Positioned.fill(
                child: pw.Image(remainingTemplateImage, fit: pw.BoxFit.cover)),
            pw.Center(
                child: pw.Container(
              margin: pw.EdgeInsets.only(top: 50),
              padding:
                  const pw.EdgeInsets.all(20), // Add padding to the container
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [pw.Image(logoimage, width: 200, height: 60)],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.SizedBox(height: 10),
                        pw.Text(
                            'No.4, Vadavalli Road, West Zone,\nCoimbatore -641007,Tamil Nadu.\n\n+91 90428 95697 / +91 96777 04249\n\ninfo@graphifyinfotech.com\n\nwww.graphifyinfotech.com',
                            style: pw.TextStyle(
                                fontSize: 10,
                                height: 10.0,
                                font: pw.Font.ttf(pdffont))),
                      ],
                    ),
                  ]),
            )),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 200, left: 30, right: 30),
                  child: pw.Text('SUPPORT AND MAINTENANCE',
                      style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          font: pw.Font.ttf(pdffontbold)))),
            ),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 230, left: 30, right: 30),
                  child: pw.Text('Terms and Conditions',
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          font: pw.Font.ttf(pdffontbold)))),
            ),
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 270, left: 20),
                    child: pw.Text('Acceptance and Signatures',
                        style: pw.TextStyle(
                            height: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 290, left: 20),
                    child: pw.Text(
                        'By signing below, both parties agree to the terms of this Support and Maintenance Agreement.',
                        style: pw.TextStyle(
                            height: 20, font: pw.Font.ttf(pdffont))))),
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 330, left: 20),
                    child: pw.Text('GRAPHIFY INFOTECH',
                        style: pw.TextStyle(
                            height: 20,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                margin: pw.EdgeInsets.only(top: 360, left: 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Signature:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 10), // Add spacing between lines
                    pw.Text('Name:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 10), // Add spacing between lines
                    pw.Text('Title:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 10), // Add spacing between lines
                    pw.Text('Date:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                  ],
                ),
              ),
            ),
            pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Container(
                    margin: pw.EdgeInsets.only(top: 500, left: 20),
                    child: pw.Text('CLIENT NAME',
                        style: pw.TextStyle(
                            height: 20,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))))),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                margin: pw.EdgeInsets.only(top: 530, left: 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Signature:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 10), // Add spacing between lines
                    pw.Text('Name:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 10), // Add spacing between lines
                    pw.Text('Title:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 10), // Add spacing between lines
                    pw.Text('Date:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                  ],
                ),
              ),
            ),
          ]);
        }));

    //-----------------------------------------End of Fourth page------------------------
    //-------------------------------------------Fifth page starts----------------------
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(children: [
            pw.Positioned.fill(
                child: pw.Image(remainingTemplateImage, fit: pw.BoxFit.cover)),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 100, left: 30, right: 30),
                  child: pw.Image(logoimage, width: 200, height: 60)),
            ),
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Container(
                  margin: pw.EdgeInsets.only(top: 200, left: 30, right: 30),
                  child: pw.Image(roundtableImage)),
            ),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Container(
                margin: pw.EdgeInsets.only(top: 520, left: 40),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Contact Us:',
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 20), // Add spacing between lines
                    pw.Text('Website:\nwww.graphifyinfotech.com',
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 20), // Add spacing between lines
                    pw.Text('Email:\ninfo@graphifyinfotech.com',
                        style: pw.TextStyle(
                            font: pw.Font.ttf(pdffontbold),
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 20), // Add spacing between lines
                    pw.Text('Phone Number:\n+91 90428 95697 / +91 96777 04249',
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                    pw.SizedBox(height: 20), // Add spacing between lines
                    pw.Text(
                        'Address:\nNo.4, Vadavalli Road, West Zone \nCoimbatore -641007,Tamil Nadu',
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: pw.Font.ttf(pdffontbold))),
                  ],
                ),
              ),
            ),
          ]);
        }));

    final bytes = await pdf.save();

    // Save the PDF as a file (browser-specific)
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
          'download', 'Invoice_${widget.invoicenumber}_${widget.name}.pdf')
      ..text = 'Download PDF';
    html.document.body!.append(anchor);

    // Clean up (optional)
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review the information before proceeding'),
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
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingTextStyle: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                  dataTextStyle: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                  dataRowHeight: 50,
                  columnSpacing: 10,
                  horizontalMargin: 16,
                  dividerThickness: 1,
                ),
                child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width * 0.03,
                  horizontalMargin: 8,
                  columns: [
                    DataColumn(
                        label: Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'Rate',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'GST',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'Calculated Rate',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                  ],
                  rows: widget.tabledata.map((row) {
                    return DataRow(cells: [
                      DataCell(Text(
                        row['Description'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                      DataCell(Text(
                        row['Rate'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                      DataCell(Text(
                        row['GST'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                      DataCell(Text(
                        row['Calculated Rate'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingTextStyle: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                  dataTextStyle: TextStyle(
                      fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20),
                  dataRowHeight: 50,
                  columnSpacing: 10,
                  horizontalMargin: 16,
                  dividerThickness: 1,
                ),
                child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width * 0.01,
                  horizontalMargin: 8,
                  columns: [
                    DataColumn(
                        label: Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'Rate',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'GST',
                      style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                          fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                      'Days for ads to be displayed',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'Calculated Rate',
                      style: TextStyle(
                        fontFamily: GoogleFonts.jost().fontFamily,
                      ),
                    )),
                  ],
                  rows: widget.addata.map((row) {
                    return DataRow(cells: [
                      DataCell(Text(
                        row['Description'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                      DataCell(Text(
                        row['Rate'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                      DataCell(Text(
                        row['GST'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                      DataCell(Text(
                        row['Days for ads to be displayed'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                      DataCell(Text(
                        row['Calculated Rate'] ?? '',
                        style: TextStyle(
                          fontFamily: GoogleFonts.jost().fontFamily,
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
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
                  "Service Cost: ${widget.servicecost}",
                  style: TextStyle(
                    fontFamily: GoogleFonts.jost().fontFamily,
                    fontSize: 18,
                  ),
                )),
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
                      color: Colors.blue.withAlpha((0.5 * 255).toInt()),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  "Grand Total: ${widget.totalcost + widget.servicecost}",
                  style: TextStyle(
                    fontFamily: GoogleFonts.jost().fontFamily,
                    fontSize: 18,
                  ),
                )),
            SizedBox(
              height: 30,
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
                        'Advance Paid:  ',
                        style: TextStyle(
                            fontFamily: GoogleFonts.jost().fontFamily,
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: advancepaid,
                          decoration: InputDecoration(
                              hintText: 'Enter Advance Amount',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                _isLoading ? null : _generatePdf();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, overlayColor: Colors.black),
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Generate Invoice',
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
}
