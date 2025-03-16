import 'package:e_assesment_kader_app/pages/sign_up_kader_page.dart';
import 'package:e_assesment_kader_app/providers/kader_provider.dart';
import 'package:e_assesment_kader_app/static/kader_result_state.dart';
import 'package:e_assesment_kader_app/style/colors/app_colors.dart';
import 'package:e_assesment_kader_app/widgets/kader_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';

class ListKaderPage extends StatefulWidget {
  const ListKaderPage({super.key});

  @override
  State<ListKaderPage> createState() => _ListKaderPageState();
}

class _ListKaderPageState extends State<ListKaderPage> {
  // final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final prefProvider = context.read<PreferencesProvider>();
    final kaderProvider = context.read<KaderProvider>();

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >=
    //       scrollController.position.maxScrollExtent) {
    //     if (kaderProvider.pageItems != null &&
    //         kaderProvider.resultState is! KaderListLoadingState) {
    //       kaderProvider.fetchKaderList(prefProvider.userToken!);
    //     }
    //   }
    // });
    Future.microtask(
      () {
        if (prefProvider.userToken != null) {
          kaderProvider.fetchKaderList(prefProvider.userToken!);
        } else {
          print("Token tidak ditemukan, tidak dapat mengambil data kader.");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Daftar Kader"),
          // centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama Kader",
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: AppColors.grey300.color), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    // context.goNamed("register-kader");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpKaderPage(),
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.green400.color,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
            Consumer<KaderProvider>(
              builder: (context, provider, child) {
                final state = provider.resultState;

                if (state is KaderListLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.resultState is KaderListErrorState) {
                  return Text("Error: ${provider.message}");
                } else {
                  final kaderList = provider.kaders;

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: kaderList?.length,
                    itemBuilder: (context, index) {
                      final kader = kaderList?[index];
                      return KaderItem(user: kader!);
                    },
                  );
                }
              },
            ),
            // Consumer<KaderProvider>(
            //   builder: (context, provider, child) {
            //     final state = provider.resultState;

            //     if (state is KaderListLoadingState && provider.pageItems == 1) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (provider.resultState is KaderListErrorState) {
            //       return Text("Error: ${provider.message}");
            //     } else {
            //       final kaderList = provider.kaders;

            //       return ListView.builder(
            //         physics: NeverScrollableScrollPhysics(),
            //         shrinkWrap: true,
            //         controller: scrollController,
            //         itemCount: kaderList!.length +
            //             (provider.pageItems != null ? 1 : 0),
            //         itemBuilder: (context, index) {
            //           if (index >= kaderList.length) {
            //             return Center(
            //                 child:
            //                     CircularProgressIndicator()); // Indikator loading untuk pagination
            //           }

            //           final kader = kaderList[index];
            //           return KaderItem(user: kader);
            //         },
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
