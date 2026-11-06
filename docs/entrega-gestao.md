# Fechamento de Gestão de Projetos — Cadê?

Este documento relaciona o planejamento às evidências e pendências da
entrega. Não declara o MVP completamente concluído: testes de usabilidade
com cinco pessoas e registros do fechamento Scrum ainda dependem da equipe.

## Fontes e identificação dos itens

- Material da equipe em `C:\Users\Ton\Desktop\Cade`, incluindo o PDF de
  refinamento, o documento/PDF `Cade_Gestao_de_Projetos_Entrega_Final`, a
  matriz de riscos e o pacote do item 6 do Confluence.
- [Quadro Jira SCRUM](https://cade-system.atlassian.net/jira/software/projects/SCRUM/boards/1).
- [Acompanhamento Scrum no Confluence](https://cade-system.atlassian.net/wiki/spaces/TD/pages/1278142).
- [Backlog, Story Map e DoR/DoD](https://cade-system.atlassian.net/wiki/spaces/TD/pages/1343490).

A numeração antiga das histórias no README e nos comentários do código
difere da entrega de Gestão. Para rastrear o trabalho, usar a chave Jira e
o título abaixo; não associar funcionalidades apenas pelo número US.

| Card | Entrega planejada |
|---|---|
| SCRUM-77 | Ambiente, repositório e protótipo |
| SCRUM-78 | Cadastro com nome curto |
| SCRUM-79 | Local obrigatório no cadastro, conforme decisão posterior da equipe |
| SCRUM-80 | Persistência offline |
| SCRUM-81 | Foto opcional no cadastro |
| SCRUM-82 | Explicação e tratamento das permissões |
| SCRUM-17 | Busca parcial por nome, ignorando caixa/acentos; menos de 1 s com 200 registros |
| SCRUM-18 | Resultado com foto ou ícone padrão, nome e local |
| SCRUM-19 | Detalhes, data e acesso a editar/excluir |
| SCRUM-20 | Alteração do local e persistência da atualização |
| SCRUM-21 | Exclusão com confirmação e limpeza dos arquivos do objeto |
| SCRUM-22 | Testes com cinco pessoas, feedback e correções |

## Evidências disponíveis

- PRs #1 a #7 integrados à `develop`: preparação, CI, estrutura de dados,
  protótipo, cadastro, identidade visual e telas/histórico.
- [PR #8](https://github.com/matheusEmanoels/cadesystem/pull/8): implementação
  inicial de editar/excluir, revisada com identificação de regressões e
  integrada juntamente com a correção do PR #9.
- [PR #9](https://github.com/matheusEmanoels/cadesystem/pull/9): correção das
  regressões. Integrado à `develop` no commit `3a5a703`, com
  [CI aprovado](https://github.com/matheusEmanoels/cadesystem/actions/runs/42307432674),
  24 testes, análise e compilação Android local concluídos.
- Testes de edição/exclusão usam SQLite e arquivos temporários reais;
  há teste de fechar/reabrir o banco e de navegação pela interface.
- Busca sem acentos e acesso à busca integrados pelo
  [PR #10](https://github.com/matheusEmanoels/cadesystem/pull/10), commit de
  merge `526b9e7`, com [CI aprovado](https://github.com/matheusEmanoels/cadesystem/actions/runs/42308069959).
  A suíte passou com **27 testes**; a consulta com 200 registros levou
  aproximadamente 5 ms em teste local.

## Critérios para fechar a entrega

1. Integrar as correções revisadas e confirmar CI verde na versão integrada.
2. Conferir no Android o fluxo registrar → buscar → consultar → editar →
   reabrir offline → excluir, incluindo foto e permissões.
3. Atualizar critérios, subtarefas e estados do Jira com links de PR/teste;
   itens não validados permanecem pendentes ou em análise.
4. Aplicar o [roteiro de usabilidade](usabilidade.md) com pelo menos cinco
   pessoas e preencher os resultados reais. Corrigir e retestar falhas críticas.
5. Demonstrar o incremento na Review da dupla e registrar decisões reais da
   retrospectiva: dificuldades, o que funcionou e ações de melhoria.
6. Atualizar no Confluence planejado × realizado, entregas aceitas,
   impedimentos e riscos. Horas reais só podem ser apuradas de registros;
   estimativas não são horas trabalhadas. Não reconstruir um burndown fictício.
7. Conferir os links e o acesso da professora ao Jira, Confluence e versão
   demonstrável do app; verificar a submissão no ambiente da disciplina.

A DoD cadastrada exige critérios aceitos, revisão pelo colega, teste
offline, ausência de falhas críticas, filhos concluídos e demonstração na
Review. Testes automatizados e CI atendem parte dessa evidência; não
comprovam que a Review ou os testes com pessoas foram realizados.

## Prazo e riscos

O prazo de entrega informado por Kleyton é **06/11/2026, até meia-noite**.
O planejamento publicado da Sprint 2 termina em **09/11/2026**. Essa diferença
precisa ser tratada no fechamento: identificar o incremento entregue no prazo
e o que permaneceu no backlog, preservando as datas e o histórico reais.

- **R07 — perda de dados:** os testes de regressão cobrem a sobrescrita após
  editar, preservação de mídias e reabertura do banco.
- **R05 — espaço ocupado:** a exclusão precisa remover as mídias do objeto;
  fotos compartilhadas de locais devem permanecer enquanto reutilizadas.
- **R03 — busca:** acentos e volume de 200 registros são verificados em teste;
  observar também a experiência no aparelho.
- **R08/R09 — prazo e validação:** aplicação com cinco pessoas ainda pendente.
  Não substituir essa atividade por testes automatizados nem marcar aceite
  de um resultado que a equipe ainda não observou.

Áudio, múltiplas fotos, backup, reconhecimento por imagem e demais itens
de Release 2/Futuro não são novas exigências para fechar este MVP.
