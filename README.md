# 🏠 Analyse du marché immobilier français avec SQL

## 📌 Présentation

Ce projet consiste à concevoir et exploiter une **base de données relationnelle dédiée à l'analyse du marché immobilier français** à partir des données publiques **DVF (Demandes de Valeurs Foncières)**.

L'objectif est de transformer des données immobilières brutes en une base PostgreSQL structurée, fiable et exploitable afin de répondre à différentes problématiques d'analyse du marché immobilier.

Le projet couvre l'ensemble du processus, depuis la préparation et la modélisation des données jusqu'à leur intégration dans PostgreSQL et leur analyse avec SQL.

---

## 🎯 Objectifs

Ce projet a permis de :

- analyser et préparer des données immobilières, géographiques et démographiques ;
- nettoyer les données avant leur intégration ;
- concevoir un modèle relationnel normalisé ;
- structurer les données autour de plusieurs entités métier ;
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
- les informations d'adresse ;
- les codes postaux ;
- les communes concernées.

Ces données ont été complétées par des informations géographiques et démographiques permettant notamment d'intégrer :

- la **région** ;
- la **population municipale** ;
- la **population comptée à part** ;
- la **population totale**.

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
- export des données préparées au format CSV.

Un identifiant de commune a notamment été construit à partir de la concaténation du **code département** et du **code commune** :

```text
code_departement + code_commune → id_codedep_codecommune
```

Cet identifiant permet de relier les biens immobiliers à leur commune.

---

## 🗃️ Modélisation de la base

La base de données est organisée autour de **quatre tables principales** :

### 🌍 Region

La table `region` contient les régions françaises.

Principales informations :

- `id_region` : identifiant unique de la région ;
- `nom_region` : nom de la région.

Une région peut être associée à plusieurs communes.

---

### 🏙️ Commune

La table `commune` contient les informations géographiques et démographiques relatives aux communes.

Principales informations :

- `id_codedep_codecommune` : identifiant unique de la commune ;
- `id_region` : région à laquelle appartient la commune ;
- `code_departement` ;
- `code_commune` ;
- `nom_commune` ;
- `pmun` : population municipale ;
- `pcap` : population comptée à part ;
- `ptot` : population totale.

La clé étrangère `id_region` permet de relier chaque commune à sa région.

---

### 🏡 Bien

La table `bien` contient les caractéristiques des biens immobiliers.

Elle comprend notamment :

- `id_bien` : identifiant unique du bien ;
- `id_codedep_codecommune` : commune du bien ;
- numéro et type de voie ;
- voie ;
- code postal ;
- type de local ;
- nombre de pièces ;
- surface réelle bâtie ;
- surface du terrain.

Chaque bien est rattaché à une commune grâce à une clé étrangère.

---

### 💰 Vente

La table `vente` contient les informations relatives aux transactions immobilières.

Elle comprend notamment :

- `id_vente` : identifiant unique de la transaction ;
- `id_bien` : bien concerné par la transaction ;
- `date_mutation` : date de la vente ;
- `valeur_fonciere` : montant de la transaction.

Chaque vente est associée à un bien immobilier.

---

## 🔗 Relations entre les tables

Le modèle relationnel suit la structure suivante :

```text
REGION
   │
   │ 1:N
   ▼
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

Les relations permettent ainsi de naviguer de la transaction immobilière jusqu'à son contexte géographique :

**Vente → Bien → Commune → Région**

Une région peut contenir plusieurs communes.

Une commune peut contenir plusieurs biens.

Un bien peut être associé à plusieurs transactions immobilières au cours du temps.

Cette organisation permet de limiter la redondance des informations tout en facilitant les analyses géographiques.

---

## 🔑 Intégrité référentielle

La cohérence de la base est assurée grâce à l'utilisation de :

- **clés primaires (PK)** pour identifier chaque enregistrement ;
- **clés étrangères (FK)** pour relier les différentes tables ;
- contraintes d'intégrité ;
- contrôles des doublons ;
- contrôles des données orphelines.

Les principales relations sont :

```text
commune.id_region
    → region.id_region

bien.id_codedep_codecommune
    → commune.id_codedep_codecommune

vente.id_bien
    → bien.id_bien
```

---

## ✅ Contrôle du chargement des données

Après l'import dans PostgreSQL, plusieurs requêtes ont été réalisées afin de vérifier le bon chargement des données.

Exemple de contrôle des volumes :

```sql
SELECT 'region' AS table_name, COUNT(*) AS nb_lignes
FROM region

UNION ALL

SELECT 'commune', COUNT(*)
FROM commune

UNION ALL

SELECT 'bien', COUNT(*)
FROM bien

UNION ALL

SELECT 'vente', COUNT(*)
FROM vente;
```

Des contrôles supplémentaires ont également permis de vérifier :

- l'absence de doublons sur les clés primaires ;
- l'intégrité des clés étrangères ;
- l'absence de données orphelines ;
- la cohérence des relations entre les tables.

---

## 🔍 Analyses SQL

Une fois la base créée, chargée et contrôlée, différentes requêtes SQL ont été développées afin d'étudier le marché immobilier.

Les analyses portent notamment sur :

- le volume des transactions immobilières ;
- la répartition des ventes par région ;
- les ventes d'appartements et de maisons ;
- les valeurs foncières ;
- les prix au m² ;
- les différences entre territoires ;
- l'évolution du marché immobilier ;
- les analyses prenant en compte la population des communes.

Les requêtes mobilisent notamment :

- `JOIN` et `LEFT JOIN` ;
- `WHERE` ;
- `GROUP BY` ;
- `ORDER BY` ;
- `COUNT()` ;
- `SUM()` ;
- `AVG()` ;
- `ROUND()` ;
- `CASE WHEN` ;
- sous-requêtes ;
- CTE (`WITH`).

---

## 🧪 Contrôle de la qualité des données

Plusieurs contrôles ont été réalisés avant l'exploitation de la base :

- comparaison des volumes après import ;
- vérification de l'unicité des clés primaires ;
- contrôle des clés étrangères ;
- recherche de données orphelines ;
- vérification des jointures ;
- contrôle des valeurs nulles ;
- vérification de la cohérence des types de données.

Ces vérifications permettent de s'assurer que les analyses reposent sur une base structurée et cohérente.

---

## 💾 Sauvegarde et reproductibilité

Les différents éléments nécessaires à la reproduction du projet sont conservés dans le repository :

- scripts de création de la base ;
- requêtes de contrôle d'intégrité ;
- requêtes d'analyse SQL ;
- données préparées ;
- dictionnaire de données ;
- schéma relationnel ;
- présentation du projet.

PostgreSQL permet également de réaliser une sauvegarde complète de la base à l'aide d'outils tels que `pg_dump`.

---

## 🔐 RGPD

Les données utilisées proviennent de jeux de données publics relatifs au marché immobilier.

Le principe de **minimisation des données** est appliqué en conservant uniquement les variables nécessaires aux analyses.

Aucune donnée directement nominative telle qu'un nom, un prénom, une adresse e-mail ou un numéro de téléphone n'est utilisée dans les analyses.

---

## 🛠️ Technologies utilisées

- **SQL**
- **PostgreSQL**
- **DBeaver**
- **Excel**
- **Git**
- **GitHub**

---

## 🧠 Compétences développées

Ce projet m'a permis de renforcer mes compétences en :

- conception et modélisation de bases de données relationnelles ;
- SQL ;
- PostgreSQL ;
- préparation et nettoyage de données ;
- création et gestion de clés primaires et étrangères ;
- jointures SQL ;
- agrégations ;
- CTE et sous-requêtes ;
- contrôle de l'intégrité référentielle ;
- analyse de données immobilières ;
- analyse géographique et démographique ;
- documentation d'une base de données.

---

## 🚀 Conclusion

Ce projet m'a permis de mettre en pratique l'ensemble du processus de création et d'exploitation d'une base de données relationnelle : **préparation des données, modélisation, création de la base PostgreSQL, contrôle de l'intégrité et analyses SQL**.

La structuration des données autour des tables **Region, Commune, Bien et Vente** permet d'analyser les transactions immobilières tout en intégrant leurs dimensions géographiques et démographiques.

Ce projet m'a également permis de consolider ma maîtrise de **SQL et PostgreSQL**, ainsi que ma compréhension de la modélisation relationnelle et des contrôles de qualité indispensables avant toute analyse de données.
