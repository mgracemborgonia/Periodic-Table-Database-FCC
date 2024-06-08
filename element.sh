#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $1 ]]
then
  # get elements
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    INSERT_ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number='$1'")
  else
    INSERT_ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$1' OR name='$1'")
  fi
  # if elements not found
  if [[ -z $INSERT_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $INSERT_ELEMENT | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MP_CELSIUS BP_CELSIUS
    do
      #echo $ATOMIC_NUMBER $NAME $SYMBOL $TYPE $ATOMIC_MASS $MP_CELSIUS $BP_CELSIUS
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP_CELSIUS celsius and a boiling point of $BP_CELSIUS celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
