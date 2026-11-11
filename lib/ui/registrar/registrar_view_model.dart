// lib/ui/registrar/registrar_view_model.dart
//
// Tela de registro (US01 a US04). Fluxo pensado para ser rápido:
// só nome e local são obrigatórios; foto, áudio e categoria são opcionais.

import 'dart:async';

import 'package:characters/characters.dart';

import '../../data/repositories/categoria_repository.dart';
import '../../data/repositories/local_repository.dart';
import '../../data/repositories/objeto_repository.dart';
import '../../data/services/midia_service.dart';
import '../../data/services/permissao_service.dart';
import '../../domain/models/categoria.dart';
import '../../domain/models/local.dart';
import '../core/base_view_model.dart';

/// Aviso para a View mostrar quando uma permissão não foi concedida (US13).
/// O app continua funcionando: o aviso só explica a alternativa.
class AvisoPermissao {
  final TipoPermissao tipo;
  final ResultadoPermissao resultado;
  const AvisoPermissao(this.tipo, this.resultado);

  String get mensagem => tipo.alternativa;

  /// Se true, a View pode oferecer o botão "Abrir configurações".
  bool get podeAbrirConfiguracoes =>
      resultado == ResultadoPermissao.negadaPermanentemente;
}

class RegistrarViewModel extends BaseViewModel {
  static const limiteNome = 50;

  RegistrarViewModel({
    required this._objetos,
    required LocalRepository locais,
    required CategoriaRepository categorias,
    required this._midia,
    required this._permissoes,
  }) : _locaisRepo = locais,
       _categoriasRepo = categorias;

  int? _objetoIdAtual;
  bool get emModoEdicao => _objetoIdAtual != null;

  final ObjetoRepository _objetos;
  final LocalRepository _locaisRepo;
  final CategoriaRepository _categoriasRepo;
  final MidiaService _midia;
  final PermissaoService _permissoes;

  // Campos do formulário
  String _nome = '';
  String _nomeLocal = '';
  String _descricao = '';
  int? _categoriaId;

  // Mídias capturadas e ainda não salvas no banco
  MidiaSalva? _fotoObjeto;
  final List<MidiaSalva> _fotosExtrasPendentes = [];
  final List<String> _fotosExtrasOriginais = [];
  MidiaSalva? _fotoLocal;
  MidiaSalva? _audio;
  String? _fotoObjetoOriginal;
  String? _audioOriginal;
  bool _removerFotoOriginal = false;
  bool _removerAudioOriginal = false;

  bool _gravando = false;
  bool _salvando = false;
  AvisoPermissao? _aviso;

  List<Local> _locais = [];
  List<Categoria> _categorias = [];

  // ---------------------------------------------------------------
  // Leitura para a View
  // ---------------------------------------------------------------

  String get nome => _nome;
  String get nomeLocal => _nomeLocal;
  int? get categoriaId => _categoriaId;
  MidiaSalva? get fotoObjeto => _fotoObjeto;
  String? get _fotoPath =>
      _fotoObjeto?.caminhoRelativo ??
      (_removerFotoOriginal ? null : _fotoObjetoOriginal);
  String? get caminhoFotoObjeto =>
      _fotoPath == null ? null : _midia.caminho(_fotoPath!);
  List<String> get fotosObjeto => [
    ?_fotoPath,
    ..._fotosExtrasOriginais,
    ..._fotosExtrasPendentes.map((f) => f.caminhoRelativo),
  ];
  MidiaSalva? get fotoLocal => _fotoLocal;
  MidiaSalva? get audio => _audio;
  String? get caminhoAudio =>
      _audio?.caminhoRelativo ??
      (_removerAudioOriginal ? null : _audioOriginal);
  bool get gravando => _gravando;
  bool get salvando => _salvando;
  AvisoPermissao? get aviso => _aviso;
  String get motivoCamera => TipoPermissao.camera.motivo;
  String get motivoMicrofone => TipoPermissao.microfone.motivo;
  List<Categoria> get categorias => List.unmodifiable(_categorias);

  /// US03: locais já usados que combinam com o que o usuário digitou.
  List<Local> get sugestoesDeLocal {
    final busca = _nomeLocal.trim().toLowerCase();
    final lista = busca.isEmpty
        ? _locais
        : _locais.where((l) => l.nome.toLowerCase().contains(busca));
    return lista.take(8).toList();
  }

  /// O texto digitado é exatamente um local que já existe?
  /// Nesse caso a foto do local já está guardada e não precisa ser tirada.
  bool get localJaExiste {
    final busca = _nomeLocal.trim().toLowerCase();
    return busca.isNotEmpty &&
        _locais.any((l) => l.nome.toLowerCase() == busca);
  }

  bool get podeSalvar =>
      validarNome(_nome) == null &&
      validarLocal(_nomeLocal) == null &&
      !_salvando &&
      !_gravando;

  String? validarNome(String valor) {
    if (valor.trim().isEmpty) return 'Informe o nome do objeto.';
    if (valor.trim().characters.length > limiteNome) {
      return 'Use no máximo $limiteNome caracteres.';
    }
    return null;
  }

  String? validarLocal(String valor) =>
      valor.trim().isEmpty ? 'Informe onde você guardou o objeto.' : null;

  // ---------------------------------------------------------------
  // Carregamento
  // ---------------------------------------------------------------

  Future<void> iniciar({
    int? objetoId,
    String? nomeInicial,
    MidiaSalva? fotoInicial,
  }) async {
    await limparFormulario();
    if (objetoId == null) {
      _nome = nomeInicial?.trim() ?? '';
      _fotoObjeto = fotoInicial;
    }
    definirEstado(EstadoTela.carregando);
    try {
      _locais = await _locaisRepo.listar();
      _categorias = await _categoriasRepo.listar();
      if (objetoId != null) {
        _objetoIdAtual = objetoId;
        final detalhe = await _objetos.obter(objetoId);
        if (detalhe == null) {
          definirEstado(
            EstadoTela.erro,
            erro: 'Este objeto não foi encontrado.',
          );
          return;
        }
        _nome = detalhe.objeto.nome;
        _nomeLocal = detalhe.local.nome;
        _descricao = detalhe.objeto.descricao ?? '';
        _categoriaId = detalhe.objeto.categoriaId;
        _fotoObjeto = null;
        _fotoLocal = null;
        _audio = null;
        _fotoObjetoOriginal = detalhe.objeto.fotoPath;
        _fotosExtrasOriginais
          ..clear()
          ..addAll(detalhe.fotosExtras);
        _audioOriginal = detalhe.objeto.audioPath;
        _removerAudioOriginal = false;
      }
      definirEstado(EstadoTela.sucesso);
    } catch (_) {
      definirEstado(
        EstadoTela.erro,
        erro: 'Não foi possível abrir o registro. Tente novamente.',
      );
    }
  }

  Future<void> prepararEdicao(int objetoId) async {
    await iniciar(objetoId: objetoId);
  }

  // ---------------------------------------------------------------
  // Campos de texto
  // ---------------------------------------------------------------

  void nomeAlterado(String valor) {
    _nome = valor;
    notifyListeners();
  }

  void nomeLocalAlterado(String valor) {
    _nomeLocal = valor;
    notifyListeners();
  }

  void descricaoAlterada(String valor) {
    _descricao = valor;
  }

  void selecionarCategoria(int? id) {
    _categoriaId = id;
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // Fotos (US01, US03) e permissões (US13)
  // ---------------------------------------------------------------

  Future<void> tirarFotoDoObjeto() async {
    final nova = await _fotografar();
    if (nova == null) return;
    await _midia.apagar(_fotoObjeto?.caminhoRelativo);
    _fotoObjeto = nova;
    _removerFotoOriginal = false;
    notifyListeners();
  }

  Future<void> adicionarFotoDoObjeto() async {
    final nova = await _fotografar();
    if (nova == null) return;
    if (_fotoPath == null) {
      _fotoObjeto = nova;
      _removerFotoOriginal = false;
    } else {
      _fotosExtrasPendentes.add(nova);
    }
    notifyListeners();
  }

  Future<void> removerFoto(String caminho) async {
    if (caminho == _fotoPath) {
      await removerFotoDoObjeto();
      return;
    }
    _fotosExtrasOriginais.remove(caminho);
    final indice = _fotosExtrasPendentes.indexWhere(
      (f) => f.caminhoRelativo == caminho,
    );
    if (indice >= 0) {
      await _midia.apagar(
        _fotosExtrasPendentes.removeAt(indice).caminhoRelativo,
      );
    }
    notifyListeners();
  }

  Future<void> tirarFotoDoLocal() async {
    final nova = await _fotografar();
    if (nova == null) return;
    await _midia.apagar(_fotoLocal?.caminhoRelativo);
    _fotoLocal = nova;
    notifyListeners();
  }

  Future<void> removerFotoDoObjeto() async {
    await _midia.apagar(_fotoObjeto?.caminhoRelativo);
    _fotoObjeto = null;
    _removerFotoOriginal = true;
    notifyListeners();
  }

  Future<void> removerFotoDoLocal() async {
    await _midia.apagar(_fotoLocal?.caminhoRelativo);
    _fotoLocal = null;
    notifyListeners();
  }

  Future<MidiaSalva?> _fotografar() async {
    try {
      final resultado = await _permissoes.pedirCamera();
      if (resultado != ResultadoPermissao.concedida) {
        _aviso = AvisoPermissao(TipoPermissao.camera, resultado);
        notifyListeners();
        return null;
      }
      _aviso = null;
      return await _midia.tirarFoto();
    } catch (_) {
      mostrarErro('Não foi possível usar a câmera agora.');
      return null;
    }
  }

  // ---------------------------------------------------------------
  // Áudio (US04)
  // ---------------------------------------------------------------

  Future<void> iniciarGravacao() async {
    final resultado = await _permissoes.pedirMicrofone();
    if (resultado != ResultadoPermissao.concedida) {
      _aviso = AvisoPermissao(TipoPermissao.microfone, resultado);
      notifyListeners();
      return;
    }
    _aviso = null;
    try {
      _gravando = await _midia.iniciarGravacao();
    } catch (_) {
      _gravando = false;
      mostrarErro('Não foi possível gravar o áudio agora.');
    }
    notifyListeners();
  }

  Future<void> pararGravacao() async {
    final salvo = await _midia.pararGravacao();
    _gravando = false;
    if (salvo != null) {
      await _midia.apagar(_audio?.caminhoRelativo);
      _audio = salvo;
      _removerAudioOriginal = false;
    }
    notifyListeners();
  }

  Future<void> removerAudio() async {
    await _midia.apagar(_audio?.caminhoRelativo);
    _audio = null;
    _removerAudioOriginal = true;
    notifyListeners();
  }

  /// Para a View chamar quando o usuário toca em "Abrir configurações".
  Future<void> abrirConfiguracoes() => _permissoes.abrirConfiguracoes();

  void dispensarAviso() {
    _aviso = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // Salvar
  // ---------------------------------------------------------------

  /// Devolve true se o objeto foi registrado.
  Future<bool> salvar() async {
    if (!podeSalvar) return false;
    _salvando = true;
    limparErro();
    notifyListeners();

    try {
      // Local já existente mantém a foto que já tinha: descarta a nova.
      if (localJaExiste && _fotoLocal != null) {
        await _midia.apagar(_fotoLocal!.caminhoRelativo);
        _fotoLocal = null;
      }

      final caminhosFotos = fotosObjeto;
      final fotoPath = caminhosFotos.isEmpty ? null : caminhosFotos.first;
      final fotosExtras = caminhosFotos.skip(1).toList();
      final audioPath = caminhoAudio;
      var tamanhoFotos = 0;
      for (final caminho in caminhosFotos) {
        tamanhoFotos += await _midia.tamanhoDe(caminho);
      }
      final tamanho =
          tamanhoFotos +
          (_fotoLocal?.tamanhoBytes ?? 0) +
          (_audio?.tamanhoBytes ?? await _midia.tamanhoDe(audioPath));

      final descricao = _descricao.trim().isEmpty ? null : _descricao.trim();
      if (emModoEdicao && _objetoIdAtual != null) {
        await _objetos.atualizar(
          id: _objetoIdAtual!,
          nome: _nome,
          nomeLocal: _nomeLocal,
          fotoPath: fotoPath,
          fotoLocalPath: _fotoLocal?.caminhoRelativo,
          audioPath: audioPath,
          descricao: descricao,
          categoriaId: _categoriaId,
          tamanhoBytes: tamanho,
          fotosExtras: fotosExtras,
        );
      } else {
        await _objetos.registrar(
          nome: _nome,
          nomeLocal: _nomeLocal,
          fotoPath: fotoPath,
          fotoLocalPath: _fotoLocal?.caminhoRelativo,
          audioPath: _audio?.caminhoRelativo,
          descricao: descricao,
          categoriaId: _categoriaId,
          tamanhoBytes: tamanho,
          fotosExtras: fotosExtras,
        );
      }

      // As mídias agora pertencem ao banco: não devem ser apagadas ao sair.
      _fotoObjetoOriginal = fotoPath;
      _fotosExtrasOriginais
        ..clear()
        ..addAll(fotosExtras);
      _fotosExtrasPendentes.clear();
      _audioOriginal = audioPath;
      _removerFotoOriginal = false;
      _removerAudioOriginal = false;
      _fotoObjeto = null;
      _fotoLocal = null;
      _audio = null;
      _salvando = false;
      notifyListeners();
      return true;
    } catch (_) {
      _salvando = false;
      mostrarErro('Não foi possível salvar. Seus dados continuam aqui.');
      return false;
    }
  }

  // ---------------------------------------------------------------
  // Limpeza e saída da tela
  // ---------------------------------------------------------------

  /// Limpa o cadastro após salvar ou cancelar e descarta mídias não salvas.
  Future<void> limparFormulario() async {
    if (_salvando) return;
    await _limparPendentes();
    _objetoIdAtual = null;
    _fotoObjetoOriginal = null;
    _fotosExtrasOriginais.clear();
    _fotosExtrasPendentes.clear();
    _audioOriginal = null;
    _removerFotoOriginal = false;
    _removerAudioOriginal = false;
    _nome = '';
    _nomeLocal = '';
    _descricao = '';
    _categoriaId = null;
    _fotoObjeto = null;
    _fotoLocal = null;
    _audio = null;
    _gravando = false;
    _aviso = null;
    definirEstado(EstadoTela.inicial);
  }

  /// Se o usuário sair sem salvar, apaga as mídias capturadas para não
  /// deixar arquivos órfãos ocupando espaço (US14).
  @override
  void dispose() {
    unawaited(_limparPendentes());
    super.dispose();
  }

  Future<void> _limparPendentes() async {
    if (_gravando) await _midia.cancelarGravacao();
    await _midia.apagar(_fotoObjeto?.caminhoRelativo);
    for (final foto in _fotosExtrasPendentes) {
      await _midia.apagar(foto.caminhoRelativo);
    }
    await _midia.apagar(_fotoLocal?.caminhoRelativo);
    await _midia.apagar(_audio?.caminhoRelativo);
  }
}
