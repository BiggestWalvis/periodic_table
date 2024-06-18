PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1
if [[ -z $INPUT ]]
then
  echo "Please provide an element as an argument."
  
else 
  #if input is a number
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then
    #get data by atomic number
    ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$INPUT'")
    ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$INPUT'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$INPUT")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$INPUT")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$INPUT")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number=$INPUT")
    
    if [[ -z $ATOMIC_MASS ]]
    then
      echo "I could not find that element in the database."
    else
      echo "The element with atomic number $INPUT is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  else
    #if input is greater than 2 letters
    LENGTH=$(echo -n "$INPUT" | wc -m)
    if [[ $LENGTH -gt 2 ]]
    then
      #get data by full name
      #The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$INPUT'")
      ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$INPUT'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
      
      if [[ -z $ATOMIC_SYMBOL ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $ATOMIC_NUMBER is $INPUT ($ATOMIC_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $INPUT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi
    
    else
      #get data by atomic symbol
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT'")
      ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$INPUT'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number=$ATOMIC_NUMBER")
      
      if [[ -z $ATOMIC_NAME ]]
      then
        echo "I could not find that element in the database."
      else
      echo "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($INPUT). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi
    fi
  fi
fi
