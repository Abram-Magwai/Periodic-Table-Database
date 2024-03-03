PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_ATOMIC_NUMBER=$1
if [[ -n $ELEMENT_ATOMIC_NUMBER ]]
then
  if [[ $ELEMENT_ATOMIC_NUMBER =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")
  else
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$ELEMENT_ATOMIC_NUMBER' OR name='$ELEMENT_ATOMIC_NUMBER'")
  fi
  echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
  do
  if [[ ! -z $ATOMIC_NUMBER ]]
  then
    PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "$PROPERTIES" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
    do
      TYPE_NAME=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
  done
else
  echo "Please provide an element as an argument."
fi
