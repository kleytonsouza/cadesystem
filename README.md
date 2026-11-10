# Cadê? 🔎

> Memória externa para objetos físicos: registre onde guardou e encontre depois, sem esforço.

## Sobre o projeto

Pessoas guardam objetos em lugares que fazem sentido na hora, mas esquecem onde. O resultado é tempo perdido, recompra e frustração.

O **Cadê?** é um aplicativo que resolve isso com um registro de baixíssimo esforço (foto ou voz) no momento de guardar e uma busca simples para achar o objeto depois.

## Público-alvo (personas)

Baseadas nas entrevistas com Claites, José e Ricardo.

| Persona | O que precisa |
|---|---|
| **Claites** | Foto do local e poucos passos para registrar e consultar |
| **José** | Uso offline, cadastro simples e permissões transparentes |
| **Ricardo** | App rápido (desiste em menos de 10 min) e com dados locais |

## Hipótese do MVP

> Se o usuário conseguir registrar um objeto em poucos toques e achá-lo depois com uma busca simples, ele confia no app e continua usando.

## Funcionalidades

- **Registrar:** fotos do objeto, nome curto, local (texto e foto, reaproveitando locais já usados) e áudio.
- **Encontrar:** busca por texto com foto na primeira tela, filtro por local ou categoria.
- **Consultar:** detalhe do objeto com foto do item, foto do local, nome, data do registro e áudio.
- **Manter:** mudar o local, excluir objeto ou local e aviso de registro antigo.
- **Confiança:** uso offline com dados só no aparelho, permissões explicadas, compressão de mídia, backup manual e tutorial.

> **Decisão de projeto:** o app **não tem cadastro de usuário**. Os dados ficam apenas no aparelho, o que reduz o atrito de uso (persona Ricardo) e respeita a privacidade (persona José).

---

## Tecnologias

| Item | Tecnologia |
|---|---|
| Framework | Flutter (Dart 3 ou superior) |
| Banco de dados | SQLite, via [Drift](https://drift.simonbinder.eu) |
| Arquitetura | MVVM |
| Estado | `ChangeNotifier` com `provider` |
| Fotos | `image_picker` (câmera, galeria e compressão) |
| Áudio | `record` (gravação em AAC de baixa taxa) |
| Permissões | `permission_handler` |

## Arquitetura (MVVM)

O projeto é organizado em camadas, e dentro de `ui/` cada funcionalidade tem uma View e um ViewModel.

```
lib/
├── main.dart
├── app.dart                      # MaterialApp, rotas e injeção de dependências
│
├── core/
│   ├── theme/                    # cores e estilos
│   ├── routes/                   # nomes e configuração de rotas
│   └── utils/
│       └── formatadores.dart     # tamanho em bytes, datas etc.
│
├── domain/
│   └── models/                   # MODEL: classes puras do domínio
│       ├── objeto.dart
│       ├── local.dart
│       ├── categoria.dart
│       └── objeto_detalhe.dart   # objeto + local + categoria, para busca e detalhe
│
├── data/
│   ├── services/                 # acesso a recursos externos
│   │   ├── cade_database.dart    # banco SQLite (Drift)
│   │   ├── midia_service.dart    # capturar, comprimir e apagar foto/áudio (US14)
│   │   └── permissao_service.dart# câmera e microfone (US13)
│   └── repositories/             # traduz linhas do banco <-> Model
│       ├── objeto_repository.dart
│       ├── local_repository.dart
│       ├── categoria_repository.dart
│       └── mappers.dart          # ObjetoRow/LocalRow/CategoriaRow -> models
│
└── ui/
    ├── core/
    │   ├── base_view_model.dart  # estado de tela compartilhado
    │   └── widgets/              # widgets reutilizáveis (cartão de objeto etc.)
    ├── registrar/                # US01 a US04
    │   ├── registrar_view.dart
    │   └── registrar_view_model.dart
    ├── buscar/                   # US05, US06
    │   ├── buscar_view.dart
    │   └── buscar_view_model.dart
    ├── detalhe/                  # US07 a US11
    │   ├── detalhe_view.dart
    │   └── detalhe_view_model.dart
    └── configuracoes/            # US14, US15 (espaço usado e backup)
        ├── configuracoes_view.dart
        └── configuracoes_view_model.dart
```

### Responsabilidade de cada camada

| Camada | Responsabilidade | Não deve |
|---|---|---|
| **View** | Desenhar a tela e reagir a toques | Ter regra de negócio ou falar com o banco |
| **ViewModel** | Guardar o estado da tela, validar e chamar os repositories | Importar widgets nem conhecer SQL |
| **Repository** | Converter as linhas do banco (`ObjetoRow`, `LocalRow`) em Models (`Objeto`, `Local`) e coordenar banco e arquivos | Conhecer a tela |
| **Service** | Falar com o SQLite, arquivos e permissões | Saber das regras da tela |
| **Model** | Representar os dados do domínio | Depender de Flutter ou do banco |

O fluxo segue sempre uma direção: **View → ViewModel → Repository → Service**. Os dados voltam pelo caminho inverso, e a View só enxerga o ViewModel.

### Models

| Classe | Papel |
|---|---|
| `Objeto` | Objeto registrado. Tem `temFoto`, `temAudio` e `registroAntigo()` (US11) |
| `Local` | Lugar onde objetos são guardados, reaproveitado entre vários objetos |
| `Categoria` | Tipo do objeto (Documentos, Chaves...) |
| `ObjetoDetalhe` | `Objeto` + `Local` + `Categoria` opcional, usado nas telas de busca e detalhe |

Os models são classes puras de Dart: não dependem de Flutter nem do Drift. A conversão das linhas do banco é feita só nos repositories, por `mappers.dart`.

### ViewModels

Todos estendem `BaseViewModel`, que guarda o estado da tela (`inicial`, `carregando`, `sucesso`, `vazio`, `erro`) e a mensagem de erro, para o app nunca ficar travado sem explicação.

| ViewModel | Responsabilidade | Histórias |
|---|---|---|
| `RegistrarViewModel` | Formulário (só nome e local são obrigatórios), fotos, áudio e avisos de permissão. Apaga as mídias capturadas se o usuário sair sem salvar | US01 a US04, US13 |
| `BuscarViewModel` | Busca com espera de 300 ms após a última letra, filtros por local e categoria, descarte de consultas antigas | US05, US06 |
| `DetalheViewModel` | Carrega o objeto, muda o local, exclui e confirma que "continua aqui" | US07 a US11 |
| `ConfiguracoesViewModel` | Espaço usado pelas mídias e exportação manual do backup | US14, US15 |

### Repositories

| Repository | Métodos |
|---|---|
| `ObjetoRepository` | `registrar`, `buscar(termo, {localId, categoriaId})`, `obter`, `mover`, `excluir`, `listarAntigos` |
| `LocalRepository` | `listar`, `excluir` |
| `CategoriaRepository` | `listar` |

Pontos importantes:
- Os filtros por local e categoria são aplicados em memória, no repository. Se a lista crescer, mova-os para uma consulta no `CadeDatabase`.
- `ObjetoRepository.excluir` apaga as fotos e o áudio do objeto, mas não a foto do local, porque outros objetos podem usá-la.
- Registros sem confirmação do local há mais de 330 dias aparecem como "Para conferir" no Histórico. O botão "Confirmar local" no detalhe atualiza essa data.
- Se `registrar` falhar, as mídias não são apagadas: o ViewModel ainda as tem e o usuário pode tentar de novo.

---

## Mídia e permissões (services)

### MidiaService (US01, US03, US04, US10, US14)

- **Fotos:** tira pela câmera ou escolhe da galeria, já reduzidas (lado máximo de 1280 px, qualidade 70).
- **Áudio:** grava em AAC mono (64 kbps, 22 kHz), com iniciar, parar e cancelar.
- **Manutenção:** apagar arquivos, medir o tamanho de um arquivo e o espaço total ocupado pelas mídias.
- **Caminhos relativos:** o banco guarda `fotos/123.jpg`, nunca o caminho completo, porque a pasta do app pode mudar de endereço entre atualizações (principalmente no iOS). Para exibir uma mídia, use `midiaService.caminho(relativo)`.
- **Criação assíncrona:** o service deve ser criado uma vez, antes do `runApp`:

```dart
final midia = await MidiaService.criar();
```

### PermissaoService (US13)

- Cobre câmera e microfone e devolve um resultado, sem lançar exceção: `concedida`, `negada`, `negadaPermanentemente` ou `restrita`. Negar uma permissão é um caso normal e não trava o app.
- Cada permissão tem um texto `motivo`, mostrado **antes** de pedir, e um texto `alternativa`, que diz o que continua funcionando sem ela.
- `abrirConfiguracoes()` serve para quando o usuário marcou "não perguntar de novo".

### Configuração nas plataformas

- **Android** (`android/app/src/main/AndroidManifest.xml`): o cadastro declara `CAMERA` e `RECORD_AUDIO`. Antes de pedir acesso ao microfone, a tela explica o motivo.
- **iOS** (`ios/Runner/Info.plist`): o cadastro declara `NSCameraUsageDescription` e `NSMicrophoneUsageDescription`. A compilação iOS ainda precisa ser validada em um ambiente Apple.

### Backup manual

Em Configurações, **Exportar backup** permite escolher onde salvar um ZIP. Ele contém `cade.sqlite`, a pasta `midias/` e `manifesto.json`. O banco é copiado com `VACUUM INTO` para incluir os registros confirmados sem depender dos arquivos WAL. O ZIP não tem senha; guarde-o em um local privado. A importação de backup não faz parte deste card.

---

## Banco de dados (Drift)

O banco é local (SQLite) e fica em `lib/data/services/cade_database.dart`. As fotos e os áudios ficam como arquivos no aparelho, e o banco guarda apenas o caminho relativo deles.

### Contrato dos dados (SCRUM-84)

O cadastro exige **nome e local**, pois o objetivo do Cadê é recuperar onde o objeto foi guardado. A foto é opcional e a data do registro é preenchida automaticamente. Exemplo: nome `Documento X`, local `Gaveta do escritório`.

A [estrutura de dados](docs/estrutura-de-dados.md) detalha os campos, as relações, as validações existentes e as pendências. Ela também registra a orientação atual de manter o local obrigatório e a divergência com o critério anterior do PDF de refinamento e do SCRUM-79, que permitia salvar sem local.

### Tabelas

| Tabela | Conteúdo | Histórias |
|---|---|---|
| `objetos` | Nome, foto, áudio, descrição, local, categoria, tamanho da mídia, data do registro e da última confirmação | US01, US02, US04, US07, US11, US14 |
| `locais` | Nome (único) e foto do local, reaproveitados entre objetos | US03 |
| `categorias` | Lista fixa criada com o banco: Documentos, Chaves, Ferramentas, Eletrônicos, Roupas, Remédios, Outros | US06 |
| `historico_local` | Registro de cada mudança de local de um objeto | US09 |

### Principais operações

| Função | História |
|---|---|
| `registrarObjeto`, `obterOuCriarLocal` | US01, US02, US03, US04 |
| `buscarObjetos` | US05 |
| `obterObjeto` | US07 |
| `objetosDoLocal`, `listarLocais`, `listarCategorias` | US06 |
| `moverObjeto` | US09 |
| `excluirObjeto`, `excluirLocal` | US10 |
| `objetosAntigos` | US11 |
| `espacoUsadoBytes` | US14 |

### Configuração do projeto e do Drift

**1. Instalar as dependências com o Flutter definido no FVM**

```powershell
fvm flutter pub get
```

**2. Criar o `build.yaml` na raiz do projeto**

```yaml
targets:
  $default:
    builders:
      drift_dev:
        options:
          databases:
            cade_database: lib/data/services/cade_database.dart
          schema_dir: drift_schemas/
          test_dir: test/drift/
```

**3. Gerar o código do banco**

```powershell
fvm dart run build_runner build
```

Isso cria o arquivo `cade_database.g.dart`, que não deve ser editado à mão. Durante o desenvolvimento, `dart run build_runner watch` regenera o código a cada alteração.

### Como alterar o banco no futuro

1. Altere as tabelas em `cade_database.dart`.
2. Aumente o `schemaVersion`.
3. Adicione o passo correspondente no `onUpgrade` e regenere `cade_database.g.dart` com `fvm dart run build_runner build`.
4. Teste a abertura de um banco da versão anterior; `test/migracao_fotos_test.dart` verifica a passagem da versão 2 para a 3.

Nunca edite uma migração que já foi lançada.

### Observações

- **Desenvolvimento no emulador:** mantenha o app instalado para exercitar a migração dos dados existentes.
- **Exclusão de arquivos:** o repository remove a foto principal, as fotos adicionais e o áudio depois de excluir o registro.
- **Busca com acento:** o `LIKE` do SQLite ignora maiúsculas apenas em letras sem acento. A normalização exigida pelo SCRUM-17 ainda está pendente e deve acompanhar a implementação da busca.
- **Testes:** o `CadeDatabase` aceita um executor no construtor, então os testes podem usar um banco em memória em vez do arquivo real.

---

## Status da implementação

| Camada | Situação |
|---|---|
| Banco (`CadeDatabase`) | Pronto |
| Services (`MidiaService`, `PermissaoService`) | Prontos |
| Models | Prontos |
| Repositories | Prontos |
| ViewModels e `BaseViewModel` | Prontos |
| `main.dart` e `app.dart` (injeção com `provider`) | Inicialização do banco e das mídias conectada à tela de cadastro |
| View de cadastro | Implementada: nome e local obrigatórios, nome até 50 caracteres, foto opcional e salvamento local |
| Views de busca, detalhes e configurações | A fazer |
| Reprodução de áudio (US08) | A fazer na R2 (`AudioPlayerService`) |
| Backup manual (US15) | A fazer na R2 (`BackupService`) |

### Executar e validar o cadastro

Selecione o emulador Android no VS Code e execute a configuração `cadesystem` com F5, ou use `fvm flutter run`. O aplicativo inicia em **Novo objeto**, substituindo o contador de exemplo do Flutter.

O cadastro permite salvar nome e local sem foto, explica o uso da câmera antes de solicitar acesso e mostra confirmação após salvar. Cancelar limpa o formulário sem gravar. A busca dos registros ainda depende da implementação de sua tela; salvar não abre uma busca que ainda não existe.

Os testes em `test/registrar_view_test.dart` e `test/registrar_view_model_test.dart` verificam o formulário, a gravação no SQLite em memória, o limite do nome, a rejeição de campos vazios, a preservação dos dados em falha e a disposição em tela estreita com texto ampliado. Execute com `fvm flutter test`; a análise é feita com `fvm flutter analyze`.

Nesta etapa a execução foi validada no Android. A descrição de uso da câmera foi incluída no iOS, mas a compilação e as permissões no iOS ainda precisam ser verificadas em um ambiente Apple.

---

## Releases

| Release | Objetivo | Histórias | Critério de saída |
|---|---|---|---|
| **R1: Núcleo** | Fluxo registrar → buscar → ver, offline | US12, US13, US01, US02, US03, US05, US07 | Registrar em menos de 15 s; achar um item em até 3 toques; uso sem internet |
| **R2: MVP validado** | Cobrir o escopo do Canvas e reforçar a confiança | US04, US08, US06, US09, US10, US14, US15 | Testes com 5+ usuários, incluindo perfil não técnico; problemas críticos corrigidos |
| **R3: Evolução** | Manter registros vivos e ganhar escala | US11, US16, F01, F02 | Decidido com os dados de uso do MVP |

### Fora do escopo agora (pós-MVP)

- **F01:** reconhecimento de itens de uma foto de gaveta (visão computacional).
- **F02:** alertas inteligentes e compartilhamento familiar de registros.

## Backlog priorizado

Esta seção preserva a numeração inicial do projeto. Para a entrega de Gestão
de Projetos, use o [mapeamento pelas chaves Jira e checklist de fechamento](docs/entrega-gestao.md),
pois as histórias foram refinadas e renumeradas no planejamento da equipe.

Valor de 1 a 5, estimado pela recorrência nas entrevistas e nas dores do Canvas.

| ID | História | Épico | Valor | MoSCoW | Release |
|---|---|---|---|---|---|
| US01 | Registrar um objeto tirando uma foto | Registrar | 5 | Must | R1 |
| US02 | Dar um nome curto ao objeto | Registrar | 5 | Must | R1 |
| US03 | Informar onde guardei (texto e foto do local) | Registrar | 5 | Must | R1 |
| US04 | Registrar o local por áudio | Registrar | 4 | Should | R2 |
| US05 | Buscar por texto, com foto no resultado | Encontrar | 5 | Must | R1 |
| US06 | Filtrar por local ou categoria | Encontrar | 3 | Should | R2 |
| US07 | Ver o detalhe do objeto | Consultar | 5 | Must | R1 |
| US08 | Ouvir o áudio registrado | Consultar | 3 | Should | R2 |
| US09 | Mudar o local de um objeto | Manter | 4 | Should | R2 |
| US10 | Excluir objeto ou local | Manter | 2 | Should | R2 |
| US11 | Aviso de registro antigo | Manter | 3 | Could | R3 |
| US12 | Usar offline, com dados só no aparelho | Confiança | 5 | Must | R1 |
| US13 | Entender as permissões e poder negá-las sem travar o uso | Confiança | 4 | Must | R1 |
| US14 | Fotos e áudios comprimidos e espaço usado visível | Confiança | 3 | Should | R2 |
| US15 | Exportar/backup manual | Confiança | 3 | Should | R2 |
| US16 | Tutorial curto no primeiro uso | Confiança | 2 | Could | R3 |
| F01 | Visão computacional | Evolução | 4 | Won't (agora) | Pós-MVP |
| F02 | Alertas e compartilhamento familiar | Evolução | 3 | Won't (agora) | Pós-MVP |

## Dependências críticas

- **US12 (banco local offline)** é a base de tudo e deve ser a primeira entrega técnica.
- **US13 (permissões)** precede foto (US01) e áudio (US04).
- **US02 e US03 → US05 → US07:** a busca depende de dados cadastrados, e o detalhe depende da busca.
- **US14 (compressão)** deve vir antes do uso intenso de áudio, por causa do risco de armazenamento.

**Ordem de construção:** US12 → US13 → US01/US02 → US03 → US05 → US07 *(fim da R1)* → US14 → US04 → US08 → US06 → US09/US10 → US15 *(fim da R2)*.

## Roadmap

Premissa: 14 semanas, sprints de 2 semanas (ajustar ao calendário real). Os marcos 1 a 8 seguem os Milestones do Canvas.

| Semanas | Marcos | Entrega |
|---|---|---|
| 1–2 | 1 e 2 | Problema, público-alvo, entrevistas e ideação |
| 3–4 | 3 e 4 | Requisitos, backlog e protótipo das telas |
| 5–8 | 5 (parte 1) | Desenvolvimento da R1 e entrega interna |
| 9–11 | 5 (parte 2) | Desenvolvimento da R2 |
| 12–13 | 6 | Testes com usuários e avaliação de usabilidade |
| 14 | 7 e 8 | Correções e entrega da versão validada |

## Documentos relacionados

- [Estrutura de dados e regras do cadastro (SCRUM-84)](docs/estrutura-de-dados.md)
- [Protótipo de baixa fidelidade do fluxo principal (SCRUM-85)](docs/prototipo.md)
- [Cadastro implementado, explicação do código e validação (SCRUM-86)](docs/cadastro.md)
- [Identidade visual, imagens e geração dos ícones](docs/identidade-visual.md)
- [Evidências e checklist da entrega de Gestão de Projetos](docs/entrega-gestao.md)
- [Roteiro e ficha de resultados da validação com usuários](docs/usabilidade.md)
- Backlog, Story Map, MVP e Roadmap (artefato interativo)
- `Cade_Matriz_de_Riscos.xlsx`: riscos do projeto

## Equipe

Projeto desenvolvido em grupo. Matheus Emanoel e Kleyton.
