# Busca por nome — SCRUM-17 / SCRUM-18

O histórico agora oferece a ação **Buscar objetos**, que abre a tela de
busca existente. O campo descreve o comportamento implementado: buscar
pelo nome. Os resultados mostram nome, local e miniatura quando há foto;
itens sem foto usam o ícone padrão, e falhas de leitura usam o ícone de
imagem indisponível.

`CadeDatabase.buscarObjetos` mantém o join com locais e a ordenação por
data. Normaliza apenas o texto usado na comparação: caixa baixa,
substituição dos acentos latinos usados em português e remoção de marcas
combinantes. O nome original permanece intacto no banco e na interface.
Não foi adicionada dependência nem alterado o esquema do banco.

A comparação é feita em memória sobre os registros do usuário, como já
acontece com os filtros no repository. É uma solução para o volume do MVP;
não é uma afirmação de desempenho para bases ilimitadas ou todos os idiomas.

## Validação

Os testes em `test/busca_nome_test.dart` cobrem busca parcial, maiúsculas,
acentos compostos e combinantes, termo vazio, ausência de resultados,
acesso pela interface e apresentação dos resultados.

Na validação local com SQLite em memória, a busca retornou **200 registros
em aproximadamente 5 ms**, abaixo do limite de 1 segundo do SCRUM-17.
Esse resultado mede a consulta local de teste; a experiência completa no
aparelho deve ser observada na validação com usuários.

A branch foi atualizada a partir da `develop` após a integração da correção
do PR #8 pelo PR #9. Commit, push e CI remoto dependem de publicação aprovada.
