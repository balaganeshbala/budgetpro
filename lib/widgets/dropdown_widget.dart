import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedValue;

  @override
  void didUpdateWidget(covariant DropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedValue != null && !widget.items.contains(_selectedValue)) {
      setState(() {
        _selectedValue = widget.items.isNotEmpty ? widget.items.first : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true, // Make the dropdown use available width
            value: widget.items.contains(_selectedValue)
                ? _selectedValue
                : widget.items.isNotEmpty
                    ? widget.items.first
                    : '',
            style: const TextStyle(
                color: AppColors.linkColor, fontWeight: FontWeight.w500),
            iconEnabledColor: AppColors.linkColor,
            // Use less horizontal padding to save space
            padding: const EdgeInsets.only(left: 15, right: 10),
            dropdownColor: Colors.white,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue;
              });
              widget.onChanged.call(newValue);
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                // Change alignment to start to give more space
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: const TextStyle(
                      fontFamily: "Sora", fontWeight: FontWeight.w600),
                  // Add overflow handling for long text
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            hint: Text(
              _selectedValue ??
                  (widget.items.isEmpty ? '' : widget.items.first),
              style: const TextStyle(
                  color: AppColors.linkColor,
                  fontFamily: "Sora",
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Add overflow handling
            ),
          ),
        ),
      );
    });
  }
}
