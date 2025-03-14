import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphify_biller/codegen.dart';
import 'package:graphify_biller/view/components/textfield.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController recnameController = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController invoicenumber = TextEditingController();
  List<Map<String, String>> tabledata = [];
  List<Map<String, String>> addata = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Graphify Infotech Swiftbiller',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.jost().fontFamily),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: 400,
              child: Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha((0.5 * 255).toInt()),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/GraphifyInfotech.png',
                      width: 200,
                      height: 100,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          "Recipient Information",
                          style: TextStyle(
                              fontFamily: GoogleFonts.jost().fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ContactForm(
                        name: "Invoice Number",
                        nameController: invoicenumber,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ContactForm(
                        name: "Recipient Name",
                        nameController: recnameController,
                      ),
                    ),
                    SizedBox(
                      child: TextField(
                        maxLines: 1,
                        controller: phonenumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        TextField(
                          maxLines: 3,
                          controller: address,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            overlayColor: Colors.black),
                        onPressed: () {
                          if (invoicenumber.text.isEmpty ||
                              recnameController.text.isEmpty ||
                              phonenumber.text.isEmpty ||
                              address.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Note",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily:
                                              GoogleFonts.jost().fontFamily),
                                    ),
                                    content: Text("Please fill all the details",
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.jost().fontFamily)),
                                    elevation: 10,
                                    shape: BeveledRectangleBorder(),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                                fontFamily: GoogleFonts.jost()
                                                    .fontFamily),
                                          ))
                                    ],
                                  );
                                });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CodeDescGen(
                                        invoicenumber: invoicenumber.text,
                                        name: recnameController.text,
                                        phone: phonenumber.text,
                                        address: address.text)));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontFamily: GoogleFonts.jost().fontFamily,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
