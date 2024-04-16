#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

echo -e "$1"
if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_PRESENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")
    ATOMIC_NUMBER=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 1)
    SYMBOL=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 2)
    NAME=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 3)
    echo -e "$ATOMIC_NUMBER, $SYMBOL, $NAME"
  else
    ELEMENT_PRESENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
    ATOMIC_NUMBER=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 1)
    SYMBOL=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 2)
    NAME=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 3)
    echo -e "$ATOMIC_NUMBER, $SYMBOL, $NAME"
  fi
else
  echo "Please provide an element as an argument."
fi
