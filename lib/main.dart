import 'package:flutter/material.dart';
import 'package:rick_and_morty/app/theme/app_theme.dart';
import 'package:rick_and_morty/features/characteres/presentation/pages/characters_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const CharactersPage(),
    );
  }
}
