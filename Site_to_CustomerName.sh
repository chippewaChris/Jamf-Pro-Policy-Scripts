#!/bin/zsh
###############################################################################
#                                                                             
# -                                       
#                                                                             
# Copyright (C) Thursday, March 2, 2023, Chippewa Limited Liability Co.                                       
#                                                                             
# This script is the property of Chippewa Limited Liability Co. and is intended for internal     
# use only. This script may not be distributed, reproduced, or used in any    
# manner without the expressed written consent of Chippewa Limited Liability Co..                
#                                                                             
# This script is provided "AS IS" and WITHOUT WARRANTY OF ANY KIND,           
# EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED     
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.         
#                                                                             
# Permission is granted to Parachute inc. to utilize this script    
# for the purpose of updating an extension attribute en massse on thier small 
# client server.  This is for the purpose of viewing the customer with which 
# the computer is associated to - which is helpful when examining computer 
# from multiple instances together.  
#                                                                             
###############################################################################

username="Insert username" #example: Admin
password="Insert password" #example: jamf1234
url="https://jamf.pro.url" #example: https://acme.jamfcloud.com
SiteValue="INSERT ID of Site you're targeting" #Update for the ID of the site we're targeting to update computers of #example: 1
eaID="" ##Update for the id of the Extension Attribute we're updating #example: 2
newValue="" ##The value we want to update the EA to. #example: Acme Computer Corp.

#cleanup from any previous iterations 
mv /tmp/foundIDs /tmp/foundIDs.old.$(date +%s)

#function for gathering Jamf Pro API Auth Token
getBearerToken() {
	response=$(curl -s -u "$username":"$password" "$url"/api/v1/auth/token -X POST)
	bearerToken=$(echo "$response" | plutil -extract token raw -)
}
#gather Token
getBearerToken

#function to pull all computer IDs from Jamf Pro Server
computerIDs () {
	# Send a GET request to retrieve the list of computers
	requestComputers=$(curl -s -X GET "$url/JSSResource/computers/subset/basic" -H "accept: application/json" -H "Authorization: Bearer $bearerToken")
	
	# Extract the IDs from the JSON response using jq and store them in an array
	ids=($(echo "$requestComputers" | jq -r '.computers[].id'))
}
#gather computer IDs
computerIDs

#function to check all computer ID's for membership in site specified on line 27, output them to a file located /tmp/foundIDs
checkSiteID () {
	# Send a GET request to retrieve the computer details
	requestComputer=$(curl -s -X GET "$url/JSSResource/computers/id/$1" -H "accept: application/json" -H "Authorization: Bearer $bearerToken")
	
	# Extract the site ID from the JSON response using jq
	siteID=$(echo "$requestComputer" | jq -r '.computer.general.site.id')
	# Check if the site ID matches the specified site ID
	if [ "$siteID" = "$2" ]; then
		echo $1 >> /tmp/foundIDs
	fi
}
#Check site membership
computerIDs

#Processing Stage
for id in "${ids[@]}"; do #For all the computer IDs in the /tmp/foundIDs file... Check them against the site... Put them in our file if matched
	checkSiteID $id $SiteValue
done

#Assign these computers to a site
echo "About to update this list of computer IDs who belong to the site with an ID of $SiteValue.  We'll be updating the extension attribute with an id of $eaID with a value of $newValue.  Please spot check a few of the computer IDs in the Jamf Pro server to ensure that these computers should be associated to $newValue"
echo "List of Computer IDs:"
echo $(cat /tmp/foundIDs)
echo ""
# Prompt the user for input and wait for a response
read -p "Would you like to continue? (y/n) " response #allow user to verify prior to performing action

# Check the user's response and continue or exit the script
if [[ "$response" =~ ^[yY]$ ]]; then
	echo "Continuing..."
	updateEA() {
		# Iterate through the list of computer IDs
		for id in "$(cat /tmp/foundIDs)"; do
			# Send a GET request to retrieve the current value of the extension attribute
			requestEA=$(curl -s -X GET "$url/JSSResource/computers/id/$id/subset/extension_attributes" -H "accept: application/json" -H "Authorization: Bearer $bearerToken")
			
			# Extract the value of the extension attribute from the JSON response using jq
			currentValue=$(echo "$requestEA" | jq -r --arg eaID "$eaID" '.computer.extension_attributes[] | select(.id == ($eaID|tonumber)) | .value')
				
				# Update the value of the extension attribute if it is not already set to the new value
				if [ "$currentValue" != "$newValue" ]; then
					# Create a new JSON payload with the updated value of the extension attribute
					payload="<computer><extension_attributes><extension_attribute><id>$eaID</id><value>$newValue</value></extension_attribute></extension_attributes></computer>"
					
					# Send a PUT request to update the extension attribute for the current computer ID
					response=$(curl -s -X PUT "$url/JSSResource/computers/id/$id" -H "accept: application/json" -H "Content-Type: application/xml" -H "Authorization: Bearer $bearerToken" -d "$payload")
					
					# Print the response from the API for debugging purposes
					#echo "$response"
				fi
			done
				}
				
				# Call the updateEA function to update the value of the extension attribute for the list of computer IDs
				updateEA
		
else
	echo "Exiting..."
	exit 1
fi

	