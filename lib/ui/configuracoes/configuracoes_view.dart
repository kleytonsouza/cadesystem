import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/backup_service.dart';
import '../../data/services/midia_service.dart';
import 'configuracoes_view_model.dart';

class ConfiguracoesView extends StatelessWidget {
  const ConfiguracoesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfiguracoesViewModel(
        midia: context.read<MidiaService>(),
        backup: context.read<BackupService>(),
      )..carregar(),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<ConfiguracoesViewModel>();
          return Scaffold(
            appBar: AppBar(title: const Text('Configurações')),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  ListTile(
                    leading: const Icon(Icons.storage_outlined),
                    title: const Text('Espaço usado por fotos e áudios'),
                    subtitle: Text(viewModel.espacoFormatado),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'O backup inclui os registros e as mídias salvas. '
                    'Escolha onde guardar o arquivo ZIP e mantenha uma cópia segura.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: viewModel.exportando
                        ? null
                        : () async {
                            final salvo = await viewModel.exportarBackup();
                            if (salvo != true || !context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Backup exportado.'),
                              ),
                            );
                          },
                    icon: const Icon(Icons.archive_outlined),
                    label: Text(
                      viewModel.exportando
                          ? 'Preparando backup…'
                          : 'Exportar backup',
                    ),
                  ),
                  if (viewModel.mensagemErro != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      viewModel.mensagemErro!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
