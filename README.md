# Dashboard de Vendas com Redash

Trabalho da disciplina **SISTEMAS DE APOIO À DECISÃO**: apresentação de ferramentas de BI e análise de dados.

**Grupo:** ANDRÉ FILIPE FONTES FREITAS, LUCAS ARAGÃO DAMACENO, MIKAEL DOUGLAS SANTOS FARIAS, PAULO GABRIEL DE OLIVEIRA CARDOSO
**Professor(a):** GILTON JOSÉ FERREIRA DA SILVA
**Ferramenta estudada:** [Redash](https://redash.io)

---

## 1. Sobre o projeto

Este repositório contém o exemplo prático da apresentação sobre o **Redash**, uma ferramenta open source de BI baseada em consultas SQL, que permite criar visualizações, dashboards, parâmetros, atualizações agendadas e alertas.

**Problema abordado:** uma empresa fictícia de produtos de informática quer acompanhar o desempenho de suas vendas e identificar quais produtos, regiões e períodos merecem atenção.

**Solução:** um dashboard no Redash conectado a um banco PostgreSQL, com indicadores de faturamento, produtos mais vendidos e vendas por região, com filtro de período.

## 2. Dados utilizados

Os dados são **sintéticos** (gerados por SQL, sem informações reais) e ficam na tabela `vendas`, com 5.000 registros:

| Coluna | Descrição |
|---|---|
| `id` | Identificador da venda |
| `data_venda` | Data da venda (entre jan/2026 e out/2026) |
| `produto` | Notebook, Mouse, Teclado, Monitor, Headset ou Webcam |
| `regiao` | Norte, Nordeste, Centro-Oeste, Sudeste ou Sul |
| `quantidade` | Quantidade vendida (1 a 5) |
| `valor` | Valor da venda em reais |

O script `vendas.sql` cria e popula essa tabela. Como usa `random()`, os números mudam a cada execução.

## 3. Estrutura do repositório

```
.
├── README.md        # este arquivo
├── compose.yaml     # ambiente Docker do Redash
├── env.example      # modelo do arquivo de variáveis (sem senhas reais)
├── vendas.sql       # criação e carga da tabela de vendas
├── queries.sql      # consultas usadas no dashboard
└── imagens/         # prints do dashboard
```

## 4. Como reproduzir

### Pré-requisitos

- [Docker](https://www.docker.com/) com Docker Compose (no Windows e no Mac, o Docker Desktop)
- Cerca de 4 GB de memória livre

### Passo 1: Configurar as variáveis

Copie o modelo e edite os valores:

```bash
cp env.example env
```

Conteúdo do `env.example`:

```
REDASH_REDIS_URL=redis://redis:6379/0
POSTGRES_PASSWORD=troque-esta-senha
REDASH_COOKIE_SECRET=troque-por-um-texto-longo-1
REDASH_SECRET_KEY=troque-por-um-texto-longo-2
REDASH_DATABASE_URL=postgresql://postgres:troque-esta-senha@postgres/postgres
REDASH_ENFORCE_CSRF=true
REDASH_GUNICORN_TIMEOUT=60
```

A senha em `POSTGRES_PASSWORD` deve ser a mesma usada em `REDASH_DATABASE_URL`.

### Passo 2: Subir o Redash

```bash
docker compose -f compose.yaml run --rm server create_db
docker compose -f compose.yaml up -d
```

Aguarde alguns minutos e acesse **http://localhost** (ou a porta definida no `compose.yaml`). Na primeira vez, crie o usuário administrador.

Para conferir os containers:

```bash
docker compose -f compose.yaml ps
```

### Passo 3: Criar o banco e carregar os dados

```bash
docker compose -f compose.yaml exec postgres psql -U postgres -c "CREATE DATABASE vendas;"
```

Mac, Linux ou WSL:

```bash
docker compose -f compose.yaml exec -T postgres psql -U postgres -d vendas < vendas.sql
```

Windows (PowerShell):

```powershell
Get-Content vendas.sql | docker compose -f compose.yaml exec -T postgres psql -U postgres -d vendas
```

### Passo 4: Conectar o Redash ao banco

No Redash, acesse **Settings → Data Sources → New Data Source → PostgreSQL** e preencha:

| Campo | Valor |
|---|---|
| Host | `postgres` |
| Port | `5432` |
| User | `postgres` |
| Password | a senha definida no arquivo `env` |
| Database Name | `vendas` |

Clique em **Create** e depois em **Test Connection**.

### Passo 5: Criar as consultas e o dashboard

1. Em **Create → Query**, cole cada consulta do arquivo `queries.sql`, execute, nomeie e salve.
2. Crie a visualização de cada uma com **+ New Visualization**.
3. Na consulta 4, configure o parâmetro `periodo` como tipo **Date Range**.
4. Em **Create → Dashboard**, adicione as visualizações com **Add Widget**.
5. Opcional: configure o **Refresh Schedule** das consultas e um **Alert** sobre o faturamento total.

## 5. Consultas e visualizações

| # | Consulta | Visualização |
|---|---|---|
| 1 | Faturamento total | Counter |
| 2 | Faturamento por mês | Line |
| 3 | Faturamento por produto | Bar |
| 4 | Faturamento por região (com filtro de período) | Pie ou Bar |
| 5 | Ticket médio por região | Bar |

O código SQL de cada uma está em [`queries.sql`](queries.sql).

## 6. Recursos do Redash demonstrados

- Conexão com uma fonte de dados (PostgreSQL)
- Editor SQL e consultas salvas
- Diversos tipos de visualização
- Dashboard com várias visualizações
- Parâmetros dinâmicos (filtro por período)
- Atualização agendada de consultas
- Alertas

## 7. Resultados obtidos

> Preencher com os números reais do dashboard antes da apresentação.

- Faturamento total: **R$ [VALOR]**
- Mês com maior faturamento: **[MÊS]**; menor: **[MÊS]**
- Produto líder: **[PRODUTO]**; menor faturamento: **[PRODUTO]**
- Região líder: **[REGIÃO]**; menor faturamento: **[REGIÃO]**

![Dashboard](imagens/dashboard.png)

## 8. Apoio à tomada de decisão

- [Ex.: reforçar estoque e promoções do produto líder]
- [Ex.: investir em ações comerciais na região de menor desempenho]
- [Ex.: usar o alerta de faturamento para agir rapidamente em caso de queda]

## 9. Vantagens e limitações observadas

**Vantagens:** gratuito, open source, rápido de usar para quem sabe SQL, boa colaboração por meio de consultas e dashboards compartilhados.

**Limitações:** o serviço hospedado foi encerrado, então é preciso instalar e manter o próprio servidor; exige conhecimento de SQL; tem menos recursos visuais que Power BI ou Tableau.

## 10. Encerrar o ambiente

```bash
docker compose -f compose.yaml down
```

Para remover também os dados e as imagens:

```bash
docker compose -f compose.yaml down --volumes --rmi all
```

## 11. Referências

- Site oficial: https://redash.io
- Repositório oficial: https://github.com/getredash/redash
- Scripts de instalação: https://github.com/getredash/setup
- Documentação: https://redash.io/help
- [Adicionar outras referências utilizadas]
