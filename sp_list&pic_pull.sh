import urllib.request, urllib.parse, urllib.error
import json
import requests #These are from an image dl tutorial
import shutil #  ^ https://towardsdatascience.com/how-to-download-an-image-using-python-38a75cfa21c

serviceurl = 'https://trefle.io/api/v1/species/search'
token = "wedpJpqOoRaU9_Hk-vqMBdqKSi0PmZGkROAw3k4bDf0"
end = "end"
while True:
    genus = input('Enter a genus (type "end" to exit): ')
    if len(genus) < 1: break
    if str(genus) in str(end): 
        print ("Goodbye")
        break
    image_query = input('Do you want any images? y/n')
    url=serviceurl+"?"+urllib.parse.urlencode(
        {"q":genus,"token":token})
    print (url)
    request = urllib.request.Request(url) #The assembled request
    response = urllib.request.urlopen(request)
    plant_list = response.read() # The data you need
    try:
        js = json.loads(plant_list)
    except:
        js = None    
    for plantid in js["data"]:
        if plantid["common_name"] == None:
            print(f"{plantid['scientific_name']} has no common name")
        else:
            print (f"{plantid['scientific_name']} , commonly known as {plantid['common_name']}")
    if image_query == "y":
        genus_img = input('Type the common/scientific name to obtain an image:')
        for plantimg in js["data"]:
            if plantimg["common_name"] == genus_img or plantimg["scientific_name"] == genus_img:
                try:
                    imageurl = str(plantimg["image_url"])
#                    imgname = input('image file name =')
                    new_image = imageurl.split("/")[-1]
                    if imageurl == "None":
                        print("No image found")
                    else:
                        # Notes from cite Opens url image, set stream to True-> returns content.
                        r = requests.get(imageurl, stream = True)
                        # Check if the image was retrieved successfully
                        if r.status_code == 200:
                            # Set decode_content value to True, otherwise the downloaded image file's size will be zero.
                            r.raw.decode_content = True
                            # Open a local file with wb ( write binary ) permission.
                            with open(new_image,'wb') as f:
                                shutil.copyfileobj(r.raw, f) 
                                print(f"Downloading an image of {genus_img} from {imageurl}")
                                print(f"Image sucessfully Downloaded, saved as: {new_image}.raw")
                        else:
                                    print('Image Couldn\'t be retreived')
                        
                    break
                except:
                    continue
