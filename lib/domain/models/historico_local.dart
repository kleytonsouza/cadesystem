class HistoricoLocal {
  final int id;
  final int objetoId;
  final String localAntigo;
  final String localNovo;
  final DateTime alteradoEm;

  const HistoricoLocal({
    required this.id,
    required this.objetoId,
    required this.localAntigo,
    required this.localNovo,
    required this.alteradoEm,
  });

  @override
  bool operator ==(Object other) =>
      other is HistoricoLocal && other.id == id && other.objetoId == objetoId;

  @override
  int get hashCode => Object.hash(id, objetoId);

  @override
  String toString() =>
      'HistoricoLocal(id: $id, objetoId: $objetoId, $localAntigo -> $localNovo)';
}
