# Revisão de edição e exclusão — SCRUM-20 / SCRUM-21

Base: PR #8 (`Feature-Editar-Excluir`, commit `5e6f330`). As correções estão
na branch `fix/SCRUM-20-21-corrigir-edicao-exclusao`, commit `2cfddaf`,
integrado à `develop` pelo [PR #9](https://github.com/matheusEmanoels/cadesystem/pull/9)
após aprovação e [CI verde](https://github.com/matheusEmanoels/cadesystem/actions/runs/42307432674).
O GitHub também reconheceu o PR #8 como integrado, pois seus commits estão
incluídos no histórico do PR #9.

## Problema e correção por arquivo

- `lib/app.dart`: os repositories e services continuam compartilhados. O
  `RegistrarViewModel` deixa de ser global para não manter o ID do objeto em
  edição quando outra tela de cadastro é aberta.
- `lib/ui/registrar/registrar_view.dart`: cria um ViewModel por rota com o
  mesmo `ChangeNotifierProvider` usado nas telas de busca/detalhe. Carrega
  os campos antes de permitir salvar. Cancelar uma edição fecha a tela;
  cancelar um novo cadastro limpa o formulário. Ao vir dos detalhes, o
  campo de local recebe foco após a renderização.
- `lib/ui/registrar/registrar_view_model.dart`: distingue arquivos já salvos
  de capturas temporárias. Editar nome/local mantém foto e áudio. Remover
  uma foto apenas marca a intenção até salvar; cancelar preserva o original.
  O tamanho é recalculado a partir das mídias mantidas. IDs inexistentes
  mostram erro em vez de informar sucesso.
- `lib/data/repositories/objeto_repository.dart`: volta a exigir o service
  de mídia. Após persistir uma edição, limpa os arquivos substituídos;
  se a gravação falhar, preserva os originais. A exclusão limpa foto e áudio
  do objeto, preservando a foto compartilhada do local.
- `lib/data/services/cade_database.dart`: a exclusão volta a remover a linha
  definitivamente; a chave estrangeira remove seu histórico. Mantém a
  versão 2 e a coluna `excluido_em` por compatibilidade com bancos que
  tenham executado a versão do PR #8. A coluna não implementa uma lixeira.
  Atualizar um ID inexistente lança erro. O arquivo `.g.dart` é regenerado
  pelo Drift, sem edição manual.
- `lib/ui/detalhe/detalhe_view.dart`: adiciona a ação **Editar local** na
  barra superior e recarrega os detalhes/histórico ao retornar da edição.
- `lib/ui/buscar/buscar_view.dart`: recarrega busca/histórico ao retornar
  dos detalhes, incluindo alterações de local e exclusões.

## Validação executada

Flutter **3.47.1**, Dart **3.13.1**, pelo SDK local do FVM.

- Geração do Drift concluída. Permanece o aviso anterior de referências
  duplicadas de `historicoLocalRefs`; ele não impede geração ou análise.
- Análise sem problemas.
- **24 testes passaram**: os 12 anteriores e 12 cenários adicionais.
- APK Android de debug compilado. Isso não equivale a teste de usabilidade
  nem a validação manual de câmera/permissões em aparelho.

`test/edicao_exclusao_test.dart` usa SQLite e arquivos temporários reais
para verificar preservação de mídia, cancelamento, substituição, tentativa
após falha de gravação, remoção dos arquivos, histórico e reabertura do banco.
`test/registrar_view_test.dart` exercita a navegação para novo cadastro após
editar/sair, foco no local, atualização das listas e confirmação de exclusão.
Os dois testes de cadastro existentes que substituem mídia receberam o
método de leitura de tamanho exigido pelo novo fluxo.

Os dados pessoais do emulador não são usados nem alterados por esses testes.
Usabilidade com cinco pessoas e demonstração na Review da dupla continuam
dependendo das respectivas evidências. O CI da correção publicada passou.
