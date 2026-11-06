# Validação do MVP com usuários — SCRUM-22

**Situação: não aplicada.** Kleyton confirmou que a equipe ainda não realizou
o teste com cinco pessoas. Este arquivo é um roteiro e uma ficha de coleta;
não representa entrevistas, tempos ou resultados já obtidos.

## Preparação

Usar a versão integrada e validada do aplicativo. Anotar commit/versão,
data, aparelho, versão do Android e quem observou cada sessão. Convidar
pelo menos cinco pessoas, incluindo pessoas fora do perfil técnico.
Identificá-las como P01 a P05, sem coletar nomes ou documentos pessoais.
Explicar que o objetivo é avaliar o aplicativo, e não a habilidade da pessoa.
Não orientar o caminho antes da tentativa; registrar qualquer ajuda necessária.

## Tarefas e critérios

| Tarefa | Instrução para a pessoa | O que registrar |
|---|---|---|
| Cadastrar | Imagine que guardou um documento numa gaveta. Registre onde ele ficou. | Sucesso, tempo do início da tentativa à confirmação, dúvidas e ajuda. Meta de cadastro: menos de 15 s. Foto é opcional. |
| Encontrar | Saia do cadastro e descubra onde guardou o documento. | Sucesso e tempo até identificar o local. Meta: menos de 10 s. |
| Atualizar | Agora você mudou o documento para um armário. Atualize o local. | Caminho escolhido, toques para acessar o campo, sucesso e dificuldades. |
| Persistir offline | Sem internet, feche e reabra o app; procure novamente o documento. | Se o local atualizado continua disponível. |
| Excluir | Remova o registro de teste que não é mais necessário. | Confirmação exibida, cancelamento possível e ausência do item após confirmar. |
| Permissão de câmera | Se ainda não foi concedida, tente adicionar foto e decida se permite. | Explicação anterior à solicitação e continuidade sem foto em caso de negativa. |

Cronometrar separadamente cadastro e localização. Não descontar erros nem
substituir tentativas lentas por valores melhores. Interromper se a pessoa
preferir desistir e registrar a desistência.

## Perguntas finais

1. O que foi fácil e o que foi difícil?
2. Você conseguiu entender onde informar e consultar o local?
3. Houve algum texto, botão ou pedido de permissão confuso?
4. Você usaria o aplicativo para lembrar onde guardou objetos? Por quê?

Preencher [resultados-usabilidade.csv](resultados-usabilidade.csv) com os
dados reais. As cinco linhas são espaços de coleta, não participantes já
testados. Registrar feedback e problemas sem identificar a pessoa.

## Consolidação e aceite

- Contar participantes reais e tarefas concluídas, inclusive com ajuda.
- Apurar os tempos individuais e indicar quantas tentativas atenderam às metas.
- Relacionar dificuldades aos riscos R01, R02, R03, R06 e R09 do planejamento.
- Registrar problemas encontrados no Jira, com evidência e responsável.
- Corrigir e retestar os problemas críticos; manter os demais no backlog.
- Anexar ou vincular os resultados ao SCRUM-22 e registrar a demonstração
  na Review. Concluir a história somente após cumprir seus critérios e a DoD.

Os testes automatizados do repositório verificam comportamento do código;
não substituem esta validação com pessoas.
