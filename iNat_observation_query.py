#!/usr/bin/env python3

# This script searches for all observations of a given taxon by a given user on iNaturalist.
# Proper execution requires some prior knowledge about a taxon ID number.
# A future script will determine taxon ID numbers for the user given a common name or a scientific name.

import urllib.request, urllib.parse, urllib.error
import json

serviceurl = 'https://api.inaturalist.org/v1/observations'

while True:
    taxon_of_interest = input('Enter a taxon ID number (ex. 72327): ')
    if len(taxon_of_interest) < 1: break
    user_of_interest = input('Enter a user ID (ex. alex_abair): ')
    if len(user_of_interest) < 1: break    
    
    url = serviceurl + "?" + urllib.parse.urlencode({'taxon_id': taxon_of_interest}) + "&" + urllib.parse.urlencode({'user_id': user_of_interest}) + "&order=desc&order_by=created_at"
        
    print('Retrieving', url)
    uh = urllib.request.urlopen(url)
    data = uh.read().decode()
    print('Retrieved', len(data), 'characters')
    


    try:
        js = json.loads(data)
    except:
        js = None

    for observation in js["results"]:
        print(user_of_interest + " observed " + observation["taxon"]["name"] + " at " + observation["location"] + " on " + observation["observed_on_details"]["date"] + ".")


