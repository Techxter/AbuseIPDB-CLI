#!/bin/bash

#AbuseIPDB-CLI by Techxter, written from scratch for APIv2 but inspired by AbuseIPDB Tools by GethPrime for (now defunct) APIv1.
#Get your API Key at www.abuseipdb.com/account/api and paste it below, replacing <<YOUR_API_KEY>>.
#This script requires 'jq' and 'curl'

API_KEY="<<YOUR_API_KEY>>"
IP="$1"

if [ $# -eq 0 ]; then
	printf "\nUsage: iplookup.sh <IP> / Example: iplookup.sh 127.0.0.1\nWarning: Be sure to edit this file and provide your API key!\n\n"
	exit 1
else
	PULL_JSON=$(curl -G https://api.abuseipdb.com/api/v2/check \
  	--data-urlencode "ipAddress=$IP" \
  	-d maxAgeInDays=90 \
  	-d verbose \
  	-H "Key: $API_KEY" \
  	-H "Accept: application/json" 2>/dev/null | jq .)
  	ERROR_STATE=$(echo $PULL_JSON | jq -r '.errors[0].status')
  	COUNTRY=$(echo $PULL_JSON | jq -r '.data.countryName')
  	DOMAIN=$(echo $PULL_JSON | jq -r '.data.domain')
  	ISP=$(echo $PULL_JSON | jq -r '.data.isp')
  	SAFE=$(echo $PULL_JSON | jq -r '.data.isWhitelisted')
  	ABUSE_SCORE=$(echo $PULL_JSON | jq -r '.data.abuseConfidenceScore')
  	LAST_UPDATE=$(echo $PULL_JSON | jq -r '.data.lastReportedAt')
  	LAST_DATE=$(date -u -d $(sed 's/^\([[:digit:]]\{2\}\)\/\([[:digit:]]\{2\}\)\/\([[:digit:]]\{4\}\)\ /\3-\1-\2T/' <<<$LAST_UPDATE) '+%c' 2>/dev/null)
  	LAST_COMMENT=$(echo $PULL_JSON | jq -r '.data.reports[0].comment')
  	if [ "$PULL_JSON" = "" ] ; then
  		printf "\nAbuseIPDB Connection Error.\nTry again later and make sure you are online.\n\n"
  	else
  		if [ "$ERROR_STATE" = "401" ] ; then
  			printf "\nAbuseIPDB Authentication Failed.\nThis script is either missing your API key (edit it!) or your key is incorrect.\n\n"
  		else
  			if [ "$ERROR_STATE" = "429" ] ; then
  				printf "\nAbuseIPDB Error.\nDaily rate limit of requests exceeded for this endpoint.\n\n"
  			else	
  				printf "\nIP Lookup Details:\n----------------\nIP: $IP\nDomain: $DOMAIN\nCountry: $COUNTRY\nISP: $ISP\n"
  				if [ "$SAFE" = false ] ; then
    				if [ "$LAST_COMMENT" = null ] ; then
  						printf "\nThis IP appears suspicious. Threat Score is $ABUSE_SCORE\x25\n"
  						printf "No additional details found...\n----------------\n\n"
  					else
  						printf "\nThis IP appears malicious. Threat Score is $ABUSE_SCORE\x25\n"
  						printf "\nLast reported: $LAST_DATE\nWith comment: \"$LAST_COMMENT\"\n----------------\n\n"
  					fi
  				else  
   					printf "\nThis IP appears benign.\n----------------\n\n"
  				fi
  			fi	
  		fi
  	fi
fi
