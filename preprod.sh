#!/bin/bash

base_folder="./"
preprod_folder=${base_folder}"preprod"
alias_file=${base_folder}"bash_profile"

if [ -d "$preprod_folder" ]; then
    echo "---------------------------------"
    echo "/!\ Attention, le dossier $preprod_folder est déjà présent sur ce serveur !"
    echo "/!\ Il sera écrasé."
    echo "---------------------------------"

    echo -n "On continue ? (y/N) : "
    read response

    case "$response" in
    "y" | "Y" | "yes" | "YES" )
        echo "Let's go !"
        rm -rf ${preprod_folder}
        echo "Dossier $preprod_folder supprimé."
        ;;
    *)
        echo "On arrête là !"
        exit 1;
    esac
fi

if [ $# -lt 1 ]; then
    # ----------- On demande le nom du projet (nom du dossier)
    echo -n "Entrez le nom du projet (au même format que dans l'url bitbucket)  : "
    read projectname
else
    projectname=$1
fi

while [ "$projectname" = "" ]; do
    echo -n "Il me faut un nom de projet ! : "
    read projectname
done

echo "Clone du dépôt GIT :"
git clone https://mcir@bitbucket.org/mcir/${projectname}.git ${preprod_folder}
echo "Dossier cloné dans $preprod_folder"

echo "=================================="

echo "Téléchargement des outils (Composer et WP-cli) :"
git clone https://github.com/MyClientisRich/preprod.git ${base_folder}_exec

echo "=================================="
echo "On prépare les alias vers les fichiers"
echo 'alias composer="'${base_folder}'_exec/composer.phar"' >> ${alias_file}
echo 'alias wp="'${base_folder}'_exec/wp-cli.phar"' >> ${alias_file}
source ${alias_file}

echo "=================================="
echo "On rend les 2 fichiers executables"
chmod +x ${base_folder}_exec/composer.phar
chmod +x ${base_folder}_exec/wp-cli.phar

echo "=================================="
echo "On met à jour les 2 outils"
${base_folder}_exec/composer.phar self-update
${base_folder}_exec/wp-cli.phar cli update

echo "Et c'est pret !"