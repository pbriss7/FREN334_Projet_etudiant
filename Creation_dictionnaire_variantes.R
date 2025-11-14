##################################################
##### CRÉATION D'UN DICTIONNAIRE DE VARIANTES ####
##################################################

# Création du répertoire où mettre les données importées depuis Recogito
if(!dir.exists("donnees")) {dir.create("donnees")}

# Création d'un répertoire où mettre les résultats
if(!dir.exists("Resultats")) {dir.create("Resultats")}

# -------------------------------------------------
# 1. Chargement des packages
# -------------------------------------------------
library(data.table)   # data.table est déjà installé dans la plupart des environnements R

# -------------------------------------------------
# 2. Lecture du tableau
# -------------------------------------------------
# Remplacez le chemin par le vôtre si le fichier n’est pas dans le répertoire de travail
dt <- fread("donnees/Annotations_pour_dictionnaire_variantes.csv", encoding = "UTF-8")

# -------------------------------------------------
# 3. Nettoyage léger (facultatif mais recommandé)
# -------------------------------------------------
dt[, VARIANTE := trimws(VARIANTE)]          # retire espaces avant/après
dt[, NOM_CANONIQUE := trimws(NOM_CANONIQUE)]

# -------------------------------------------------
# 4. On ne garde que les combinaisons uniques
# -------------------------------------------------
dt_unique <- unique(dt[, .(NOM_CANONIQUE, VARIANTE)])

# -------------------------------------------------
# 5. Agrégation : liste de variantes par nom canonique
# -------------------------------------------------
dict_dt <- dt_unique[, .(variantes = sort(unique(VARIANTE))), 
                     by = NOM_CANONIQUE]

# -------------------------------------------------
# 6. Transformation en liste nommée (dictionnaire)
# -------------------------------------------------
dict_list <- setNames(dict_dt$variantes, dict_dt$NOM_CANONIQUE)

# -------------------------------------------------
# 7. Inspection du résultat
# -------------------------------------------------
str(dict_list)          # structure de la liste
print(dict_list)        # affichage complet (ou partiel)

# -------------------------------------------------
# 8. Sauvegarde éventuelle
# -------------------------------------------------
saveRDS(dict_list, file = "dictionnaire_variantes.rds")
# Pour le recharger plus tard : dict_list <- readRDS("dictionnaire_variantes.rds")
