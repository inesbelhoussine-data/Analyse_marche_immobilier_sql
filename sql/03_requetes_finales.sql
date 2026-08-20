--REQUETE 1
SELECT COUNT(*) AS nb_total_appartements_vendus
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
WHERE b.type_local = 'Appartement'
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01';

--REQUETE 2
SELECT
    r.nom_region,
    COUNT(*) AS nb_ventes_appartements
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.id_region = r.id_region
WHERE b.type_local = 'Appartement'
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01'
GROUP BY r.nom_region
ORDER BY nb_ventes_appartements DESC;

--REQUETE 3
SELECT
    b.total_piece,
    COUNT(*) AS nb_ventes,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS proportion_pct
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
WHERE b.type_local = 'Appartement'
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01'
GROUP BY b.total_piece
ORDER BY b.total_piece;

--REQUETE 4
SELECT
    c.code_departement,
    ROUND(AVG(v.valeur_fonciere / NULLIF(b.surface_local, 0)), 2) AS prix_m2_moyen
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE b.surface_local IS NOT NULL
  AND b.surface_local > 0
  AND v.valeur_fonciere IS NOT NULL
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01'
GROUP BY c.code_departement
ORDER BY prix_m2_moyen DESC
LIMIT 10;

--REQUETE 5
SELECT
    ROUND(AVG(v.valeur_fonciere / NULLIF(b.surface_local, 0)), 2) AS prix_m2_moyen_maison_idf
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.id_region = r.id_region
WHERE b.type_local = 'Maison'
  AND r.nom_region = 'Ile-de-France'
  AND b.surface_local IS NOT NULL
  AND b.surface_local > 0
  AND v.valeur_fonciere IS NOT NULL
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01';

--REQUETE 6
SELECT
    v.valeur_fonciere,
    r.nom_region,
    b.surface_local
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.id_region = r.id_region
WHERE b.type_local = 'Appartement'
  AND v.valeur_fonciere IS NOT null
  AND b.surface_local IS NOT null
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01'
ORDER BY v.valeur_fonciere DESC
LIMIT 10;

--REQUETE 7
WITH ventes_trimestre AS (
    SELECT
        CASE
            WHEN date_mutation >= DATE '2020-01-01' AND date_mutation < DATE '2020-04-01' THEN 'T1'
            WHEN date_mutation >= DATE '2020-04-01' AND date_mutation < DATE '2020-07-01' THEN 'T2'
        END AS trimestre,
        COUNT(*) AS nb_ventes
    FROM vente
    WHERE date_mutation >= DATE '2020-01-01'
      AND date_mutation < DATE '2020-07-01'
    GROUP BY
        CASE
            WHEN date_mutation >= DATE '2020-01-01' AND date_mutation < DATE '2020-04-01' THEN 'T1'
            WHEN date_mutation >= DATE '2020-04-01' AND date_mutation < DATE '2020-07-01' THEN 'T2'
        END
)
SELECT
    ROUND(
        (
            (MAX(CASE WHEN trimestre = 'T2' THEN nb_ventes END)
            - MAX(CASE WHEN trimestre = 'T1' THEN nb_ventes END)
            ) * 100.0
        ) / NULLIF(MAX(CASE WHEN trimestre = 'T1' THEN nb_ventes END), 0),
        2
    ) AS taux_evolution_pct
FROM ventes_trimestre;

--REQUETE 8
SELECT
    r.nom_region,
    ROUND(AVG(v.valeur_fonciere / NULLIF(b.surface_local, 0)), 2) AS prix_m2_moyen
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.id_region = r.id_region
WHERE b.type_local = 'Appartement'
  AND b.total_piece > 4
  AND b.surface_local IS NOT NULL
  AND b.surface_local > 0
  AND v.valeur_fonciere IS NOT NULL
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01'
GROUP BY r.nom_region
ORDER BY prix_m2_moyen DESC;

--REQUETE 9
SELECT
    c.nom_commune,
    c.code_departement,
    COUNT(*) AS nb_ventes
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-04-01'
GROUP BY c.nom_commune, c.code_departement
HAVING COUNT(*) >= 50
ORDER BY nb_ventes DESC;

--REQUETE 10
WITH prix_m2 AS (
    SELECT
        b.total_piece,
        AVG(v.valeur_fonciere / NULLIF(b.surface_local, 0)) AS prix_m2_moyen
    FROM vente v
    JOIN bien b ON v.id_bien = b.id_bien
    WHERE b.type_local = 'Appartement'
      AND b.total_piece IN (2, 3)
      AND b.surface_local IS NOT NULL
      AND b.surface_local > 0
      AND v.valeur_fonciere IS NOT NULL
      AND v.date_mutation >= DATE '2020-01-01'
      AND v.date_mutation < DATE '2020-07-01'
    GROUP BY b.total_piece
)
SELECT
    ROUND(
        (
            MAX(CASE WHEN total_piece = 3 THEN prix_m2_moyen END)
            - MAX(CASE WHEN total_piece = 2 THEN prix_m2_moyen END)
        ) * 100.0
        / NULLIF(MAX(CASE WHEN total_piece = 2 THEN prix_m2_moyen END), 0),
        2
    ) AS difference_pct
FROM prix_m2;

--REQUETE 11
WITH moyenne_commune AS (
    SELECT
        c.code_departement,
        c.nom_commune,
        AVG(v.valeur_fonciere) AS moyenne_valeur_fonciere
    FROM vente v
    JOIN bien b ON v.id_bien = b.id_bien
    JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
    WHERE c.code_departement IN ('6', '06', '13', '33', '59', '69')
      AND v.date_mutation >= DATE '2020-01-01'
      AND v.date_mutation < DATE '2020-07-01'
    GROUP BY c.code_departement, c.nom_commune
),
classement AS (
    SELECT
        code_departement,
        nom_commune,
        ROUND(moyenne_valeur_fonciere, 2) AS moyenne_valeur_fonciere,
        ROW_NUMBER() OVER (
            PARTITION BY code_departement
            ORDER BY moyenne_valeur_fonciere DESC
        ) AS rang
    FROM moyenne_commune
)
SELECT
    code_departement,
    nom_commune,
    moyenne_valeur_fonciere
FROM classement
WHERE rang <= 3
ORDER BY code_departement, moyenne_valeur_fonciere DESC;

--REQUETE 12
SELECT
    c.nom_commune,
    c.code_departement,
    COUNT(v.id_vente) AS nb_transactions,
    c.ptot AS population_totale,
    ROUND((COUNT(v.id_vente) * 1000.0) / NULLIF(c.ptot, 0), 2) AS transactions_pour_1000_habitants
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE c.ptot > 10000
  AND v.date_mutation >= DATE '2020-01-01'
  AND v.date_mutation < DATE '2020-07-01'
GROUP BY c.nom_commune, c.code_departement, c.ptot
ORDER BY transactions_pour_1000_habitants DESC
LIMIT 20;