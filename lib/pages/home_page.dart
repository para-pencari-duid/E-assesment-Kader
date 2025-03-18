import 'package:e_assesment_kader_app/pages/list_kader_page.dart';
import 'package:e_assesment_kader_app/providers/puskesmas_provider.dart';
import 'package:e_assesment_kader_app/providers/user_provider.dart';
import 'package:e_assesment_kader_app/style/colors/app_colors.dart';
import 'package:e_assesment_kader_app/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/kader_provider.dart';
import '../providers/preferences_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final prefProvider = context.read<PreferencesProvider>();
    final kaderProvider = context.read<KaderProvider>();
    final puskesmasProvider = context.read<PuskesmasProvider>();

    print("TOKEN DIHOME PAGE: ${prefProvider.userToken}");
    Future.microtask(
      () {
        // Pastikan token tidak null sebelum melakukan request
        if (prefProvider.userToken != null) {
          kaderProvider.fetchKaderList(prefProvider.userToken!);
          puskesmasProvider.fetchPuskesmasList();
        } else {
          print("Token tidak ditemukan, tidak dapat mengambil data kader.");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PreferencesProvider provider = Provider.of(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Text(
                      "Selamat Datang,\n${provider.username}!",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "Puskemas -",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    final confirmLogout = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Konfirmasi Logout"),
                          content: Text(
                              "Apakah Anda yakin ingin keluar dari aplikasi?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // Batalkan logout
                              },
                              child: Text("Batal"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // Konfirmasi logout
                              },
                              child: Text(
                                "Logout",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmLogout == true) {
                      final prefProvider =
                          context.read<PreferencesProvider>();
                      final userProvider = context.read<UserProvider>();

                      await userProvider.logoutUser (prefProvider.userToken!);
                      await prefProvider.removeUsername();
                      await prefProvider.removeUserToken();

                      context.go("/login");
                    }
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 65),
            Text("Menu",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  context.goNamed('kader');
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.blue300.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img_assesment.png",
                        width: 53,
                        height: 53,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Assesment Kader",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text("Laporan Data",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 15),
            ListItem(
              title: "Penilai",
              imageUrl: "assets/img_audience.png",
              total: "0000",
            ),
            const SizedBox(height: 15),
            Consumer<KaderProvider>(
              builder: (context, provider, child) {
                return ListItem(
                  title: "Kader",
                  imageUrl: "assets/img_audience.png",
                  total: provider.response?.totalKader.toString() ?? "-",
                );
              },
            ),
            const SizedBox(height: 15),
            Consumer<PuskesmasProvider>(
              builder: (context, provider, child) {
                return ListItem(
                  title: "Puskesmas",
                  imageUrl: "assets/img_hospital.png",
                  total: provider.totalData.toString(),
                );
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}