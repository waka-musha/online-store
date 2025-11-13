import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_cubit.dart';
import '../features/cart/presentation/bloc/cart_bloc.dart';
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
        create: (context) => CatalogRepositoryImpl(
          api: context.read<CatalogApi>(),
        ),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<CatalogBloc>(
          create: (context) => CatalogBloc(
            repository: context.read<CatalogRepository>(),
          ),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop Demo',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeState.mode,
          home: const CatalogPage(),
        ),
      ),
    ),
  );
}
