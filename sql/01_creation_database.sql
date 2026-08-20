CREATE SCHEMA IF NOT EXISTS data_immo_p5;
SET search_path TO data_immo_p5;

-- TABLE REGION
CREATE TABLE IF NOT EXISTS region (
    id_region INTEGER PRIMARY KEY,
    nom_region VARCHAR(100) NULL
);

-- TABLE COMMUNE
CREATE TABLE IF NOT EXISTS commune (
    id_codedep_codecommune VARCHAR PRIMARY KEY,
    code_departement VARCHAR(10)  NULL,
    code_commune INTEGER  NULL,
    nom_commune VARCHAR(100) NULL,
    id_region INTEGER NULL,
    pmun INTEGER NULL,
    pcap INTEGER NULL,
    ptot INTEGER NULL,
    CONSTRAINT fk_commune_region
        FOREIGN KEY (id_region)
        REFERENCES region(id_region)
);

-- TABLE BIEN
CREATE TABLE IF NOT EXISTS bien (
    id_bien INTEGER  PRIMARY KEY,
    id_codedep_codecommune VARCHAR  NULL,
    no_voie INTEGER NULL,
    b_t_q VARCHAR(3) NULL,
    type_voie VARCHAR(20) NULL,
    code_postal VARCHAR(10) NULL,
    voie VARCHAR(100) NULL,
    total_piece INTEGER NULL,
    surface_carrez NUMERIC(10,2) NULL,
    surface_local NUMERIC(10,2) NULL,
    type_local VARCHAR(50) NULL,
    CONSTRAINT fk_bien_commune
        FOREIGN KEY (id_codedep_codecommune)
        REFERENCES commune(id_codedep_codecommune)
);

-- TABLE VENTE
CREATE TABLE IF NOT EXISTS vente (
    id_vente INTEGER PRIMARY KEY,
    id_bien INTEGER NULL,
    date_mutation DATE  NULL,
    valeur_fonciere NUMERIC(12,2),
    CONSTRAINT fk_vente_bien
        FOREIGN KEY (id_bien)
        REFERENCES bien(id_bien)
);

-- INDEX utiles
CREATE INDEX IF NOT EXISTS idx_commune_region
    ON commune(id_region);

CREATE INDEX IF NOT EXISTS idx_bien_commune
    ON bien(id_codedep_codecommune);

CREATE INDEX IF NOT EXISTS idx_vente_bien
    ON vente(id_bien);

CREATE INDEX IF NOT EXISTS idx_vente_date
    ON vente(date_mutation);