import 'package:buget_tracker_app/screens/deals.dart';
import 'package:buget_tracker_app/screens/home.dart';
import 'package:buget_tracker_app/services/budget_service.dart';
import 'package:buget_tracker_app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({required this.sharedPreferences, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService(sharedPreferences)),
          ChangeNotifierProvider(create: (_) => BudgetService()),
        ],
        child: Builder(
          builder: (BuildContext context) {
            final themeService = context.watch<ThemeService>();
            // listen = true here would be context.watch

            // default of provider is listen = true so you would need to deliberately set it false.
            // final themeService = Provider.of<ThemeService>(context);  < alternative method to write this

            return MaterialApp(
              title: 'Budget Tracker',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.indigo,
                      brightness: themeService.darkTheme
                          ? Brightness.dark
                          : Brightness.light)),
              initialRoute: '/',
              routes: {
                '/':(context) => Home(title: "Budget Tracker",),
                '/deals':(context) => DealScreen(),
              }

            );
          },
        ));
  }
}
