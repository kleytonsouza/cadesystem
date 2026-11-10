import 'categoria.dart';
import 'local.dart';
import 'objeto.dart';

class ObjetoDetalhe {
  final Objeto objeto;
  final Local local;
  final Categoria? categoria;
  final List<String> fotosExtras;

  const ObjetoDetalhe({
    required this.objeto,
    required this.local,
    this.categoria,
    this.fotosExtras = const [],
  });

  String get resumo => '${objeto.nome} — ${local.nome}';

  @override
  bool operator ==(Object other) =>
      other is ObjetoDetalhe && other.objeto == objeto;

  @override
  int get hashCode => objeto.hashCode;

  @override
  String toString() => 'ObjetoDetalhe($resumo)';
}
