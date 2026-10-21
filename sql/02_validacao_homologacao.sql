/* ==========================================================
   AVIATION ANALYTICS
   VALIDAÇÃO E HOMOLOGAÇÃO DO DATA WAREHOUSE

   Banco de dados: SQLite
   Ferramenta: DBeaver

   Objetivo: Validar a carga de dados, a integridade referencial
   e a qualidade dos dados do modelo dimensional.

   Todas as consultas deste arquivo são somente de leitura.
   ========================================================== */

/* ==========================================================
   VALIDAÇÃO 01 - QUANTIDADE DE REGISTROS

   Objetivo: Conferir o volume de registros carregados na tabela fato.

   Resultado obtido: 137.014 registros
   Status: Conforme
   ========================================================== */

SELECT
    COUNT(*) AS total_registros
FROM FATO_TRANSPORTE_AEREO;

/* ==========================================================
   VALIDAÇÃO 02 - INTEGRIDADE REFERENCIAL

   Objetivo:  Identificar registros da tabela fato sem correspondência
   nas respectivas dimensões.

   Resultado obtido: 0 inconsistências em todas as dimensões.
   Status: Conforme
   ========================================================== */

-- 02.1 - Companhia Aérea
SELECT COUNT(*) AS registros_sem_companhia
FROM FATO_TRANSPORTE_AEREO f
LEFT JOIN DIM_COMPANHIA c
    ON f.id_companhia = c.id_companhia
WHERE c.id_companhia IS NULL;

-- 02.2 - Tempo
SELECT COUNT(*) AS registros_sem_tempo
FROM FATO_TRANSPORTE_AEREO f
LEFT JOIN DIM_TEMPO t
    ON f.id_tempo = t.id_tempo
WHERE t.id_tempo IS NULL;

-- 02.3 - Aeroporto de Origem
SELECT COUNT(*) AS registros_sem_origem
FROM FATO_TRANSPORTE_AEREO f
LEFT JOIN DIM_AEROPORTO_ORIGEM o
    ON f.id_aeroporto_origem = o.id_aeroporto_origem
WHERE o.id_aeroporto_origem IS NULL;

-- 02.4 - Aeroporto de Destino
SELECT COUNT(*) AS registros_sem_destino
FROM FATO_TRANSPORTE_AEREO f
LEFT JOIN DIM_AEROPORTO_DESTINO d
    ON f.id_aeroporto_destino = d.id_aeroporto_destino
WHERE d.id_aeroporto_destino IS NULL;

-- 02.5 - Natureza da Operação
SELECT COUNT(*) AS registros_sem_natureza
FROM FATO_TRANSPORTE_AEREO f
LEFT JOIN DIM_NATUREZA n
    ON f.id_natureza = n.id_natureza
WHERE n.id_natureza IS NULL;

/* ==========================================================
   VALIDAÇÃO 03 - DUPLICIDADES NAS DIMENSÕES

   Objetivo: Identificar combinações repetidas de atributos
   nas cinco dimensões do Data Warehouse.

   Resultado: Nenhuma duplicidade identificada.
   Status: Conforme para os critérios avaliados.
   ========================================================== */

-- 03.1 - Dimensão Tempo
SELECT ano, mes, COUNT(*) AS quantidade
FROM DIM_TEMPO
GROUP BY ano, mes
HAVING COUNT(*) > 1;

-- 03.2 - Dimensão Companhia Aérea
SELECT
    empresa_sigla,
    empresa_nome,
    empresa_nacionalidade,
    COUNT(*) AS quantidade
FROM DIM_COMPANHIA
GROUP BY
    empresa_sigla,
    empresa_nome,
    empresa_nacionalidade
HAVING COUNT(*) > 1;

-- 03.3 - Dimensão Aeroporto de Origem
SELECT
    aeroporto_sigla,
    aeroporto_nome,
    pais,
    COUNT(*) AS quantidade
FROM DIM_AEROPORTO_ORIGEM
GROUP BY
    aeroporto_sigla,
    aeroporto_nome,
    pais
HAVING COUNT(*) > 1;

-- 03.4 - Dimensão Aeroporto de Destino
SELECT
    aeroporto_sigla,
    aeroporto_nome,
    pais,
    COUNT(*) AS quantidade
FROM DIM_AEROPORTO_DESTINO
GROUP BY
    aeroporto_sigla,
    aeroporto_nome,
    pais
HAVING COUNT(*) > 1;

-- 03.5 - Dimensão Natureza
SELECT
    natureza,
    grupo_voo,
    COUNT(*) AS quantidade
FROM DIM_NATUREZA
GROUP BY natureza, grupo_voo
HAVING COUNT(*) > 1;

/* ==========================================================
   VALIDAÇÃO 04 - GRANULARIDADE DA TABELA FATO

   Objetivo:    Identificar combinações repetidas das cinco chaves
   dimensionais e investigar os registros encontrados.

   Resultado:  Foram identificadas combinações repetidas.
   Na amostra investigada, os registros apresentaram
   valores operacionais distintos.

   Status: Ponto de atenção.
   A granularidade da base original requer investigação
   complementar, especialmente quanto ao grupo de voo.

   Nenhum registro foi excluído ou alterado.
   ========================================================== */

-- 04.1 - Identificar combinações repetidas
SELECT
    id_tempo,
    id_companhia,
    id_natureza,
    id_aeroporto_origem,
    id_aeroporto_destino,
    COUNT(*) AS quantidade_registros
FROM FATO_TRANSPORTE_AEREO
GROUP BY
    id_tempo,
    id_companhia,
    id_natureza,
    id_aeroporto_origem,
    id_aeroporto_destino
HAVING COUNT(*) > 1
ORDER BY quantidade_registros DESC
LIMIT 10;

-- 04.2 - Investigar uma combinação identificada
-- Amostra referente a janeiro de 2023
SELECT
    id_fato,
    passageiros_pagos,
    decolagens,
    assentos,
    ask,
    distancia_voada_km
FROM FATO_TRANSPORTE_AEREO
WHERE id_tempo = 913
  AND id_companhia = 1318
  AND id_natureza = 3
  AND id_aeroporto_origem = 3781
  AND id_aeroporto_destino = 1987
ORDER BY id_fato;

