// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowFields extends StatelessWidget {
  final TextEditingController rate;
  final TextEditingController description;
  final TextEditingController gst;
  final VoidCallback onButtonPressed;

  const RowFields({
    Key? key,
    required this.rate,
    required this.description,
    required this.gst,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: TextField(
              controller: description,
              decoration: InputDecoration(
                label: Text("Item Description"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4.5,
            child: TextField(
              controller: rate,
              decoration: InputDecoration(
                label: Text("Amount Charged"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextField(
              controller: gst,
              decoration: InputDecoration(
                label: Text("Tax in percentage"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: onButtonPressed,
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class AdFields extends StatelessWidget {
  final TextEditingController rate;
  final TextEditingController description;
  final TextEditingController gst;
  final TextEditingController numberofdays;
  final VoidCallback onButtonPressed;
  const AdFields(
      {super.key,
      required this.rate,
      required this.description,
      required this.gst,
      required this.numberofdays,
      required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              controller: description,
              decoration: InputDecoration(
                label: Text("Item Description"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * .15,
            child: TextField(
              controller: rate,
              decoration: InputDecoration(
                label: Text("Amount Charged"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * .15,
            child: TextField(
              controller: gst,
              decoration: InputDecoration(
                label: Text("Tax in percentage"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .15,
            child: TextField(
              controller: numberofdays,
              decoration: InputDecoration(
                label: Text("Number of days Ads to be displayed"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: onButtonPressed,
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class ClientInformation extends StatelessWidget {
  final String infotext;

  const ClientInformation({
    Key? key,
    required this.infotext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      infotext,
      style: TextStyle(
        fontFamily: GoogleFonts.jost().fontFamily,
        fontSize: 16,
      ),
    );
  }
}
