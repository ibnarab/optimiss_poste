#!/bin/bash

####################################################################################################
# LOC_NOM_DATASET est une variable locale du script mise a disposition par le lanceur
# via l'utilisation du parametre -Dapp.table=
####################################################################################################

####################################################################################################
# Database a alimenter
####################################################################################################
_database=$(bdl_utlconfig_get "app.${LOC_NOM_DATASET}.database")
# Le message pour la recuperation des information des lanceurs
bdl_lanclogger_info "Alimentation ${_database}.${LOC_NOM_DATASET}"

return 0
