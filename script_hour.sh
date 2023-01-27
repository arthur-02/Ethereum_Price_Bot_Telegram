#!/bin/bash

#Esthétique
hello="👋"
smile="😄"

#Récupération de la valeur
price_eth=$(echo $(curl 'https://www.coingecko.com/fr/pi%C3%A8ces/ethereum' | grep -Po '(?<=data-coin-symbol="eth" data-target="price.price">).*(?=</span></span>)') | sed 's/ *//g' | sed 's/\$//g' | sed 's/,/\./g')

#Envoie dans le ethereum_save.txt qui serivra de base de données immutable pour la suite
#et ethereum.txt qui sera supprimé par le 2ème script toutes les 24h
echo $(echo "$price_eth") >> ./ethereum_save.txt
echo $(echo "$price_eth") >> ./ethereum.txt

#Envoi du message à Telegram
curl --data chat_id="-yourchatID" --data-urlencode "text=${hello} Le prix de l'Ethereum est actuellement de ${price_eth}$ ${smile}" "https://api.telegram.org/botYour_TelgramAPI/sendMessage?parse_mode=HTML"


