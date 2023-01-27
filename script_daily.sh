#!/bin/bash

# Esthétique
date=$(date '+%A %d %B %Y')

#Traduction des jour de la semaine en français
date=$(echo "$date" | sed 's/Monday/Lundi/g')
date=$(echo "$date" | sed 's/Tuesday/Mardi/g')
date=$(echo "$date" | sed 's/Wednesday/Mercredi/g')
date=$(echo "$date" | sed 's/Thursday/Jeudi/g')
date=$(echo "$date" | sed 's/Friday/Vendredi/g')
date=$(echo "$date" | sed 's/Saturday/Samedi/g')
date=$(echo "$date" | sed 's/Sunday/Dimanche/g')

#Traduction des mois en français
date=$(echo "$date" | sed 's/January/Février/g')
date=$(echo "$date" | sed 's/February/Février/g')
date=$(echo "$date" | sed 's/March/Mars/g')
date=$(echo "$date" | sed 's/April/Avril/g')
date=$(echo "$date" | sed 's/May/Mai/g')
date=$(echo "$date" | sed 's/June/Juin/g')
date=$(echo "$date" | sed 's/July/Juillet/g')
date=$(echo "$date" | sed 's/August/Août/g')
date=$(echo "$date" | sed 's/September/Septembre/g')
date=$(echo "$date" | sed 's/October/Octobre/g')
date=$(echo "$date" | sed 's/November/Novembre/g')
date=$(echo "$date" | sed 's/December/Décembre/g')

reminder="📌"

#Valeur d'entrée (au début de la journée)
entry_value=$(head -1 ./ethereum.txt | sed 's/\n/ /g')

#Valeur de sortie (à la fin de la journée)
exit_value=$(tail -1 ./ethereum.txt | sed 's/\n/ /g' )

#Moyenne des 24 dernières heures avec 2 décimales
average=$(echo $(cat ./ethereum.txt | awk '{sum+=$1} END {print sum/NR}'))
average=$(printf "%0.2f" $average)

#valeur minimale des 24 dernières heures
min=$(sort -n ./ethereum.txt | head -1 | sed 's/\n/ /g')

#Valeur maximale des 24 dernières heures
max=$(sort -n ./ethereum.txt | tail -1 | sed 's/\n/ /g')

#Variation
variation=$(echo $(echo "$exit_value - $entry_value" | bc -l))

#add 0 when the variation is less than 1 and more than -1
if [ $(echo "$variation < 1" | bc -l) -eq 1 ] && [ $(echo "$variation > -1" | bc -l) -eq 1 ]; then
    variation=$(echo "$variation" | sed 's/\./0\./g')
fi

#Pourcentage de variation /a reprendre
percentage=$(echo $(echo "($exit_value - $entry_value) / $entry_value * 100" | bc -l))
echo $percentage

#round up percentage to 2 decimals
percentage=$(echo $(echo "$percentage" | awk '{printf "%.2f", $0}'))

price_variation=$(echo "scale=2; 100.00 * ($exit_value - $entry_value) / $entry_value" | bc)


#ajoute un smiley et une petite phrase en fonction de la variation (positive ou négative)
emoji_telegram=$(echo $price_variation | awk '{if ($1 > 0) print "📈 Prix en hausse ! \n Augmentation de "; else print "📉 Prix en baisse ! \n Baisse de "}')$percentage"%"
echo $emoji_telegram


#Envoi du message sur Telegram
curl --data chat_id="-Your_Chat_ID" --data-urlencode "text=- ${reminder} Résumé Quotidien Ethereum ${reminder} -

$date        

Valeur à 00h: ${entry_value}$
Valeur à 23h00: ${exit_value}$

Soit une augmentation de ${variation}$ sur la journée
-> ${emoji_telegram}

Valeur moyenne: ${average}$
Prix le plus bas: ${min}$
Prix le plus haut: ${max}$

 ---------------------------------------" "https://api.telegram.org/botYour_API_Telegram/sendMessage?parse_mode=HTML"


#Suppression du fichier pour recommencer une nouvelle journée
rm ethereum.txt
