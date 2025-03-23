import 'package:e_assesment_kader_app/data/models/user_model.dart';
import 'package:e_assesment_kader_app/pages/detail_kader_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../style/colors/app_colors.dart';

class KaderItem extends StatelessWidget {
  final UserModel user;

  const KaderItem({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300.color),
      ),
      child: Row(
        children: [
          user.kelamin == "L"
              ? Image.asset(
                  "assets/img_male.png",
                  width: 50,
                  height: 50,
                )
              : Image.asset(
                  "assets/img_woman.png",
                  width: 50,
                  height: 50,
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 7),
                Text(
                  "Puskesmas ${user.puskesmas?.nama}",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          user.assessmentCompleted == false
              ? SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green500.color,
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ModulPage(kaderId: user.id!),
                      //     ));
                      context.goNamed('modul',
                          pathParameters: {'kaderId': user.id!.toString()});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Mulai\nAssesment",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey300.color,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailKaderPage(kaderId: user.id.toString()),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Lihat Detail",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
