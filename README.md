# 🏠 Analyse du marché immobilier français avec SQL

## 📌 Présentation

Ce projet consiste à concevoir et exploiter une **base de données relationnelle dédiée à l'analyse du marché immobilier français** à partir des données publiques **DVF (Demandes de Valeurs Foncières)**.

L'objectif est de transformer des données immobilières brutes en une base PostgreSQL structurée, fiable et exploitable afin de répondre à différentes problématiques d'analyse du marché immobilier.

Le projet couvre ainsi l'ensemble du processus allant de la préparation des données jusqu'à leur analyse avec SQL.

---

## 🎯 Objectifs

Ce projet a permis de :

- analyser et préparer plusieurs jeux de données immobilières et géographiques ;
- nettoyer les données avant leur intégration ;
- concevoir un modèle relationnel ;
- appliquer les principes de normalisation des bases de données ;
- créer des clés primaires et étrangères ;
- créer et alimenter une base de données PostgreSQL ;
- vérifier l'intégrité et la qualité des données importées ;
- réaliser des requêtes SQL répondant à des problématiques métier ;
- analyser les transactions immobilières selon différents critères géographiques et statistiques.

---

## 📊 Données utilisées

Les analyses reposent principalement sur les données publiques **DVF – Demandes de Valeurs Foncières**.

Elles contiennent notamment :

- les dates de mutation ;
- les valeurs foncières ;
- les types de biens ;
- les surfaces ;
- le nombre de pièces ;
- les informations géographiques ;
- les communes concernées.

Des données géographiques et démographiques complémentaires sont également utilisées afin d'intégrer notamment les informations de **région** et de **population**.

---

## 🧹 Préparation des données

Avant leur intégration dans PostgreSQL, les données ont été préparées afin de correspondre au modèle relationnel retenu.

Les principales étapes de préparation comprennent :

- sélection des variables utiles ;
- suppression des colonnes non nécessaires ;
- contrôle des valeurs manquantes ;
- recherche et suppression des doublons lorsque nécessaire ;
- harmonisation des formats ;
- préparation des différentes entités ;
- création des identifiants nécessaires ;
- export des données nettoyées au format CSV.

Un identifiant de commune est notamment construit à partir de la concaténation du **code département** et du **code commune**.

```text
code_departement + code_commune → id_codedep_codecommune
```

Les identifiants des biens et des ventes permettent quant à eux d'assurer l'unicité des enregistrements.

---

## 🗃️ Modélisation de la base

La base a été conçue selon un modèle relationnel afin de limiter la redondance des données et de garantir leur cohérence.

Les principales entités sont :

### Commune

Contient les informations géographiques et démographiques nécessaires aux analyses territoriales.

### Bien

Contient les caractéristiques propres aux biens immobiliers :

- localisation ;
- type de local ;
- surface ;
- nombre de pièces ;
- adresse.

### Vente

Contient les informations relatives aux transactions immobilières :

- date de mutation ;
- valeur foncière ;
- bien concerné.

### Relations principales

```text
COMMUNE
   │
   │ 1:N
   ▼
  BIEN
   │
   │ 1:N
   ▼
 VENTE
```

Une commune peut contenir plusieurs biens.

Un bien appartient à une commune et peut faire l'objet de plusieurs transactions au cours du temps.

---

## 🔑 Intégrité référentielle

La cohérence de la base est assurée grâce à l'utilisation de :

- **clés primaires (PK)** pour identifier chaque enregistrement ;
- **clés étrangères (FK)** pour relier les différentes tables ;
- contraintes d'intégrité ;
- contrôles des doublons ;
- contrôles des données orphelines.

Plusieurs requêtes SQL ont été réalisées après l'import afin de vérifier que l'ensemble des données avait correctement été chargé.

Exemple de contrôle des volumes :

```sql
SELECT 'commune' AS table_name, COUNT(*) AS nb_lignes
FROM commune

UNION ALL

SELECT 'bien', COUNT(*)
FROM bien

UNION ALL

SELECT 'vente', COUNT(*)
FROM vente;
```

---

## 🔍 Analyses SQL

Une fois la base opérationnelle, différentes requêtes ont été développées afin d'étudier le marché immobilier.

Les analyses portent notamment sur :

- le volume des transactions ;
- la répartition géographique des ventes ;
- les appartements et maisons vendus ;
- les valeurs foncières ;
- les prix au m² ;
- les différences entre territoires ;
- les évolutions du marché sur la période étudiée ;
- les indicateurs liés à la population.

Les requêtes utilisent notamment :

- `JOIN` et `LEFT JOIN`
- `GROUP BY`
- `ORDER BY`
- `COUNT()`
- `SUM()`
- `AVG()`
- `ROUND()`
- `CASE WHEN`
- sous-requêtes
- CTE (`WITH`)

---

## ✅ Contrôle de la qualité des données

Plusieurs contrôles ont été réalisés avant l'analyse :

- comparaison du nombre de lignes avant et après import ;
- vérification de l'unicité des clés primaires ;
- contrôle des clés étrangères ;
- recherche de données orphelines ;
- vérification des jointures ;
- contrôle des valeurs nulles ;
- vérification de la cohérence des types de données.

Ces vérifications permettent de s'assurer que les résultats des analyses reposent sur une base fiable.

---

## 💾 Sauvegarde et reproductibilité

Les éléments nécessaires à la reproduction du projet sont conservés :

- scripts de création de la base ;
- requêtes SQL ;
- données préparées ;
- dictionnaire de données ;
- schéma relationnel.

PostgreSQL permet également de sauvegarder une base à l'aide d'outils tels que `pg_dump`.

---

## 🔐 RGPD

Les données utilisées proviennent de jeux de données publics relatifs au marché immobilier.

Le principe de **minimisation des données** est appliqué en ne conservant que les variables nécessaires aux analyses.

Aucune donnée directement nominative telle qu'un nom, un prénom, une adresse e-mail ou un numéro de téléphone n'est utilisée dans les analyses.

---

## 🛠️ Technologies

- **SQL**
- **PostgreSQL**
- **DBeaver**
- **Excel**
- **Git / GitHub**


## 🧠 Compétences développées

Ce projet m'a permis de renforcer mes compétences en :

- conception et modélisation de bases de données relationnelles ;
- SQL ;
- PostgreSQL ;
- nettoyage et préparation de données ;
- création et gestion de clés primaires et étrangères ;
- jointures SQL ;
- agrégations ;
- CTE et sous-requêtes ;
- contrôle de l'intégrité référentielle ;
- analyse de données immobilières ;
- documentation d'une base de données.

---

## 🚀 Conclusion

Ce projet m'a permis de mettre en pratique l'ensemble du processus de création d'une base de données analytique : **préparation des données, modélisation, création de la base, contrôle de l'intégrité et exploitation avec SQL**.

Il m'a également permis de consolider ma compréhension de la modélisation relationnelle et de développer une approche plus rigoureuse du contrôle de la qualité des données avant toute analyse.
