import 'package:flutter/material.dart';

import '../style/colors/app_colors.dart';

class ListItem extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final String? total;
  const ListItem({this.title, this.imageUrl, this.total, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300.color),
      ),
      child: Row(
        children: [
          Image.asset(
            imageUrl!,
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data $title",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 7),
              Text("Jumlah $title Saat ini: $total",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          )
        ],
      ),
    );
  }
}
