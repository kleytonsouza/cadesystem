import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/categoria_repository.dart';
import '../../data/repositories/local_repository.dart';
import '../../data/repositories/objeto_repository.dart';
import '../../data/services/midia_service.dart';
import '../../domain/models/objeto_detalhe.dart';
import '../core/base_view_model.dart';
import '../detalhe/detalhe_view.dart';
import '../registrar/registrar_view.dart';
import 'buscar_view_model.dart';

class BuscarView extends StatefulWidget {
  const BuscarView({super.key});

  @override
  State<BuscarView> createState() => _BuscarViewState();
}

class _BuscarViewState extends State<BuscarView> {
  late final TextEditingController _pesquisa;

  @override
  void initState() {
    super.initState();
    _pesquisa = TextEditingController();
  }

  @override
  void dispose() {
    _pesquisa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BuscarViewModel(
        objetos: context.read<ObjetoRepository>(),
        locais: context.read<LocalRepository>(),
        categorias: context.read<CategoriaRepository>(),
      )..iniciar(),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<BuscarViewModel>();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Itens salvos'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _pesquisa,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Buscar por nome, local ou categoria',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.termoAlterado,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildConteudo(viewModel),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConteudo(BuscarViewModel viewModel) {
    switch (viewModel.estado) {
      case EstadoTela.carregando:
        return const Center(child: CircularProgressIndicator());
      case EstadoTela.erro:
        return Center(
          child: Text(viewModel.mensagemErro ?? 'Não foi possível carregar.'),
        );
      case EstadoTela.vazio:
        return const Center(
          child: Text('Nenhum item encontrado no seu histórico.'),
        );
      case EstadoTela.sucesso:
      case EstadoTela.inicial:
        return ListView.separated(
          itemCount: viewModel.resultados.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = viewModel.resultados[index];
            return _ItemListaCard(item: item);
          },
        );
    }
  }
}

class HistoricoView extends StatelessWidget {
  const HistoricoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BuscarViewModel(
        objetos: context.read<ObjetoRepository>(),
        locais: context.read<LocalRepository>(),
        categorias: context.read<CategoriaRepository>(),
      )..iniciar(),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<BuscarViewModel>();
          final midia = context.read<MidiaService>();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Histórico'),
            ),
            body: switch (viewModel.estado) {
              EstadoTela.carregando => const Center(
                  child: CircularProgressIndicator(),
                ),
              EstadoTela.erro => Center(
                  child: Text(viewModel.mensagemErro ?? 'Não foi possível carregar.'),
                ),
              EstadoTela.vazio => const Center(
                  child: Text('Nenhum item no histórico.'),
                ),
              EstadoTela.inicial || EstadoTela.sucesso => ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.resultados.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = viewModel.resultados[index];
                    final foto = item.objeto.fotoPath;

                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: SizedBox(
                          width: 72,
                          height: 72,
                          child: foto == null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.image_not_supported_outlined),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(midia.caminho(foto)),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.broken_image_outlined),
                                    ),
                                  ),
                                ),
                        ),
                        title: Text(item.objeto.nome),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Local: ${item.local.nome}'),
                            Text('Registrado: ${_formatarData(item.objeto.registradoEm)}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar item',
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              iconSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _abrirEdicao(context, item),
                            ),
                            IconButton(
                              tooltip: 'Excluir item',
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              iconSize: 18,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _excluirItem(context, viewModel, item),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.chevron_right, size: 18),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DetalheView(objetoId: item.objeto.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            },
          );
        },
      ),
    );
  }
}

Future<void> _abrirEdicao(BuildContext context, ObjetoDetalhe item) async {
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => RegistrarView(objetoId: item.objeto.id),
    ),
  );
  if (!context.mounted) return;
  context.read<BuscarViewModel>().buscar();
}

Future<void> _excluirItem(
  BuildContext context,
  BuscarViewModel viewModel,
  ObjetoDetalhe item,
) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir item?'),
      content: Text('Deseja remover "${item.objeto.nome}" do histórico?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );

  if (confirmar != true) return;

  final sucesso = await viewModel.excluirItem(item.objeto.id);
  if (!context.mounted) return;

  if (sucesso) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removido do histórico com sucesso.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Não foi possível excluir este item.'),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class _ItemListaCard extends StatelessWidget {
  const _ItemListaCard({required this.item});

  final ObjetoDetalhe item;

  @override
  Widget build(BuildContext context) {
    final local = item.local.nome;
    final categoria = item.categoria?.nome ?? 'Sem categoria';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.inventory_2_outlined),
      ),
      title: Text(item.objeto.nome),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Local: $local'),
          Text('Categoria: $categoria'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Editar item',
            visualDensity: VisualDensity.compact,
            splashRadius: 18,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            iconSize: 18,
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _abrirEdicao(context, item),
          ),
          IconButton(
            tooltip: 'Excluir item',
            visualDensity: VisualDensity.compact,
            splashRadius: 18,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            iconSize: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _excluirItem(context, context.read<BuscarViewModel>(), item),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.chevron_right, size: 18),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetalheView(objetoId: item.objeto.id),
          ),
        );
      },
    );
  }
}

String _formatarData(DateTime valor) {
  final local = valor.toLocal();
  final dia = local.day.toString().padLeft(2, '0');
  final mes = local.month.toString().padLeft(2, '0');
  final ano = local.year;
  final hora = local.hour.toString().padLeft(2, '0');
  final minuto = local.minute.toString().padLeft(2, '0');
  return '$dia/$mes/$ano $hora:$minuto';
}
