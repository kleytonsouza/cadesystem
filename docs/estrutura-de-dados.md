# Estrutura de dados do Cadê (SCRUM-84)

Este documento atende à definição da estrutura do registro (nome, local, foto e data), prevista na história [SCRUM-77](https://cade-system.atlassian.net/browse/SCRUM-77) e na subtarefa [SCRUM-84](https://cade-system.atlassian.net/browse/SCRUM-84). Descreve o banco existente e separa as regras do cadastro das validações ainda pendentes.

## Regra do cadastro

O Cadê deve responder onde um objeto foi guardado. Por isso, nome e local são obrigatórios; a foto é opcional e a data é automática. Exemplo: `Documento X` guardado em `Gaveta do escritório`. Um cadastro apenas com o nome não permite recuperar o lugar depois.

| Informação | Regra | Situação no código |
|---|---|---|
| Nome | Obrigatório, até 50 caracteres | ViewModel e repository rejeitam nome vazio ou só com espaços; a tela e o ViewModel limitam o nome a 50 caracteres visíveis |
| Local | Obrigatório, informado por texto | ViewModel e repository rejeitam local vazio ou só com espaços; banco e model exigem vínculo com um local |
| Foto | Opcional | Banco e model aceitam ausência; a mídia fica em arquivo e o banco guarda o caminho relativo |
| Data do registro | Automática | O banco preenche `registradoEm` ao inserir o objeto |

### Divergência com o planejamento anterior

A página 10 do documento **Cadê – Refinamento do Backlog, Papéis Scrum, Sprint Planning, Jira e Confluence** e o critério do [SCRUM-79](https://cade-system.atlassian.net/browse/SCRUM-79) permitem salvar sem local, avisando que o registro ficará incompleto.

Na orientação recebida para esta documentação, o local deve continuar obrigatório para atender à finalidade principal do app. Essa orientação coincide com o README e com o fluxo de cadastro já implementado nas camadas de dados e ViewModel.

O critério do SCRUM-79 foi alinhado à orientação atual, com comentário registrando o motivo da mudança. O PDF anterior foi preservado como histórico. A revisão pelo outro integrante e a conclusão das histórias funcionais continuam dependendo dos respectivos critérios.

## Armazenamento e arquitetura

- Banco SQLite local, acessado pelo Drift, com nome `cade` e `schemaVersion = 3`.
  A versão 2 adicionou `excluidoEm`; a versão 3 adicionou `fotos_objeto`.
  A coluna `excluidoEm` permanece por compatibilidade;
  a exclusão atual remove definitivamente o objeto e seu histórico, e o
  repository limpa as mídias próprias, conforme SCRUM-21.
- Fotos e áudios são arquivos no aparelho; o banco guarda caminhos relativos, como `fotos/123.jpg`.
- Não há conta de usuário nem sincronização em nuvem na estrutura atual.
- Models representam os dados do domínio; repositories convertem as linhas do banco e coordenam as operações; ViewModels validam as entradas e controlam o estado.
- Categorias, histórico, áudio e fotos adicionais já são usados pelas telas do aplicativo.

## Tabelas existentes

### `objetos`

| Campo Dart | Tipo | Aceita nulo? | Papel e valor inicial |
|---|---|---|---|
| `id` | Inteiro | Não | Identificador gerado pelo banco |
| `nome` | Texto | Não | Nome do objeto; espaços nas extremidades são removidos ao registrar |
| `localId` | Inteiro | Não | Referência a `locais.id` |
| `fotoPath` | Texto | Sim | Caminho relativo da foto principal do objeto |
| `audioPath` | Texto | Sim | Caminho relativo do áudio |
| `descricao` | Texto | Sim | Descrição complementar |
| `categoriaId` | Inteiro | Sim | Referência a `categorias.id` |
| `tamanhoBytes` | Inteiro | Não | Tamanho informado para as mídias do registro; padrão `0` |
| `registradoEm` | Data e hora | Não | Momento do registro, preenchido pelo banco |
| `confirmadoEm` | Data e hora | Não | Última confirmação de localização; começa com o momento da inserção |

Há índices para nome, local e categoria. A coluna de nome não define limite de 50 caracteres nem bloqueia texto vazio por si só; a validação de preenchimento está no ViewModel e no repository.

### `fotos_objeto`

| Campo Dart | Tipo | Aceita nulo? | Papel |
|---|---|---|---|
| `id` | Inteiro | Não | Identificador gerado pelo banco |
| `objetoId` | Inteiro | Não | Referência ao objeto; excluído junto com ele |
| `caminho` | Texto | Não | Caminho relativo de uma foto adicional |
| `ordem` | Inteiro | Não | Ordem de exibição das fotos adicionais |

A migração da versão 2 cria esta tabela sem alterar a foto principal dos registros existentes. O teste `migracao_fotos_test.dart` abre um banco antigo e verifica a preservação do registro.

### `locais`

| Campo Dart | Tipo | Aceita nulo? | Papel e valor inicial |
|---|---|---|---|
| `id` | Inteiro | Não | Identificador gerado pelo banco |
| `nome` | Texto | Não | Nome único do local |
| `fotoPath` | Texto | Sim | Caminho relativo da foto do local |
| `criadoEm` | Data e hora | Não | Momento da criação, preenchido pelo banco |

Vários objetos podem usar o mesmo local. O cadastro procura um local pelo nome, removendo espaços nas extremidades e comparando em minúsculas, antes de criar outro. A consulta não faz normalização de acentos.

### `categorias`

| Campo Dart | Tipo | Aceita nulo? | Papel e valor inicial |
|---|---|---|---|
| `id` | Inteiro | Não | Identificador gerado pelo banco |
| `nome` | Texto | Não | Nome único da categoria |
| `ordem` | Inteiro | Não | Ordem de exibição; padrão `0` |

O banco cria inicialmente: Documentos, Chaves, Ferramentas, Eletrônicos, Roupas, Remédios e Outros. A categoria do objeto é opcional.

### `historico_local`

| Campo Dart | Tipo | Aceita nulo? | Papel e valor inicial |
|---|---|---|---|
| `id` | Inteiro | Não | Identificador gerado pelo banco |
| `objetoId` | Inteiro | Não | Referência ao objeto movido |
| `localAntigoId` | Inteiro | Sim | Referência ao local anterior |
| `localNovoId` | Inteiro | Não | Referência ao novo local |
| `alteradoEm` | Data e hora | Não | Momento da mudança, preenchido pelo banco |

Ao mover para outro local, o banco altera `objetos.localId`, atualiza `confirmadoEm` e insere o histórico em uma transação. Confirmar o mesmo local só atualiza `confirmadoEm`.

## Relações e integridade

| Relação | Comportamento definido no banco |
|---|---|
| Objeto → local | Todo objeto referencia um local; a exclusão do local é restringida enquanto houver referência |
| Objeto → categoria | Categoria opcional; excluir a categoria deixa o vínculo nulo |
| Histórico → objeto | Excluir o objeto também exclui seu histórico |
| Histórico → local antigo | Excluir o local antigo deixa essa referência nula |
| Histórico → local novo | A exclusão do local é restringida enquanto houver essa referência |

As chaves estrangeiras são habilitadas ao abrir o banco. O registro do objeto e a obtenção ou criação do local também acontecem em uma transação.

## Pendências vinculadas aos cards

- [SCRUM-78 — Nome curto](https://cade-system.atlassian.net/browse/SCRUM-78): limite de 50 caracteres e avisos implementados no cadastro do SCRUM-86; revisar a entrega e validar os demais critérios da história.
- [SCRUM-79 — Local](https://cade-system.atlassian.net/browse/SCRUM-79): critério alinhado ao local obrigatório e campo conectado ao cadastro do SCRUM-86; revisar a entrega e validar os demais critérios da história.
- [SCRUM-84 — Estrutura de dados](https://cade-system.atlassian.net/browse/SCRUM-84): revisar esta documentação com a equipe. O documento não substitui testes de persistência nem comprova a conclusão das histórias funcionais.

## Código de referência

- [Banco e tabelas](../lib/data/services/cade_database.dart)
- [Model do objeto](../lib/domain/models/objeto.dart)
- [Model do local](../lib/domain/models/local.dart)
- [Model da categoria](../lib/domain/models/categoria.dart)
- [Registro no repository](../lib/data/repositories/objeto_repository.dart)
- [Validações do cadastro](../lib/ui/registrar/registrar_view_model.dart)
