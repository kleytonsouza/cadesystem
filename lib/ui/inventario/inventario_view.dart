import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/midia_service.dart';
import '../../data/services/reconhecimento_service.dart';
import '../registrar/registrar_view.dart';
import 'inventario_view_model.dart';

class InventarioView extends StatelessWidget {
  const InventarioView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InventarioViewModel(
        midia: context.read<MidiaService>(),
        reconhecimento: context.read<ReconhecimentoService>(),
      ),
      child: const _InventarioConteudo(),
    );
  }
}

class _InventarioConteudo extends StatefulWidget {
  const _InventarioConteudo();

  @override
  State<_InventarioConteudo> createState() => _InventarioConteudoState();
}

class _InventarioConteudoState extends State<_InventarioConteudo> {
  final _nome = TextEditingController();

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  Future<void> _escolherFoto() async {
    final viewModel = context.read<InventarioViewModel>();
    final fotoAnterior = viewModel.foto;
    await viewModel.escolherFoto();
    if (!mounted) return;
    if (viewModel.foto != fotoAnterior) {
      final sugestoes = viewModel.sugestoes;
      _nome.text = sugestoes.isEmpty ? '' : sugestoes.first.nome;
    }
    setState(() {});
  }

  Future<void> _abrirCadastro() async {
    final nome = _nome.text.trim();
    final viewModel = context.read<InventarioViewModel>();
    if (nome.isEmpty || viewModel.foto == null) return;
    final foto = viewModel.transferirFoto();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RegistrarView(nomeInicial: nome, fotoInicial: foto),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<InventarioViewModel>();
    final foto = viewModel.foto;
    return PopScope(
      canPop: !viewModel.ocupado,
      child: Scaffold(
        appBar: AppBar(title: const Text('Inventário por foto')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Escolha uma foto para receber sugestões de objetos. '
                    'Confira o nome antes de registrar.',
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: viewModel.ocupado ? null : _escolherFoto,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(foto == null ? 'Escolher foto' : 'Trocar foto'),
                  ),
                  if (viewModel.ocupado) ...[
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()),
                  ],
                  if (foto != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(
                          context.read<MidiaService>().caminho(
                            foto.caminhoRelativo,
                          ),
                        ),
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Text('Foto indisponível.'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (viewModel.sugestoes.isNotEmpty) ...[
                      const Text('Sugestões encontradas'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final sugestao in viewModel.sugestoes)
                            ActionChip(
                              label: Text(sugestao.nome),
                              onPressed: () =>
                                  setState(() => _nome.text = sugestao.nome),
                            ),
                        ],
                      ),
                    ] else if (!viewModel.ocupado && viewModel.erro == null)
                      const Text(
                        'Nenhuma sugestão encontrada. Informe o nome abaixo.',
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nome,
                      maxLength: 50,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nome do objeto',
                        helperText:
                            'A sugestão pode estar em inglês ou imprecisa.',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: viewModel.ocupado || _nome.text.trim().isEmpty
                          ? null
                          : _abrirCadastro,
                      icon: const Icon(Icons.add_box_outlined),
                      label: const Text('Registrar objeto'),
                    ),
                  ],
                  if (viewModel.erro != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      viewModel.erro!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
