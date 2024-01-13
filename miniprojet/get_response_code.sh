#!/bin/bash

RESPONSE=$1

# commande qui recupère le code HTTP de la réponse
echo $RESPONSE | egrep -o "^HTTP/.* [0-9]+" | tail -n 1 | cut -d' ' -f2
