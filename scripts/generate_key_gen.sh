#!/usr/bin/env bash

# navegar para diretorio
# cd ..

# arquivo existe
if [ ! -e id_rsa ]
then
  ssh-keygen -f ./id_rsa -q -o -t rsa -b 4096 -C "bionic" -N ""
  echo "Par de chaves ssh criado!"
fi
