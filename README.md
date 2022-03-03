Steps for merging and splitting PA voter files - oriented to the state sentate based
files from the Philly City Commissioners.

These steps must be run in a terminal. All the steps highlighted as code can be pasted as-is
except for setting the date.


You need to make sure you have a reasonable version of php (> 7.0) and sqlite3 (> 3.9.0) in your path.
If you are not sure, try this:

```
php --version
sqlite3 --version
```

First, define the DATE variable in the terminal. This should be the only step where you
have to change the command.

```
# Use the correct date for the voter files here. For example, if the file
# names are like PA Voter Export SS1 (3-1-22).TXT then the iso8601 date is
# 2022-03-01 
DATE=2022-03-01
```

Convert tab-delimited voter text files from the city to CSV.

```
for DIST in 1 2 3 4 5 7 8; do cat "PA Voter Export SS$DIST "*.TXT | ./tab-to-csv.php > $DATE-PA-Voter-Export-SS$DIST.csv; done
```

Import all the csv files into a sqlite3 database.

```
DB="sqlite3 $DATE-PA-Voter-Export.sqlite3"
for FILE in *.csv; do echo ".mode csv
.head on
.import $FILE voter_list" | $DB; done
```

Ideally there should be no error messages in the import step.  If you see some like
this, there may be bad data in some rows:

2022-03-01-PA-Voter-Export-SS1.csv:69081: expected 127 columns but found 126 - filling the rest with NULL
2022-03-01-PA-Voter-Export-SS7.csv:112520: unescaped " character


Clean out the duplicate header rows. The steps here work for older sqlite binaries.
The newer versions also have --csv and --skip options for .import per:
https://sqlite.org/cli.html#csv

```
echo "DELETE FROM voter_list WHERE ID_Number = 'ID_Number' AND First_Name = 'First_Name'" | $DB
```

Finally, generate the split up ward files:

```
./wards.sh $DATE
```

Check the content of the wards directory.
