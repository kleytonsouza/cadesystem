import 'package:cadesystem/data/services/midia_service.dart';
import 'package:cadesystem/data/services/reconhecimento_service.dart';
import 'package:cadesystem/ui/inventario/inventario_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _MidiaDeTeste implements MidiaService {
  int escolhas = 0;
  final removidas = <String>[];

  @override
  Future<MidiaSalva?> escolherFotoDaGaleria() async =>
      MidiaSalva(caminhoRelativo: 'fotos/${++escolhas}.jpg', tamanhoBytes: 1);

  @override
  String caminho(String relativo) => relativo;

  @override
  Future<void> apagar(String? relativo) async {
    if (relativo != null) removidas.add(relativo);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ReconhecimentoDeTeste extends ReconhecimentoService {
  @override
  Future<List<SugestaoObjeto>> analisar(String caminhoFoto) async => [
    const SugestaoObjeto(nome: 'Documento', confianca: 0.9),
  ];
}

void main() {
  test(
    'trocar foto limpa a anterior e transferir preserva a escolhida',
    () async {
      final midia = _MidiaDeTeste();
      final vm = InventarioViewModel(
        midia: midia,
        reconhecimento: _ReconhecimentoDeTeste(),
      );

      await vm.escolherFoto();
      expect(vm.sugestoes.single.nome, 'Documento');
      await vm.escolherFoto();
      expect(midia.removidas, ['fotos/1.jpg']);
      expect(vm.transferirFoto()?.caminhoRelativo, 'fotos/2.jpg');
      vm.dispose();
      expect(midia.removidas, ['fotos/1.jpg']);
    },
  );
}
