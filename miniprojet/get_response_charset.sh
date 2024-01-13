#!/bin/bash

RESPONSE=$1

# commande qui recupère le charset de la reponse
echo $RESPONSE | egrep -o "charset=(\w|-)+" | tail -n 1 | cut -d= -f2
