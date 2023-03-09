#!/bin/bash

############### MISE EN FORME 
A=''
psql service=ax_tool_axisww01 -c "SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name like 'mvt%' and table_schema='ssc';" > test2.txt
sed -i -e '{ 1,2d ; /^(/d ; /^$/d }' test2.txt 
sed -i -z 's/\n/,/g' test2.txt
sed -i 's/^ /INSERT INTO ssc.mvtemv (/' test2.txt && sed -i 's/,$/) SELECT /' test2.txt
A=$( grep -oP '(?<=\().*?(?=\))' test2.txt)
echo $A >> test2.txt 
sed -i 's/$/ FROM support.ops24567 /' test2.txt

############## CORRECTION
## sed -e 's/\(.*\)Joseph/\1Jérôme/' fichier-liste

sed -i 's/\(.*\)datetimetelecollecte/\1NULL/' test2.txt
sed -i 's/\(.*\) telecollecte/\1NULL/' test2.txt  # l'espace est important pour fonctionner sur le mot seul 
sed -i 's/\(.*\)numremise/\1NULL/' test2.txt
sed -i 's/\(.*\)numfichier/\1NULL/' test2.txt
sed -i 's/\(.*\)flaglot/\1'0'/' test2.txt
