#!/bin/sh

PROP1="10525"			#Los Angeles Downtown

DAT[0]="12%2F31%2F2011"
DAT[1]="01%2F01%2F2012"
#DAT[2]="2%2F20%2F2012"
#DAT[3]="2%2F21%2F2012"
#DAT[4]="2%2F22%2F2012"

#COOKIE="m6.cookie"
LOOKUPPOS="There are currently no rooms available at this property"
OUTPUT=""

#initialize ()
#{
#	#echo Initializing...
#	URL1="http://www.motel6.com/ms/check-availability.do?property="$PROP"&arrivalDateStr="$DATIN"&departureDateStr="$DATOUT"numberOfAdults=2"
#	#echo $URL1
#	curl -s -o m6tmp.html --cookie $COOKIE --cookie-jar $COOKIE $URL1
#}

checkavail ()
{
	URL2="http://www.super8.com/hotels/rooms-rates?hotel_id="$PROP"&checkout_date="$DATOUT"&brand_id=SE&children=0&teens=0&rate_code=SSP&adults=2&checkin_date="$DATIN"&rooms=1"
	#echo $URL2
	curl -s -o s8res.html $URL2 

	if grep -q "$LOOKUPPOS" s8res.html
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
	for i in 0					# 0 1 2 would be 3 nights
	do
	   	DATIN=${DAT[i]}
		DATOUT=${DAT[i+1]}
	   	checkavail  $PROP $DATIN $DATOUT
	done
}

#echo M6 Checker
#echo Starting...

PROP=$PROP1
#initialize  $PROP ${DAT[0]} ${DAT[1]}
loop

echo " " | mail -s "S8 $OUTPUT $(date +%Y\-%m\-%d\ %H\:%M\.%S)" gwiesinger@gmail.com
