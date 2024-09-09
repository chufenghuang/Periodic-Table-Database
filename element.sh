#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Check if the input is a number (atomic_number) or text (symbol or name)
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY_CONDITION="elements.atomic_number = $1"
else
  QUERY_CONDITION="symbol = '$1' OR name = '$1'"
fi

# Query the database for the element based on atomic_number, symbol, or name
ELEMENT_RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE $QUERY_CONDITION;")

# Check if the element exists in the database
if [[ -z $ELEMENT_RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Extract element information from the query result so the user can read more clearly
IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_RESULT"

# Output the information to the terminal so the user can read result
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."