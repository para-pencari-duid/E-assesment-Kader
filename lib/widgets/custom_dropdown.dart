import 'package:e_assesment_kader_app/style/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String title;
  final List<T>? items;
  final T? selectedValue;
  final String Function(T)? itemLabel;
  final ValueChanged<T?>? onChanged;
  const CustomDropdown({
    super.key,
    required this.title,
    this.items,
    this.selectedValue,
    this.itemLabel,
    this.onChanged,
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300.color, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              hint: Text(
                "Select $title",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              value: selectedValue,
              items: items?.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel!(item)), // Menggunakan fungsi itemLabel
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
