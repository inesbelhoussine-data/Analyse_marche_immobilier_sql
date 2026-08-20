--Verifier que les données ont bien chargé et que la création des tables est correct

SELECT COUNT(*) AS nb_regions FROM region;

SELECT COUNT(*) AS nb_communes FROM commune;

SELECT COUNT(*) AS nb_biens FROM bien;

SELECT COUNT(*) AS nb_ventes FROM vente;

--Verifier les clés primaires, pas de doublons de clés
SELECT id_region, COUNT(*) AS nb
FROM region
GROUP BY id_region
HAVING COUNT(*) > 1;

SELECT id_codedep_codecommune, COUNT(*) AS nb
FROM commune
GROUP BY id_codedep_codecommune
HAVING COUNT(*) > 1;

SELECT id_bien, COUNT(*) AS nb
FROM bien
GROUP BY id_bien
HAVING COUNT(*) > 1;

SELECT id_vente, COUNT(*) AS nb
FROM vente
GROUP BY id_vente
HAVING COUNT(*) > 1;

--Verifier les clés étrangères pas de valeurs orphelines

SELECT COUNT(*) AS communes_sans_region
FROM commune c
LEFT JOIN region r
    ON c.id_region = r.id_region
WHERE r.id_region IS NULL;

SELECT COUNT(*) AS biens_sans_commune
FROM bien b
LEFT JOIN commune c
    ON b.id_codedep_codecommune = c.id_codedep_codecommune
WHERE c.id_codedep_codecommune IS NULL;

SELECT COUNT(*) AS ventes_sans_bien
FROM vente v
LEFT JOIN bien b
    ON v.id_bien = b.id_bien
WHERE b.id_bien IS NULL;

--requetes pour tester si tout fonctionne

SELECT type_local, COUNT(*) AS nb
FROM bien
GROUP BY type_local
ORDER BY nb DESC;

SELECT MIN(valeur_fonciere) AS valeur_min,
       MAX(valeur_fonciere) AS valeur_max
FROM vente;

SELECT COUNT(*) AS nb_ventes_s1_2020
FROM vente
WHERE date_mutation >= DATE '2020-01-01'
  AND date_mutation < DATE '2020-07-01';

SELECT v.id_vente,
       v.date_mutation,
       v.valeur_fonciere,
       b.type_local,
       b.surface_local,
       c.nom_commune,
       c.code_departement,
       r.nom_region
FROM vente v
JOIN bien b
    ON v.id_bien = b.id_bien
JOIN commune c
    ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r
    ON c.id_region = r.id_region
LIMIT 20;
--check pour requete 6
SELECT COUNT(*) AS nb_valeurs_nulles
FROM vente
WHERE valeur_fonciere IS NULL;
SELECT COUNT(*) AS nb_total
FROM vente;

SELECT
    v.valeur_fonciere,
    r.nom_region,
    b.surface_local
FROM vente v
JOIN bien b ON v.id_bien = b.id_bien
JOIN commune c ON b.id_codedep_codecommune = c.id_codedep_codecommune
JOIN region r ON c.id_region = r.id_region
WHERE b.type_local = 'Appartement'
AND b.surface_local > 20
AND v.valeur_fonciere IS NOT NULL
AND v.date_mutation >= DATE '2020-01-01'
AND v.date_mutation < DATE '2020-07-01'
ORDER BY v.valeur_fonciere DESC
LIMIT 10;