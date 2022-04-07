import RPi.GPIO as GPIO

import time

# mongoDB
import urllib
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from bson.objectid import ObjectId


client = MongoClient("mongodb+srv://Team-35:" + urllib.parse.quote_plus("asd()32q441%D") + "@themallog0.hekpn.mongodb.net/ThermalLogDB?retryWrites=true&w=majority", server_api=ServerApi('1'))

storeDb = client.prod.stores

storeId = ObjectId("62302f5ec6d5bc2cd7826ed1") 

ir_sensor_1 = 36
ir_sensor_2 = 37

GPIO.setmode(GPIO.BOARD)

GPIO.setwarnings(False)

GPIO.setup(ir_sensor_1,GPIO.IN)
GPIO.setup(ir_sensor_2,GPIO.IN)

num_people = 0

while(1):

        state_sensor_1 = GPIO.input(ir_sensor_1)
        state_sensor_2 = GPIO.input(ir_sensor_2)

        if state_sensor_1==False:
            print("Person Entered")
            num_people+=1
            storeDb.update_one({"_id": storeId}, {"$inc": { "customerCount": 1 }})
            print("Num of people: ", num_people)
            time.sleep(1)
 
        elif state_sensor_2==False:
            print("Person Exited")
            if num_people > 0:
                num_people-=1
            storeDb.update_one({"_id": storeId}, {"$inc": { "customerCount": -1 }})
            print("Num of people: ", num_people)
            time.sleep(1)
