import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'registrar_view_model.dart';
import '../core/audio_playback_button.dart';
import '../core/base_view_model.dart';
import '../../data/services/midia_service.dart';

class RegistrarView extends StatelessWidget {
  const RegistrarView({
    this.objetoId,
    this.focarLocal = false,
    this.nomeInicial,
    this.fotoInicial,
    super.key,
  });

  final int? objetoId;
  final bool focarLocal;
  final String? nomeInicial;
  final MidiaSalva? fotoInicial;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegistrarViewModel(
        objetos: context.read(),
        locais: context.read(),
        categorias: context.read(),
        midia: context.read(),
        permissoes: context.read(),
      ),
      child: _RegistrarFormulario(
        objetoId: objetoId,
        focarLocal: focarLocal,
        nomeInicial: nomeInicial,
        fotoInicial: fotoInicial,
      ),
    );
  }
}

class _RegistrarFormulario extends StatefulWidget {
  const _RegistrarFormulario({
    this.objetoId,
    required this.focarLocal,
    this.nomeInicial,
    this.fotoInicial,
  });

  final int? objetoId;
  final bool focarLocal;
  final String? nomeInicial;
  final MidiaSalva? fotoInicial;

  @override
  State<_RegistrarFormulario> createState() => _RegistrarViewState();
}

class _RegistrarViewState extends State<_RegistrarFormulario> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _local = TextEditingController();
  final _focoLocal = FocusNode();
  bool _carregando = true;
  bool _registroCarregado = false;
  bool _fotografando = false;
  bool _limpando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final viewModel = context.read<RegistrarViewModel>();
      await viewModel.iniciar(
        objetoId: widget.objetoId,
        nomeInicial: widget.nomeInicial,
        fotoInicial: widget.fotoInicial,
      );
      if (!mounted) return;
      _nome.text = viewModel.nome;
      _local.text = viewModel.nomeLocal;
      setState(() => _carregando = false);
      _registroCarregado = viewModel.estado == EstadoTela.sucesso;
      if (widget.focarLocal && viewModel.estado == EstadoTela.sucesso) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _focoLocal.requestFocus();
        });
      }
    });
  }

  @override
  void dispose() {
    _nome.dispose();
    _local.dispose();
    _focoLocal.dispose();
    super.dispose();
  }

  Future<void> _limpar() async {
    if (widget.objetoId != null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _limpando = true);
    try {
      await context.read<RegistrarViewModel>().limparFormulario();
      if (!mounted) return;
      _nome.clear();
      _local.clear();
      _formulario.currentState?.reset();
      FocusScope.of(context).unfocus();
    } finally {
      if (mounted) setState(() => _limpando = false);
    }
  }

  Future<void> _salvar() async {
    if (!_formulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final viewModel = context.read<RegistrarViewModel>();
    final salvo = await viewModel.salvar();
    if (!mounted || !salvo) return;

    if (viewModel.emModoEdicao) {
      Navigator.of(context).pop();
      return;
    }

    await _limpar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Objeto salvo no seu aparelho.')),
    );
  }

  Future<void> _tirarFoto() async {
    final viewModel = context.read<RegistrarViewModel>();
    final continuar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Foto do objeto'),
        content: Text(viewModel.motivoCamera),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Usar câmera'),
          ),
        ],
      ),
    );
    if (!mounted || continuar != true) return;
    setState(() => _fotografando = true);
    try {
      await viewModel.adicionarFotoDoObjeto();
    } finally {
      if (mounted) setState(() => _fotografando = false);
    }
  }

  Future<void> _iniciarGravacao() async {
    final viewModel = context.read<RegistrarViewModel>();
    final continuar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gravar áudio'),
        content: Text(
          '${viewModel.motivoMicrofone}\n\n'
          'Você também pode escrever o local sem usar o microfone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Usar microfone'),
          ),
        ],
      ),
    );
    if (mounted && continuar == true) await viewModel.iniciarGravacao();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistrarViewModel>();
    final ocupado =
        _carregando || viewModel.salvando || _fotografando || _limpando;
    final aviso = viewModel.aviso;

    return PopScope(
      canPop: !ocupado,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/branding/cade-icon.png',
                  width: 36,
                  height: 36,
                  cacheWidth: 108,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Cadê?'),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formulario,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/branding/cade-drawer.png',
                        height: 120,
                        cacheWidth: 360,
                        semanticLabel: 'Documento guardado em uma gaveta',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        viewModel.emModoEdicao
                            ? 'Editar objeto'
                            : 'Novo objeto',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        viewModel.emModoEdicao
                            ? 'Atualize as informações deste item e preserve o histórico.'
                            : 'Registre onde guardou para encontrar depois.',
                      ),
                      const SizedBox(height: 24),
                      const Text('Nome do objeto *'),
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'Nome do objeto, obrigatório',
                        child: TextFormField(
                          key: const ValueKey('nome-objeto'),
                          controller: _nome,
                          enabled: !ocupado,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                            hintText: 'Ex.: Documento X',
                            errorMaxLines: 3,
                          ),
                          maxLength: RegistrarViewModel.limiteNome,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          onChanged: viewModel.nomeAlterado,
                          validator: (valor) =>
                              viewModel.validarNome(valor ?? ''),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Onde você guardou? *'),
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'Onde você guardou, obrigatório',
                        child: TextFormField(
                          key: const ValueKey('local-objeto'),
                          controller: _local,
                          focusNode: _focoLocal,
                          enabled: !ocupado,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.location_on_outlined),
                            hintText: 'Ex.: Gaveta do escritório',
                            errorMaxLines: 3,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                          onChanged: viewModel.nomeLocalAlterado,
                          validator: (valor) =>
                              viewModel.validarLocal(valor ?? ''),
                          onFieldSubmitted: (_) {
                            if (!ocupado) _salvar();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Fotos do objeto (opcionais)'),
                      const SizedBox(height: 8),
                      for (final caminho in viewModel.fotosObjeto) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(context.read<MidiaService>().caminho(caminho)),
                            height: 180,
                            fit: BoxFit.cover,
                            semanticLabel: 'Foto do objeto',
                            errorBuilder: (_, _, _) => const SizedBox(
                              height: 80,
                              child: Center(child: Text('Foto indisponível.')),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: ocupado
                              ? null
                              : () => viewModel.removerFoto(caminho),
                          child: const Text('Remover foto'),
                        ),
                      ],
                      OutlinedButton.icon(
                        onPressed: ocupado ? null : _tirarFoto,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(
                          _fotografando ? 'Abrindo câmera…' : 'Adicionar foto',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Áudio do objeto (opcional)'),
                      const SizedBox(height: 8),
                      if (viewModel.caminhoAudio != null) ...[
                        AudioPlaybackButton(
                          caminho: context.read<MidiaService>().caminho(
                            viewModel.caminhoAudio!,
                          ),
                        ),
                        TextButton(
                          onPressed: ocupado || viewModel.gravando
                              ? null
                              : viewModel.removerAudio,
                          child: const Text('Remover áudio'),
                        ),
                      ],
                      OutlinedButton.icon(
                        onPressed: ocupado
                            ? null
                            : viewModel.gravando
                            ? viewModel.pararGravacao
                            : _iniciarGravacao,
                        icon: Icon(
                          viewModel.gravando
                              ? Icons.stop_circle_outlined
                              : Icons.mic_none_outlined,
                        ),
                        label: Text(
                          viewModel.gravando
                              ? 'Parar gravação'
                              : 'Gravar áudio',
                        ),
                      ),
                      if (aviso != null) ...[
                        const SizedBox(height: 8),
                        Text(aviso.mensagem),
                        if (aviso.podeAbrirConfiguracoes)
                          TextButton(
                            onPressed: ocupado
                                ? null
                                : viewModel.abrirConfiguracoes,
                            child: const Text('Abrir configurações'),
                          ),
                      ],
                      const SizedBox(height: 16),
                      const Text(
                        '* Nome e local são obrigatórios. '
                        'A data é preenchida ao salvar.',
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
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed:
                            ocupado || viewModel.gravando || !_registroCarregado
                            ? null
                            : _salvar,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(
                          viewModel.salvando
                              ? 'Salvando…'
                              : viewModel.emModoEdicao
                              ? 'Salvar alterações'
                              : 'Salvar objeto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: ocupado ? null : _limpar,
                        icon: const Icon(Icons.close),
                        label: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
