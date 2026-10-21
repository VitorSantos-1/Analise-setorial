# Análise Setorial & Desempenho por Segmento

Relatório desenvolvido em **Power BI** para a análise setorial e o desempenho por categoria de
produtos de uma rede varejista. O painel compara a performance dos diferentes setores, identificando
crescimento, participação de vendas (share) e rentabilidade de cada segmento, para orientar decisões
de mix, compra e alocação de espaço.

---

## Visão Geral

A solução organiza a base de vendas por setor e categoria em um modelo dimensional e entrega uma
leitura comparativa entre segmentos: quanto cada setor fatura, qual sua margem, qual sua
participação no total e como evolui no tempo. É a base para decidir onde investir mix e espaço e o
que revisar.

> **Nota de confidencialidade:** todos os dados exibidos no arquivo `.pbix` são fictícios e
> anonimizados, criados exclusivamente para demonstração de portfólio.

---

## Contexto de Negócio

Nem todo setor que vende muito é o que dá mais retorno. Volume alto com margem baixa pode render
menos que um setor menor e mais rentável, e categorias de baixo giro ocupam espaço e capital sem
retorno proporcional. Sem uma comparação padronizada de margem, share e giro, o mix é decidido por
inércia. Este painel dá o denominador comum para priorizar as categorias certas.

## O Problema que Resolve

- **Comparação entre setores por volume apenas**, ignorando margem e giro.
- **Mix decidido por inércia**, sem base de rentabilidade por segmento.
- **Sazonalidade não mapeada** por categoria.
- **Espaço e capital alocados** sem leitura de retorno por setor.

## Público e Decisões Apoiadas

- **Compras / Comercial:** prioriza categorias mais rentáveis e revisa o mix.
- **Diretoria:** acompanha a participação e a evolução de cada setor.
- **Gestão de categoria:** identifica sazonalidade e oportunidades por segmento.

## Impacto e Valor Gerado

Comparou margem, share e giro por setor, permitindo priorizar as categorias mais rentáveis e revisar
o mix das que apenas ocupam espaço sem retorno — melhorando a rentabilidade do portfólio de produtos.

---

## Arquitetura de Dados e Abordagem Técnica

### Fontes de dados
- Base de **vendas** por produto e período.
- Cadastros de **produtos** e **setores / categorias**.

### Transformação (Power Query / M)
ETL e higienização das tabelas de produtos, vendas e categorias; padronização da hierarquia de
setor / categoria; e cálculo das bases de margem e giro. O tratamento é centralizado no Power Query.

### Modelagem dimensional (Star Schema)
- **Fato Vendas** — grão de venda por produto / data.
- **Dimensão Setor / Categoria** — hierarquia de segmento.
- **Dimensão Produto** — atributos do item.
- **Dimensão Calendário** — base das análises temporais (YoY / MoM).

### Principais medidas (DAX) — lógica implementada

```DAX
Faturamento Setor = SUM( FatoVendas[Valor] )
Margem Setor %    = DIVIDE( [Lucro Bruto Setor], [Faturamento Setor] )
Share %           = DIVIDE( [Faturamento Setor], CALCULATE( [Faturamento Setor], ALL( DimSetor ) ) )
Giro Medio        = DIVIDE( [Unidades Vendidas], [Estoque Medio] )
Variacao YoY %    = DIVIDE( [Faturamento Setor] - [Faturamento Ano Anterior], [Faturamento Ano Anterior] )
```

> As fórmulas descrevem a lógica de cálculo do relatório e servem como referência de leitura do modelo.

---

## Indicadores e Análises (KPIs)

- **Faturamento & Margem por Setor:** receita bruta e margem gerada por cada categoria.
- **Participação de Mercado (Share %):** peso de cada setor no faturamento global.
- **Evolução Temporal & Sazonalidade:** volume por setor ao longo de meses e trimestres.
- **Ranking de Categorias:** setores com maior giro de estoque e maior rentabilidade.

## Estrutura de Páginas do Relatório

1. **Visão Setorial** — faturamento, margem e share por setor.
2. **Ranking de Categorias** — rentabilidade e giro comparados.
3. **Evolução & Sazonalidade** — séries temporais por segmento.

## Como Visualizar

O relatório é apresentado pelas imagens da seção **Prints** abaixo, que reproduzem as páginas
principais do painel. O arquivo-fonte (`.pbix`) não é versionado neste repositório por conter o
modelo de dados; pode ser disponibilizado sob solicitação para avaliação técnica.

## Estrutura de Arquivos

```text
README.md    -> Documentacao do projeto (contexto de negocio + arquitetura tecnica)
docs/        -> Prints das paginas do relatorio
.gitignore   -> Exclui binarios (.pbix) e planilhas de trabalho do versionamento
```

## Apresentação Executiva em PDF

O relatório completo consolidado está disponível no arquivo PDF abaixo. Todos os dados são fictícios e os nomes de compradores e lojas foram devidamente tarjados para preservação de sigilo comercial:

> 📄 **[Clique aqui para abrir o PDF da Apresentação Executiva](docs/Dashboard_Analise_Setorial_LinkedIn.pdf)**

---

## Prints do Relatório por Página

### 01. Capa Executiva
![Capa Executiva](docs/01_Capa_Executiva.png)

### 02. Visão Geral de Vendas & Metas
![Visão Geral de Vendas](docs/02_Visao_Geral_Vendas.png)

### 03. Decomposição PVM (Preço, Volume e Mix) & Elasticidade
![Decomposição PVM e Elasticidade](docs/03_Decomposicao_PVM.png)

### 04. Lucro Bruto & Rentabilidade Setorial
![Lucro e Rentabilidade](docs/04_Lucro_Rentabilidade.png)

### 05. Detalhamento Comercial: Tooltip de Vendas (Açougue)
![Tooltip de Vendas](docs/05_Tooltip_Vendas_Acougue.png)

### 06. Detalhamento de Rentabilidade: Tooltip de Lucro (Açougue)
![Tooltip de Lucro](docs/06_Tooltip_Lucro_Acougue.png)

---

## Autor

Vitor Santos — Análise de Dados e Inteligência Comercial (Varejo).

## 🗺️ Modelo de Dados (DER)

Modelo dimensional (*snowflake*) que sustenta o painel, extraído do banco MySQL `analise_setorial`. A hierarquia mercadológica é normalizada em dimensões próprias e cada **comprador** responde por um conjunto de categorias. Renderizado pelo GitHub via Mermaid. *Dados fictícios de demonstração.*

```mermaid
erDiagram
    dim_comprador ||--o{ dim_mercadologico : "responsável por"
    dim_mercadologico ||--o{ dim_submercadologico : "desdobra em"
    dim_mercadologico ||--o{ dim_produto : "classifica"
    dim_submercadologico ||--o{ dim_produto : "subclassifica"
    dim_produto ||--o{ fato_analise_setorial : "dimensiona"
    dim_loja ||--o{ fato_analise_setorial : "dimensiona"

    dim_comprador {
        int pk_comprador PK
        varchar descricao_comprador
    }
    dim_loja {
        int pk_loja PK
        varchar descricao_loja
    }
    dim_mercadologico {
        int pk_mercadologico PK
        varchar descricao_mercadologico
        int fk_comprador FK
    }
    dim_submercadologico {
        int pk_submercadologico PK
        int fk_mercadologico FK "+ compõe a PK"
        varchar descricao_submercadologico
        varchar id_unico_submercadologico
    }
    dim_produto {
        int pk_produto PK
        varchar descricao_produto
        varchar codigo_identificacao "ex: 001.013.003"
        int fk_mercadologico FK
        int fk_submercadologico FK
        varchar id_unico_submercadologico
    }
    fato_analise_setorial {
        int pk_fato_analise_setorial PK
        int fk_produto FK
        int fk_loja FK
        int quantidade
        decimal venda
        decimal lucro
        date data "grão mensal"
    }
```

### 📐 Métricas e cálculos derivados (camada analítica / DAX)
A fato guarda os fatos brutos (`quantidade`, `venda`, `lucro`); os indicadores abaixo são calculados sobre a hierarquia `comprador → mercadológico → submercadológico → produto`:

- **Margem %** = `lucro / venda`
- **Participação (share)** de cada setor/categoria no total (× período e × loja)
- **Curva ABC** de produtos/categorias por faturamento
- **Run Rate** e **crescimento YoY** (ano contra ano)
- **Análise de desvios** (realizado × esperado) por setor e comprador

## ⚙️ ETL & Modelo físico
Pipeline que alimenta o painel (consolidado neste repositório):
- **`sql/schema.sql`** — DDL real do banco MySQL `analise_setorial` (exportado via `SHOW CREATE TABLE`).
- **`etl/`** — scripts Python (Pandas + SQLAlchemy): cadastro da dimensão de produtos e carga da fato de vendas setoriais, com `data_exemplo/` fictício.
