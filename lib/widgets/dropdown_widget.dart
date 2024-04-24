import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  const DropdownWidget(
      {super.key,
      required this.items,
      required this.selectedItem,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: const TextStyle(color: AppColors.linkColor),
          iconEnabledColor: AppColors.linkColor,
          padding: const EdgeInsets.only(left: 20, right: 10),
          value: selectedItem,
          dropdownColor: Colors.white,
          onChanged: (String? newValue) {
            onChanged.call(newValue);
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              alignment: Alignment.center,
              child: Text(value),
            );
          }).toList(),
          hint: Text(selectedItem ?? items.first,
              style: const TextStyle(color: AppColors.linkColor)),
        ),
      ),
    );
  }
}
