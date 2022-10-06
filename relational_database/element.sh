#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c  "

MAIN(){

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    INFO=$($PSQL "select atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number = $1")

  elif [[ $1 =~ ^[a-Z]{1,2}$ ]]
  then
    INFO=$($PSQL "select atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol = '$1'")

  elif [[ $1 =~ ^[a-Z]+$ ]]
  then
    INFO=$($PSQL "select atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where name = '$1'")
  fi

  if [[ -z $INFO ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$INFO" | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELT BAR BOIL 
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
}

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  MAIN $1
fi


