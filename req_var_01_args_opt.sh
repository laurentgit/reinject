#!/bin/bash


 # Init variables
requete=''
out=''
out2=''
final=''
serveur=$1
table=$3
schema=$2
sql1="SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name like '"
sql2="%' and table_schema='"
sql3="';"
reqtt=$sql1$table$sql2$schema$sql3


checkto()
{
       # Check the args
        if [ "$1" == "--help" ] || [ "$1" == "-h" ] ;
        then
                Help
                exit 0
        elif [ "$#" -ne 4 ];
        then
                echo "Check your arguments number..."
                Help
                exit 1
        fi
}
request()
{
        ## $dbsever et schema needed
	requete=$(psql service=ax_tool_$serveur -tc "$reqtt")
}
pre_format(){
	out=$requete
	out=`echo $out | tr ' ' ','`
}

filter_it(){
out2=$out
out2=${out2/,telecollecte,/,NULL,}
out2=${out2/,datetimetelecollecte,/,NULL,}
out2=${out2/,numremise,/,NULL,}
out2=${out2/,numfichier,/,NULL,}
out2=${out2/,datetimesettlement,/,NULL,}
out2=${out2/,settlementid,/,NULL,}
out2=${out2/,remittanceid,/,NULL,}
out2=${out2/,flaglot,/,0,}
}

display_result(){
# add table_ids, schema
ids=$(sed "s/^support.//" <<< $3)
final="INSERT INTO "$1"."$2" ("$out") SELECT "$out2" FROM support."$ids";"
echo $final
}

Help(){
   # Display Help
   clear
   echo
   echo "A tool to prepare injection command for reinjection Worldline."
   echo
   echo "Syntax: $(basename "$0") [DB_server] [schema_name] [table_target] [table_ids]"
   echo
   echo "   Ex : $(basename "$0") axisww11 ame mvtame ops24711"
   echo
   echo
   echo "options:"
   echo "       -h        Print this Help."
   echo "       -help     Print this Help."
   echo
}

###########################################################
#########                  MAIN                   #########
###########################################################

checkto "$@"
request "$1" "$2"
pre_format
filter_it
display_result "$2" "$3" "$4"
