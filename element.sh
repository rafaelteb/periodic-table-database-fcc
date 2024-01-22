#!/bin/env bash
shopt -s extglob
# PostgreSQL connection parameters
DB_NAME="periodic_table"
DB_USER="freecodecamp"
PSQL="psql -d $DB_NAME -U $DB_USER"

# Wrong input warning
EXIT_TEXT="Please provide an element as an argument.";

case $1 in
  [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
		# This block will be executed if $1 is least a one and maximally a 3 digid number
    TABLE_PROPERTIES=$($PSQL -c "SELECT * FROM properties WHERE atomic_number = $1");
		TABLE_ELEMENTS=$($PSQL -c "SELECT * FROM elements WHERE atomic_number = $1");
		ATOMIC_NUMBER=$1;
		TYPE=$(echo $TABLE_PROPERTIES | cut -d '|' -f 7 | tr -d ' ');
		SYMBOL=$(echo $TABLE_ELEMENTS | cut -d '|' -f 4 | tr -d ' ');
		NAME=$(echo $TABLE_ELEMENTS | cut -d '|' -f 5 | cut -d ' ' -f 2 | tr -d ' ');
		ATOMCIC_MASS=$(echo $TABLE_PROPERTIES | cut -d '|' -f 8 | tr -d ' ');
		MELTING_POINT_CELSIUS=$(echo $TABLE_PROPERTIES | cut -d '|' -f 9 | tr -d ' ');
		BOILING_POINT_CELSIUS=$(echo $TABLE_PROPERTIES | cut -d '|' -f 10 | tr -d ' ');
		echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMCIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius.";
		echo "ok1";
    ;;
	[A-Za-z]|[A-Za-z][A-Za-z])
		# This block will be executed if $1 contains at least one and maximally two alphabetic letters
		TABLE_ELEMENTS_AND_PROPERTIES=$($PSQL -c "SELECT * FROM properties AS p JOIN elements AS e ON p.atomic_number = e.atomic_number WHERE e.symbol = '$1';");
		RESULT=$(echo "$TABLE_ELEMENTS_AND_PROPERTIES" | awk 'NR==3' | tr -d ' ');
		ATOMIC_NUMBER=$(echo $RESULT | cut -d '|' -f 1);
		TYPE=$(echo $RESULT | cut -d '|' -f 2);
		SYMBOL=$1;
		NAME=$(echo $RESULT | cut -d '|' -f 9);
		ATOMCIC_MASS=$(echo $RESULT | cut -d '|' -f 3);
		MELTING_POINT_CELSIUS=$(echo $RESULT | cut -d '|' -f 4);
		BOILING_POINT_CELSIUS=$(echo $RESULT | cut -d '|' -f 5);
		echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMCIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius.";
		echo "ok2";
		;;
	*[a-zA-Z]*)
    # This block will be executed if $1 contains at least one alphabetical character
    if [[ $1 =~ ^[a-zA-Z]+$ ]]; then
			# This makes sure that $1 is a word without any numbers
      TABLE_ELEMENTS_AND_PROPERTIES=$($PSQL -c "SELECT * FROM properties AS p JOIN elements AS e ON p.atomic_number = e.atomic_number WHERE e.name = '$1';");
			RESULT=$(echo "$TABLE_ELEMENTS_AND_PROPERTIES" | awk 'NR==3' | tr -d ' ');
			ATOMIC_NUMBER=$(echo $RESULT | cut -d '|' -f 1);
			TYPE=$(echo $RESULT | cut -d '|' -f 2);
			SYMBOL=$1;
			NAME=$(echo $RESULT | cut -d '|' -f 9);
			ATOMCIC_MASS=$(echo $RESULT | cut -d '|' -f 3);
			MELTING_POINT_CELSIUS=$(echo $RESULT | cut -d '|' -f 4);
			BOILING_POINT_CELSIUS=$(echo $RESULT | cut -d '|' -f 5);
			echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMCIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius.";
    else
      echo $EXIT_TEXT;
    fi
		;;
	*)
		echo $EXIT_TEXT;
		;;
esac
