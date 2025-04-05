import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphify_biller/model/invoice.dart';
import 'package:graphify_biller/pdfgen.dart';
import 'package:http_interceptor/http_interceptor.dart' as http;

class InvoiceFinder extends StatefulWidget {
  const InvoiceFinder({super.key});

  @override
  State<InvoiceFinder> createState() => _InvoiceFinderState();
}

class _InvoiceFinderState extends State<InvoiceFinder> {
  String _searchQuery = '';
  List<Invoice> _filteredInvoices = [];
  List<Invoice>? invoices;

  Future<List<Invoice>> fetchData() async {
    List<Invoice> invoices = [];
    try {
      http.Response response = await http.get(
        Uri.parse('https://graphifyserver.vercel.app/invoices'),
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedJson = jsonDecode(
          response.body,
        ); // Decode JSON once

        for (var item in decodedJson) {
          invoices.add(Invoice.fromMap(item)); // Use fromMap with the item
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return invoices;
  }

  @override
  void initState() {
    super.initState();
    getallProducts();
  }

  getallProducts() async {
    invoices = await fetchData();
    setState(() {});
  }

  void _filterInvoices(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredInvoices = invoices!; // Show all when query is empty
      } else {
        _filteredInvoices = invoices!
            .where(
              (invoice) => invoice.phone_number.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  void deleteInvoiceUsingId(Invoice invoices, int index) {
    deleteInvoice(invoice: invoices);
    setState(() {
      _filteredInvoices.removeAt(index);
    });
  }

  void deleteInvoice({required Invoice invoice}) async {
    try {
      http.Response response = await http.post(
          Uri.parse(
              "https://graphifyserver.vercel.app/invoices/delete-invoice"),
          body: jsonEncode({
            'invoice_number': invoice.invoice_number,
          }),
          headers: {
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        print('Invoice deleted successfully');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizedboxwidth = MediaQuery.of(context).size.width / 5;

    return invoices == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Invoice Directory'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      onChanged: _filterInvoices,
                      decoration: InputDecoration(
                        labelText:
                            'Search by Phone Number', // More specific label
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ), // Padding
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredInvoices.isNotEmpty
                      ? ListView.builder(
                          itemCount: _filteredInvoices.length,
                          itemBuilder: (context, index) {
                            final invoiceData = _filteredInvoices[index];
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 8,
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: sizedboxwidth,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Invoice Number: ${invoiceData.invoice_number}',
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              'Recipient Name: ${invoiceData.recipient_name}',
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              'Phone Number: ${invoiceData.phone_number}',
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Wrap(
                                              children: [
                                                Text(
                                                  'Address: ', // Label before the address
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.lato()
                                                            .fontFamily,
                                                  ),
                                                ),
                                                ...invoiceData.address
                                                    .split('\n')
                                                    .map(
                                                      (line) => Text(
                                                        line, // Each line of the address
                                                        style: TextStyle(
                                                          fontFamily:
                                                              GoogleFonts.lato()
                                                                  .fontFamily,
                                                        ),
                                                      ),
                                                    ),
                                              ],
                                            ),
                                            const SizedBox(height: 8.0),
                                            Row(children: [
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor: Colors.red,
                                                    overlayColor: Colors.black),
                                                onPressed: () =>
                                                    deleteInvoiceUsingId(
                                                        invoiceData, index),
                                                icon: Icon(
                                                  Icons.delete_outline_sharp,
                                                  color: Colors.red,
                                                ),
                                                label: Text('Delete Invoice'),
                                              ),
                                              const SizedBox(width: 8.0),
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        Colors.blue,
                                                    overlayColor: Colors.black),
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PdfGeneratorPage(
                                                        name: invoiceData
                                                            .recipient_name,
                                                        phno: invoiceData
                                                            .phone_number,
                                                        address:
                                                            invoiceData.address,
                                                        invoicenumber:
                                                            invoiceData
                                                                .invoice_number,
                                                        tabledata: decodetable(
                                                          invoiceData.tabledata,
                                                        ),
                                                        addata: json
                                                            .decode(invoiceData
                                                                .addata
                                                                .replaceAll(
                                                              "'",
                                                              '"',
                                                            ))
                                                            .cast<String>()
                                                            .toList(),
                                                        servicecost: 0,
                                                        totalcost: double.parse(
                                                            invoiceData
                                                                .totalamount),
                                                      ),
                                                    )),
                                                icon: Icon(
                                                  Icons.create_sharp,
                                                  color: Colors.blue,
                                                ),
                                                label: Text('Create Invoice'),
                                              ),
                                            ])
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(
                                                context,
                                              ).size.width /
                                              3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Amount: Rs. ${invoiceData.totalamount}/-',
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              'Advance Paid: Rs. ${invoiceData.advance_paid}/-',
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Container(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        Colors.blue.withAlpha(
                                                      (0.5 * 255).toInt(),
                                                    ),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(
                                                      0,
                                                      3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                'Balance Amount: Rs. ${invoiceData.balance_amount}/-',
                                                style: TextStyle(
                                                  fontFamily: GoogleFonts.lato()
                                                      .fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: _searchQuery.isNotEmpty
                              ? const Text('No matching invoices found.')
                              : const Text(
                                  'Enter a phone number to search.',
                                ),
                        ),
                ),
              ],
            ),
          );
  }
}
