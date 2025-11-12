import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/catalog/data/api/catalog_api.dart';
import '../features/catalog/data/repository/catalog_repository_impl.dart';
import '../features/catalog/domain/repository/catalog_repository.dart';
import '../features/catalog/presentation/bloc/catalog_bloc.dart';
import '../features/catalog/presentation/pages/catalog_page.dart';

class App extends StatelessWidget {
  final Dio dio;

  const App({required this.dio, super.key});

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<Dio>.value(value: dio),
      RepositoryProvider<CatalogApi>(
        create: (context) => CatalogApi(context.read<Dio>()),
      ),
      RepositoryProvider<CatalogRepository>(
        create: (context) =>
            CatalogRepositoryImpl(api: context.read<CatalogApi>()),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<CatalogBloc>(
          create: (context) =>
              CatalogBloc(repository: context.read<CatalogRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop Demo',
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: const CatalogPage(),
      ),
    ),
  );
}
