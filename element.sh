#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_PRESENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")
    ATOMIC_NUMBER=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 1)
    SYMBOL=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 2)
    NAME=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 3)
  else
    ELEMENT_PRESENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
    ATOMIC_NUMBER=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 1)
    SYMBOL=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 2)
    NAME=$(echo "$ELEMENT_PRESENT" | cut -d '|' -f 3)
  fi

  if [[ -z  $ELEMENT_PRESENT ]]
  then
   echo "I could not find that element in the database."
  else
    PROPERTIES=$($PSQL "SELECT * FROM properties JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$(echo "$PROPERTIES" | cut -d '|' -f 3)
    MELT_POINT=$(echo "$PROPERTIES" | cut -d '|' -f 4)
    BOIL_POINT=$(echo "$PROPERTIES" | cut -d '|' -f 5)
    TYPE=$(echo "$PROPERTIES" | cut -d '|' -f 6)

    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
else
  echo "Please provide an element as an argument."
fi
