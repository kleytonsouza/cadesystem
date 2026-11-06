import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/categoria_repository.dart';
import 'data/repositories/local_repository.dart';
import 'data/repositories/objeto_repository.dart';
import 'data/services/cade_database.dart';
import 'data/services/midia_service.dart';
import 'data/services/permissao_service.dart';
import 'ui/home/home_view.dart';

/// Mantém as dependências pelo tempo de vida do aplicativo e as libera ao sair.
class CadeApp extends StatefulWidget {
  const CadeApp({required this.banco, required this.midia, super.key});

  final CadeDatabase banco;
  final MidiaService midia;

  @override
  State<CadeApp> createState() => _CadeAppState();
}

class _CadeAppState extends State<CadeApp> {
  @override
  void dispose() {
    unawaited(widget.banco.close());
    unawaited(widget.midia.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CadeDatabase>.value(value: widget.banco),
        Provider<MidiaService>.value(value: widget.midia),
        Provider(create: (_) => PermissaoService()),
        Provider(
          create: (context) => CategoriaRepository(banco: context.read()),
        ),
        Provider(
          create: (context) =>
              LocalRepository(banco: context.read(), midia: context.read()),
        ),
        Provider(
          create: (context) => ObjetoRepository(
            banco: context.read(),
            midia: context.read(),
            categorias: context.read(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Cadê?',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const HomeView(),
      ),
    );
  }
}
