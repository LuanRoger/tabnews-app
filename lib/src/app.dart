import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tabnews/src/constants.dart';
import 'package:tabnews/src/providers/content.dart';
import 'package:tabnews/src/providers/user.dart';
import 'package:tabnews/src/ui/layouts/tab.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ContentProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'TabNews',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Colors.white60,
            secondary: Colors.white60,
          ),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.grey.shade700,
          ),
        ),
        theme: ThemeData(
          primaryColor: Colors.black,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryColor,
            secondary: AppColors.primaryColor,
          ),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.grey.shade300,
          ),
        ),
        home: const TabLayout(),
      ),
    );
  }
}
