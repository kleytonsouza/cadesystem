import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'registrar_view_model.dart';

class RegistrarView extends StatefulWidget {
  const RegistrarView({this.objetoId, super.key});

  final int? objetoId;

  @override
  State<RegistrarView> createState() => _RegistrarViewState();
}

class _RegistrarViewState extends State<RegistrarView> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _local = TextEditingController();
  bool _fotografando = false;
  bool _limpando = false;

  @override
  void initState() {
    super.initState();
    if (widget.objetoId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final viewModel = context.read<RegistrarViewModel>();
        await viewModel.prepararEdicao(widget.objetoId!);
        if (!mounted) return;
        _nome.text = viewModel.nome;
        _local.text = viewModel.nomeLocal;
      });
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _local.dispose();
    super.dispose();
  }

  Future<void> _limpar() async {
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Objeto atualizado com sucesso.')),
      );
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
      await viewModel.tirarFotoDoObjeto();
    } finally {
      if (mounted) setState(() => _fotografando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistrarViewModel>();
    final ocupado = viewModel.salvando || _fotografando || _limpando;
    final foto = viewModel.caminhoFotoObjeto;
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
                        viewModel.emModoEdicao ? 'Editar objeto' : 'Novo objeto',
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
                      const Text('Foto do objeto (opcional)'),
                      const SizedBox(height: 8),
                      if (foto != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(foto),
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
                              : viewModel.removerFotoDoObjeto,
                          child: const Text('Remover foto'),
                        ),
                      ],
                      OutlinedButton.icon(
                        onPressed: ocupado ? null : _tirarFoto,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(
                          _fotografando
                              ? 'Abrindo câmera…'
                              : foto == null
                              ? 'Adicionar foto'
                              : 'Tirar outra foto',
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
                        onPressed: ocupado ? null : _salvar,
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
