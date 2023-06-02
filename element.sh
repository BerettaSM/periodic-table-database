#! /bin/bash

# If no argument is given, exit.
if [[ -z $1 ]] ; then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  # Search for a single result where the argument matches the id, symbol or element name.

  QUERY_HEAD="SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE"

  # Determine the query criteria.
  if [[ $1 =~ ^[0-9]+$ ]] ; then
    # If it's a number, search by id.
    RESULT=$($PSQL "$QUERY_HEAD atomic_number = $1;")
  else
    # Else search by symbol or name.
    RESULT=$($PSQL "$QUERY_HEAD symbol = '$1' OR name = '$1';")
  fi

  # If no result found.
  if [[ -z $RESULT ]] ; then

    # Print message and exit.
    echo "I could not find that element in the database."

  else

    # Read the result into variables.
    IFS="|"
    read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $RESULT

    # Output the result.
    OUTPUT="The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

    echo $OUTPUT

  fi
fi
