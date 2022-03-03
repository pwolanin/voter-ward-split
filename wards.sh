#!/bin/bash

mkdir -p wards
DATE="$1"
if [ -z "$DATE" ]; then
  echo "Voter file date like 2022-01-31 must be an argument to the script"
  exit 1
fi

DB="sqlite3 $DATE-PA-Voter-Export.sqlite3"

SETUP=".mode csv
.head on
"

# Normally ward is in the Dist2 field and formatted like 'WD01' or 'WD18'

for WARD in $(echo "select DISTINCT Dist2 from voter_list WHERE Dist2 LIKE 'WD%' ORDER BY Dist2;" | $DB); do
  for PARTY in D R; do
    FILE=".once wards/$DATE-$WARD-$PARTY.csv
"
    SQL="SELECT ID_Number,Title,Last_Name,First_Name,Middle_Name,Suffix,Sex,Date_Of_Birth,Date_Registered,Voter_Status,StatusChangeDate,Political_Party,House__,HouseNoSuffix,StreetNameComplete,Apt__,Address_Line_2,City,State,Zip_Code,Dist1 AS Division,Dist2 as Ward FROM voter_list WHERE Dist2='$WARD' AND Political_Party = '$PARTY' ORDER BY Division, StreetNameComplete, CAST(House__ AS INTEGER);"
    echo "$SETUP$FILE$SQL" | $DB
  done
done
