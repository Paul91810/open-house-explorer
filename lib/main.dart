import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/listings_local_data_source.dart';
import 'data/listings_repository.dart';
import 'presentation/providers/listings_provider.dart';
import 'presentation/pages/listings_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const OpenHouseApp());
}

class OpenHouseApp extends StatelessWidget {
  const OpenHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ListingsRepository(
      localDataSource: ListingsLocalDataSource(),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ListingsProvider(repository: repository)..loadListings(),
        ),
      ],
      child: MaterialApp(
        title: 'Open House Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
        ),
        home: const ListingsPage(),
      ),
    );
  }
}