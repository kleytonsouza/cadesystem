import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class SugestaoObjeto {
  const SugestaoObjeto({required this.nome, required this.confianca});

  final String nome;
  final double confianca;
}

/// Sugere nomes a partir de uma foto, sem criar registros automaticamente.
class ReconhecimentoService {
  Future<List<SugestaoObjeto>> analisar(String caminhoFoto) async {
    final analisador = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.5),
    );
    try {
      final resultados = await analisador.processImage(
        InputImage.fromFilePath(caminhoFoto),
      );
      resultados.sort((a, b) => b.confidence.compareTo(a.confidence));
      return resultados
          .take(5)
          .map(
            (resultado) => SugestaoObjeto(
              nome: resultado.label,
              confianca: resultado.confidence,
            ),
          )
          .toList();
    } finally {
      await analisador.close();
    }
  }
}
