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
  @override
  void initState() {
    super.initState();

    final prefProvider = context.read<PreferencesProvider>();
    final kaderProvider = context.read<KaderProvider>();

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
          title: Text(
            "Daftar Kader",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 255, 255)],
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Masukkan Nama Kader",
                          prefixIcon: Icon(Icons.search, color: AppColors.green400.color),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpKaderPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.green400.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Consumer<KaderProvider>(
                  builder: (context, provider, child) {
                    final state = provider.resultState;

                    if (state is KaderListLoadingState) {
                      return Center(child: CircularProgressIndicator(color: Colors.white));
                    } else if (provider.resultState is KaderListErrorState) {
                      return Center(
                        child: Text(
                          "Error: ${provider.message}",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      final kaderList = provider.kaders;

                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: kaderList?.length,
                        itemBuilder: (context, index) {
                          final kader = kaderList?[index];
                          return AnimatedOpacity(
                            opacity: 1,
                            duration: Duration(milliseconds: 500),
                            child: KaderItem(user: kader!),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}