import 'package:e_assesment_kader_app/data/datasources/auth_service.dart';
import 'package:e_assesment_kader_app/data/datasources/kader_service.dart';
import 'package:e_assesment_kader_app/data/datasources/modul_service.dart';
import 'package:e_assesment_kader_app/data/datasources/preferences_helper.dart';
import 'package:e_assesment_kader_app/providers/answer_provider.dart';
import 'package:e_assesment_kader_app/providers/kader_provider.dart';
import 'package:e_assesment_kader_app/providers/modul_provider.dart';
import 'package:e_assesment_kader_app/providers/pertanyaan_provider.dart';
import 'package:e_assesment_kader_app/providers/preferences_provider.dart';
import 'package:e_assesment_kader_app/providers/puskesmas_provider.dart';
import 'package:e_assesment_kader_app/providers/result_kader_provider.dart';
import 'package:e_assesment_kader_app/providers/submodul_provider.dart';
import 'package:e_assesment_kader_app/providers/user_provider.dart';
import 'package:e_assesment_kader_app/routes/routes.dart';
import 'package:e_assesment_kader_app/style/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  debugPrint("Token sebelum loadUserToken: ${prefs.getString('MY_TOKEN')}");
  final prefProvider = PreferencesProvider(PreferencesHelper(prefs));

  // Pastikan token dimuat sebelum runApp
  await prefProvider.init();

  debugPrint("Token setelah loadUserToken: ${prefProvider.userToken}");

  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => AuthService(),
    ),
    Provider(
      create: (context) => KaderService(),
    ),
    Provider(
      create: (context) => ModulService(),
    ),
    ChangeNotifierProvider(
      create: (context) => PuskesmasProvider(context.read<AuthService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => UserProvider(context.read<AuthService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => KaderProvider(context.read<KaderService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => ModulProvider(context.read<ModulService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => SubmodulProvider(context.read<ModulService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => QuestionProvider(context.read<ModulService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => AnswerProvider(context.read<ModulService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => ResultKaderProvider(context.read<KaderService>()),
    ),
    ChangeNotifierProvider(
      create: (_) => prefProvider,
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferencesProvider>(context, listen: true);

    return MaterialApp.router(
      title: 'E-Assesment Kader',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: routerConfig(context, provider),
    );
  }
}
