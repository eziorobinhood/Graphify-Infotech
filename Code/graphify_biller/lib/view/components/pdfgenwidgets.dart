// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWid extends StatelessWidget {
  final String name;
  const CustomTextWid({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(name,
        style:
            TextStyle(fontFamily: GoogleFonts.jost().fontFamily, fontSize: 20));
  }
}

class CustomHeadText extends StatelessWidget {
  final String headingtext;

  const CustomHeadText({super.key, required this.headingtext});

  @override
  Widget build(BuildContext context) {
    return Text(
      headingtext,
      style: TextStyle(fontFamily: GoogleFonts.jost().fontFamily, fontSize: 28),
    );
  }
}
