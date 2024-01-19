#!/bin/env bash

# PostgreSQL connection parameters
DB_NAME="periodic_table"
DB_USER="freecodecamp"


PSQL="psql -d $DB_NAME -U $DB_USER"

case $1 in
  ''|*[0-9]*)
    TABLE_OUTPUT=$($PSQL -c "SELECT * FROM properties WHERE atomic_mass = $1");
		echo $TABLE_OUTPUT;
    ;;
	*)
		echo "Please provide an element as an argument.";
		;;
esac
