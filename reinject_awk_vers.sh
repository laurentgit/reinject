#!/bin/bash

 # Init variables
requete=''
out=''
out2=''
final=''


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
        requete_cli=''
        requete_cli="psql service=ax_tool_$1 -c \"SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name like 'mvt%' and table_schema='$2';\""
        #requete=$($requete_cli)
        #echo $requete_cli
        requete=$(cat ./requests/requete.txt)
}



display_result(){
# add table_ids, schema
ids=$(sed "s/^support.//" <<< $3)
final="INSERT INTO "$1"."$2" ("$requete") SELECT "$requete_2" FROM support."$ids";"
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

awk_treat()
{
#echo $requete | awk -F " " '{champs=NF; print $champs" ;\nNombre de champs"NF} END{ print "\nNombre de champs :"NF}' 
# retirer les deux premiers champs $1 $2
requete=$(echo $requete | awk '{gsub("column_name ------------------------- ","",$0);print$0}')
# enlever (172 rows) "les deux derniers champs" $NF $NF-1
requete=$(echo $requete | awk -F " " '{NF=NF-2; print $0}')
# remplacer les espaces par une virgule
requete=$(echo $requete | awk '{gsub(" ",",",$0);print$0}')
#echo $requete
# 
}

awk_filter()
{
# Filter ,telecollecte,/,NULL,
requete_2=$(echo $requete | awk '{gsub(",telecollecte,",",NULL,",$0);print$0}')
# Filter ,datetimetelecollecte,/,NULL,
requete_2=$(echo $requete_2 | awk '{gsub(",datetimetelecollecte,",",NULL,",$0);print$0}')
#out2=${out2/,numremise,/,NULL,}
requete_2=$(echo $requete_2 | awk '{gsub(",numremise,",",NULL,",$0);print$0}')
#out2=${out2/,numfichier,/,NULL,}
requete_2=$(echo $requete_2 | awk '{gsub(",numfichier,",",NULL,",$0);print$0}')
#out2=${out2/,datetimesettlement,/,NULL,}
requete_2=$(echo $requete_2 | awk '{gsub(",datetimesettlement,",",NULL,",$0);print$0}')
#out2=${out2/,settlementid,/,NULL,}
requete_2=$(echo $requete_2 | awk '{gsub(",settlementid,",",NULL,",$0);print$0}')
#out2=${out2/,remittanceid,/,NULL,}
requete_2=$(echo $requete_2 | awk '{gsub(",remittanceid,",",NULL,",$0);print$0}')
#out2=${out2/,flaglot,/,0,}
requete_2=$(echo $requete_2 | awk '{gsub(",flaglot,",",0,",$0);print$0}')
}





###########################################################
#########                                              MAIN                                             ######### 
###########################################################

checkto "$@"
request "$1" "$2"
awk_treat 
awk_filter 
display_result "$2" "$3" "$4"









