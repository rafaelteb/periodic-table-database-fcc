#!/bin/env bash
shopt -s extglob

# PostgreSQL connection parameters
DB_NAME="periodic_table"
DB_USER="freecodecamp"
PSQL="psql -d $DB_NAME -U $DB_USER"

# Wrong input warning
EXIT_TEXT="Please provide an element as an argument."
# Not found text
NOT_FOUND="I could not find that element in the database."

# Function to display information about the element
display_element_info() {
  ATOMIC_NUMBER=$(echo $1 | cut -d '|' -f 1)
  TYPE=$(echo $1 | cut -d '|' -f 10)
  SYMBOL=$(echo $1 | cut -d '|' -f 7)
  NAME=$(echo $1 | cut -d '|' -f 8)
  ATOMIC_MASS=$(echo $1 | cut -d '|' -f 2)
  MELTING_POINT_CELSIUS=$(echo $1 | cut -d '|' -f 3)
  BOILING_POINT_CELSIUS=$(echo $1 | cut -d '|' -f 4)

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
}

case $1 in
  [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
    # Block for numeric input
    TABLE_ELEMENTS_AND_PROPERTIES=$($PSQL -c "SELECT * FROM properties AS p JOIN elements AS e ON p.atomic_number = e.atomic_number JOIN types AS t ON t.type_id = p.type_id WHERE e.atomic_number = '$1';")
    RESULT=$(echo "$TABLE_ELEMENTS_AND_PROPERTIES" | awk 'NR==3' | tr -d ' ')

    if [[ "$RESULT" == "(0rows)" ]]; then
      echo "$NOT_FOUND"
    else
      # Display information about the element
      display_element_info "$RESULT"
    fi
    ;;
  [A-Za-z]|[A-Za-z][A-Za-z])
    # Block for alphabetic input
    TABLE_ELEMENTS_AND_PROPERTIES=$($PSQL -c "SELECT * FROM properties AS p JOIN elements AS e ON p.atomic_number = e.atomic_number JOIN types AS t ON t.type_id = p.type_id WHERE e.symbol = '$1';")
    RESULT=$(echo "$TABLE_ELEMENTS_AND_PROPERTIES" | awk 'NR==3' | tr -d ' ')

    if [[ "$RESULT" == "(0rows)" ]]; then
      echo "$NOT_FOUND"
    else
      # Display information about the element
      display_element_info "$RESULT"
    fi
    ;;
  *[a-zA-Z]*)
    # Block for alphabetical input
    if [[ $1 =~ ^[a-zA-Z]+$ ]]; then
      TABLE_ELEMENTS_AND_PROPERTIES=$($PSQL -c "SELECT * FROM properties AS p JOIN elements AS e ON p.atomic_number = e.atomic_number JOIN types AS t ON t.type_id = p.type_id WHERE e.name = '$1';")
      RESULT=$(echo "$TABLE_ELEMENTS_AND_PROPERTIES" | awk 'NR==3' | tr -d ' ')

      if [[ "$RESULT" == "(0rows)" ]]; then
        echo "$NOT_FOUND"
      else
        # Display information about the element
        display_element_info "$RESULT"
      fi
    else
      echo "$EXIT_TEXT"
    fi
    ;;
  *)
    echo "$EXIT_TEXT"
    ;;
esac
