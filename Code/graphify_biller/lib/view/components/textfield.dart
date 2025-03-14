import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  final TextEditingController nameController;
  final String name;

  const ContactForm({
    super.key,
    required this.nameController,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 1,
          controller: nameController,
          decoration: InputDecoration(
            labelText: name,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
