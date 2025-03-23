import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String title;
  final List<T>? items;
  final T? selectedValue;
  final String Function(T)? itemLabel;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator; // ✅ Tambahkan validator

  const CustomDropdown({
    super.key,
    required this.title,
    this.items,
    this.selectedValue,
    this.itemLabel,
    this.onChanged,
    this.validator, // ✅ Tambahkan validator
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 15),
        DropdownButtonFormField<T>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          value: selectedValue,
          items: items?.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel!(item)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator, // ✅ Gunakan validator
          hint: Text("Select $title"),
        ),
      ],
    );
  }
}
