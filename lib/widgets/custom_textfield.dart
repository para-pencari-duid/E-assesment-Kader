import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/colors/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  final String title;
  final TextInputType? textInputType;
  final bool obsecureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextfield({
    required this.title,
    this.textInputType,
    this.obsecureText = false,
    this.controller,
    this.validator,
    super.key,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late ValueNotifier<bool> isObscured;
  late ValueNotifier<String?> errorText;

  @override
  void initState() {
    super.initState();
    isObscured = ValueNotifier<bool>(widget.obsecureText);
    errorText = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    isObscured.dispose();
    errorText.dispose();
    super.dispose();
  }

  List<TextInputFormatter> getInputFormatters() {
    if (widget.textInputType == TextInputType.text) {
      return [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$'))];
    } else if (widget.textInputType == TextInputType.number ||
        widget.textInputType == TextInputType.phone) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return [];
  }

  // Validasi input sesuai tipe field
  void validateInput(String value) {
    if (value.isEmpty) {
      errorText.value = "${widget.title} tidak boleh kosong";
    } else if (widget.textInputType == TextInputType.text &&
        !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      errorText.value = "Inputan hanya berisi huruf";
    } else if ((widget.textInputType == TextInputType.number ||
            widget.textInputType == TextInputType.phone) &&
        !RegExp(r'^\d+$').hasMatch(value)) {
      errorText.value = "Inputan hanya berisi angka";
    } else {
      errorText.value = null; // Hapus error jika valid
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
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
              keyboardType: widget.textInputType,
              obscureText: value,
              controller: widget.controller,
              inputFormatters: getInputFormatters(),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Masukkan ${widget.title}",
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
                suffixIcon: widget.obsecureText
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
              onChanged: (value) {
                validateInput(value);
              },
            );
          },
        ),
        const SizedBox(height: 5),
        ValueListenableBuilder<String?>(
          valueListenable: errorText,
          builder: (context, error, child) {
            return error != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
