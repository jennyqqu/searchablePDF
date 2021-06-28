



from google.oauth2 import service_account

import io

from google.cloud import vision_v1
from google.cloud.vision_v1 import AnnotateImageResponse
import json

import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('jpeg_dir', help='GCV JSON file directory, "-" for STDIN')
    parser.add_argument(
        "--json_dir",
        help="auth_file_loc"
    )
    parser.add_argument(
        "--auth_file_loc",
        help="auth_file_loc"
    )
    

    args = parser.parse_args()

    #print(args.auth_file_loc)
    credentials = service_account.Credentials.from_service_account_file(args.auth_file_loc)
   

  
    with io.open(args.jpeg_dir,'rb') as image_file:
        content = image_file.read()

    image = vision_v1.Image(content=content)
    client = vision_v1.ImageAnnotatorClient(credentials=credentials)
    response2 = client.document_text_detection(image=image)


    response_json = AnnotateImageResponse.to_json(response2)
    response = json.loads(response_json)
    #print(1)
    #print(args.json_dir)
   
    with open(args.json_dir,'w') as outfile:
        json.dump(response, outfile)





