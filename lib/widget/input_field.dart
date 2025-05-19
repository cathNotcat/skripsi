import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isInput;
  final bool isDate;

  const InputField(
      {super.key,
      required this.label,
      required this.controller,
      this.isInput = false,
      this.isDate = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        TextField(
          enabled: isInput ? true : false,
          controller: controller,
          readOnly: isDate,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            hintText: isDate ? "YYYY/MM/DD" : null,
            suffixIcon: isDate
                ? IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        controller.text =
                            "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                      }
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
