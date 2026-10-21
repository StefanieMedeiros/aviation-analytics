/*======================================================================
1. DIMENSÃO TEMPO
Descrição:
Armazena os atributos temporais utilizados nas análises do Data Warehouse.
======================================================================*/
CREATE TABLE DIM_TEMPO (

    id_tempo INTEGER PRIMARY KEY AUTOINCREMENT,

    ano INTEGER NOT NULL,

    mes INTEGER NOT NULL,

    nome_mes TEXT,

    trimestre INTEGER,

    semestre INTEGER

);

/*======================================================================
2. DIMENSÃO COMPANHIA AÉREA
Descrição:
Armazena os dados cadastrais das companhias aéreas presentes na base da ANAC.
======================================================================*/

CREATE TABLE DIM_COMPANHIA (

    id_companhia INTEGER PRIMARY KEY AUTOINCREMENT,

    empresa_sigla TEXT,

    empresa_nome TEXT,

    empresa_nacionalidade TEXT

);

/*======================================================================
3. DIMENSÃO AEROPORTO DE ORIGEM
Descrição:
Armazena os aeroportos utilizados como origem dos voos.
======================================================================*/



CREATE TABLE DIM_AEROPORTO_ORIGEM (

    id_aeroporto_origem INTEGER PRIMARY KEY AUTOINCREMENT,

    aeroporto_sigla TEXT,

    aeroporto_nome TEXT,

    uf TEXT,

    regiao TEXT,

    pais TEXT,

    continente TEXT

);


/*======================================================================
4. DIMENSÃO AEROPORTO DE DESTINO

Descrição:
Armazena os aeroportos utilizados como destino dos voos.

======================================================================*/

CREATE TABLE DIM_AEROPORTO_DESTINO (

    id_aeroporto_destino INTEGER PRIMARY KEY AUTOINCREMENT,

    aeroporto_sigla TEXT,

    aeroporto_nome TEXT,

    uf TEXT,

    regiao TEXT,

    pais TEXT,

    continente TEXT

);


/*======================================================================
5. DIMENSÃO NATUREZA

Descrição:
Armazena a classificação da natureza da operação e o grupo de voo.

======================================================================*/

CREATE TABLE DIM_NATUREZA (

    id_natureza INTEGER PRIMARY KEY AUTOINCREMENT,

    natureza TEXT,

    grupo_voo TEXT

);

/*======================================================================
6. TABELA FATO - TRANSPORTE AÉREO

Descrição:
Armazena os indicadores quantitativos do transporte aéreo brasileiro.
Cada registro representa a movimentação consolidada por companhia,
período, aeroporto de origem, aeroporto de destino e natureza da operação.


======================================================================*/

CREATE TABLE FATO_TRANSPORTE_AEREO (

    id_fato INTEGER PRIMARY KEY AUTOINCREMENT,

    /* Chaves das dimensões */

    id_tempo INTEGER NOT NULL,

    id_companhia INTEGER NOT NULL,

    id_aeroporto_origem INTEGER NOT NULL,

    id_aeroporto_destino INTEGER NOT NULL,

    id_natureza INTEGER NOT NULL,

    /* Indicadores de passageiros */

    passageiros_pagos INTEGER,

    passageiros_gratis INTEGER,

    /* Indicadores de carga */

    carga_paga_kg REAL,

    carga_gratis_kg REAL,

    correio_kg REAL,

    /* Indicadores operacionais */

    ask REAL,

    rpk REAL,

    atk REAL,

    rtk REAL,

    combustivel_litros REAL,

    distancia_voada_km REAL,

    decolagens INTEGER,

    carga_paga_km REAL,

    carga_gratis_km REAL,

    correio_km REAL,

    assentos INTEGER,

    payload REAL,

    horas_voadas REAL,

    bagagem_kg REAL,

     /* Relacionamentos */

    FOREIGN KEY (id_tempo)
        REFERENCES DIM_TEMPO(id_tempo),

    FOREIGN KEY (id_companhia)
        REFERENCES DIM_COMPANHIA(id_companhia),

    FOREIGN KEY (id_aeroporto_origem)
        REFERENCES DIM_AEROPORTO_ORIGEM(id_aeroporto_origem),

    FOREIGN KEY (id_aeroporto_destino)
        REFERENCES DIM_AEROPORTO_DESTINO(id_aeroporto_destino),

    FOREIGN KEY (id_natureza)
        REFERENCES DIM_NATUREZA(id_natureza)
);


/*======================================================================
7. ÍNDICES

Descrição:
Índices criados para otimizar consultas entre a tabela fato e as
dimensões do modelo estrela.
======================================================================*/

CREATE INDEX IDX_FATO_TEMPO
ON FATO_TRANSPORTE_AEREO(id_tempo);

CREATE INDEX IDX_FATO_COMPANHIA
ON FATO_TRANSPORTE_AEREO(id_companhia);

CREATE INDEX IDX_FATO_ORIGEM
ON FATO_TRANSPORTE_AEREO(id_aeroporto_origem);

CREATE INDEX IDX_FATO_DESTINO
ON FATO_TRANSPORTE_AEREO(id_aeroporto_destino);

CREATE INDEX IDX_FATO_NATUREZA
ON FATO_TRANSPORTE_AEREO(id_natureza);
