import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/kader_provider.dart';
import '../providers/preferences_provider.dart';
import '../static/kader_result_state.dart';
import '../widgets/kader_item.dart';

class SearchKaderPage extends StatefulWidget {
  final String query;

  const SearchKaderPage({required this.query, super.key});

  @override
  State<SearchKaderPage> createState() => _SearchKaderPageState();
}

class _SearchKaderPageState extends State<SearchKaderPage> {
  @override
  void initState() {
    super.initState();

    final prefProvider = context.read<PreferencesProvider>();
    final kaderProvider = context.read<KaderProvider>();

    Future.microtask(() {
      if (prefProvider.userToken != null) {
        kaderProvider.fetchKaderSearchList(
            prefProvider.userToken!, widget.query);
      } else {
        print("Token tidak ditemukan, tidak dapat mengambil data kader.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Page"),
      ),
      body: Consumer<KaderProvider>(
        builder: (context, provider, child) {
          final state = provider.resultState;

          if (state is KaderListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KaderListErrorState) {
            return Center(
              child: Text(
                "Error: ${provider.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            final kaderList = provider.kaders;
            if (kaderList == null || kaderList.isEmpty) {
              return const Center(
                child: Text("Tidak ada data kader.",
                    style: TextStyle(color: Colors.black54)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: kaderList.length,
              itemBuilder: (context, index) {
                final kader = kaderList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: KaderItem(user: kader),
                );
              },
            );
          }
        },
      ),
    );
  }
}
