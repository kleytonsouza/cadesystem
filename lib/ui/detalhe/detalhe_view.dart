import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/objeto_repository.dart';
import '../../data/services/midia_service.dart';
import '../core/audio_playback_button.dart';
import '../core/base_view_model.dart';
import 'detalhe_view_model.dart';
import '../registrar/registrar_view.dart';

class DetalheView extends StatefulWidget {
  const DetalheView({required this.objetoId, super.key});

  final int objetoId;

  @override
  State<DetalheView> createState() => _DetalheViewState();
}

class _DetalheViewState extends State<DetalheView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetalheViewModel(
        objetoId: widget.objetoId,
        objetos: context.read<ObjetoRepository>(),
      )..carregar(),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<DetalheViewModel>();
          final detalhe = viewModel.detalhe;

          return Scaffold(
            appBar: AppBar(
              title: Text(detalhe?.objeto.nome ?? 'Detalhes'),
              actions: [
                IconButton(
                  tooltip: 'Editar local',
                  icon: const Icon(Icons.edit_location_alt_outlined),
                  onPressed: detalhe == null || viewModel.ocupado
                      ? null
                      : () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => RegistrarView(
                                objetoId: widget.objetoId,
                                focarLocal: true,
                              ),
                            ),
                          );
                          if (!context.mounted) return;
                          await viewModel.carregar();
                        },
                ),
              ],
            ),
            body: _buildBody(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DetalheViewModel viewModel) {
    final detalhe = viewModel.detalhe;
    final midia = context.read<MidiaService>();

    if (viewModel.estado == EstadoTela.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.estado == EstadoTela.erro || detalhe == null) {
      return Center(
        child: Text(viewModel.mensagemErro ?? 'Objeto não encontrado.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detalhe.objeto.fotoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(midia.caminho(detalhe.objeto.fotoPath!)),
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Text('Foto indisponível.')),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detalhe.objeto.nome,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _Pill(label: 'Local', value: detalhe.local.nome),
                      if (detalhe.categoria != null)
                        _Pill(
                          label: 'Categoria',
                          value: detalhe.categoria!.nome,
                        ),
                      _Pill(
                        label: 'Data',
                        value: _formatarData(detalhe.objeto.registradoEm),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (detalhe.objeto.descricao != null &&
                      detalhe.objeto.descricao!.trim().isNotEmpty)
                    Text(detalhe.objeto.descricao!),
                  if (detalhe.objeto.audioPath != null) ...[
                    const SizedBox(height: 12),
                    AudioPlaybackButton(
                      caminho: midia.caminho(detalhe.objeto.audioPath!),
                    ),
                  ],
                  if (viewModel.registroAntigo) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Este item não foi confirmado há muito tempo.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Histórico de alteração',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if (viewModel.historico.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Ainda não houve alteração de local para este item.',
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.historico.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final evento = viewModel.historico[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('${evento.localAntigo} → ${evento.localNovo}'),
                  subtitle: Text(
                    'Atualizado em ${_formatarData(evento.alteradoEm)}',
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: viewModel.ocupado
                      ? null
                      : () async {
                          final ok = await viewModel.confirmarLocal();
                          if (!mounted || !ok) return;
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Confirmação registrada.'),
                            ),
                          );
                        },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirmar local'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: viewModel.ocupado
                      ? null
                      : () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Excluir item?'),
                              content: const Text(
                                'Essa ação remove o item salvo e seu histórico.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );

                          if (!mounted || confirmar != true) return;
                          final sucesso = await viewModel.excluir();
                          if (!mounted || !sucesso) return;
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Excluir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label: $value'),
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
