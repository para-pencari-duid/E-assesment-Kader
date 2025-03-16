import 'package:flutter/material.dart';

import '../style/colors/app_colors.dart';

// ignore: must_be_immutable
class CustomTextfield extends StatelessWidget {
  final String title;
  final TextInputType? textInputType;
  final bool obsecureText;
  final TextEditingController? controller;

  CustomTextfield({
    required this.title,
    this.textInputType,
    this.obsecureText = false,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isObscured = ValueNotifier<bool>(obsecureText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: isObscured,
          builder: (context, value, child) {
            return TextFormField(
              keyboardType: textInputType,
              obscureText: value,
              controller: controller,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Masukkan $title",
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.grey300.color),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: AppColors.grey300.color),
                  borderRadius: BorderRadius.circular(7.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 2, color: AppColors.green500.color),
                  borderRadius: BorderRadius.circular(7.0),
                ),
                suffixIcon: obsecureText
                    ? IconButton(
                        icon: Icon(
                          value ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.grey300.color,
                        ),
                        onPressed: () {
                          isObscured.value = !isObscured.value;
                        },
                      )
                    : null,
              ),
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
