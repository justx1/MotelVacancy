#!/bin/sh

# Run from command line: ./m6.sh
# Enable cron: edit /etc/crontab

PROP1="276"                     #Mammoth Lakes, CA
#PROP1="4527"                   #New Orleans
#PROP1="4044"                   #Los Angeles

#DateFormat: MM/DD/YYYY where / is replaced with %2F
#DAT[0]="2%2F18%2F2012"
#DAT[1]="2%2F19%2F2012"
#DAT[2]="2%2F20%2F2012"
#DAT[3]="2%2F21%2F2012"
#DAT[4]="2%2F22%2F2012"
DAT[0]="08%2F31%2F2013"
DAT[1]="09%2F01%2F2013"

COOKIE="m6.cookie"
LOOKUPPOS="This location has no rooms available for the selected dates."
OUTPUT=""

initialize ()
{
        #echo Initializing...
        URL1="http://www.motel6.com/ms/check-availability.do?property="$PROP"&arrivalDateStr="$DATIN"&departureDateStr="$DATOUT"numberOfAdults=2"
        #echo $URL1
        curl -s -o m6tmp.html --cookie $COOKIE --cookie-jar $COOKIE $URL1
}

checkavail ()
{
        URL2="http://www.motel6.com/ms/check-availability-post.do?arrivalDateStr="$DATIN"&departureDateStr="$DATOUT"&numberOfAdults=2"
        #echo $URL2
        curl -s -o m6res.html --cookie $COOKIE --cookie-jar $COOKIE $URL2 

        if grep -q "$LOOKUPPOS" m6res.html
        then
                #echo $PROP : $DATIN - $DATOUT NO AVAILABILITY
                OUTPUT="${OUTPUT}X"
        else
                #echo $PROP : $DATIN - $DATOUT Dont\'t know
                OUTPUT="${OUTPUT}O"
        fi
}

loop ()
{
        for i in 0 #1 2 3   <== Note adjust this according to duration of stay
        do
                DATIN=${DAT[i]}
                DATOUT=${DAT[i+1]}
                checkavail  $PROP $DATIN $DATOUT
        done
}

#echo M6 Checker
#echo Starting...

PROP=$PROP1
initialize  $PROP ${DAT[0]} ${DAT[1]}
loop

echo $URL1 $URL2 | mail -s "M6 NO $OUTPUT $(date +%Y\-%m\-%d\ %H\:%M\.%S)" gwiesinger@gmail.com