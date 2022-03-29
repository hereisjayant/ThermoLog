from imutils.video import VideoStream
from imutils.video import FPS
import face_recognition
import imutils
import time
from datetime import datetime
import cv2
# For thermal:
import numpy as np
import busio
import board
import adafruit_amg88xx
# mongoDB
import urllib
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from bson.objectid import ObjectId


client = MongoClient("mongodb+srv://Team-35:" + urllib.parse.quote_plus("asd()32q441%D") + "@themallog0.hekpn.mongodb.net/ThermalLogDB?retryWrites=true&w=majority", server_api=ServerApi('1'))

storeDb = client.prod.stores

storeId = ObjectId("62302f5ec6d5bc2cd7826ed1") 

def temp_alert():
    storeDb.update_one({ "_id": storeId }, { "$push": { "highTempTimes": datetime.now() } })

# thermal sensor init 
i2c = busio.I2C(board.SCL, board.SDA)
amg = adafruit_amg88xx.AMG88XX(i2c)
threshold_temp = 25


print("[INFO] loading face detector...")

# src = 0 : for the PiCam # change this to change the camera source
vs = VideoStream(src=0).start()
# start the FPS counter
fps = FPS().start()

# loop over frames from the video file stream
while True:
    thermal_arr = amg.pixels
    # Lower the frame width to increase processing speed
    frame = vs.read()
    frame = imutils.resize(frame, width=504, height=504)
    # Detect the fce boxes
    boxes = face_recognition.face_locations(frame)

    # loop over the recognized faces
    for (top, right, bottom, left) in boxes:
        time.sleep(1)
        color = (0, 255, 0)
        # draw the predicted face name on the image - color is in BGR
        
        # these are the coordinates for thermal cam:
        thermal_top = round(top/63)
        thermal_right = round(right/63)
        thermal_bottom = round(bottom/63)
        thermal_left = round(left/63)
        thermal_slice = [thermal_arr[i][thermal_left:thermal_right] for i in range(thermal_top,thermal_bottom)]
        thermal_slice_rows = len(thermal_slice)
        thermal_slice_cols = len(thermal_slice[0])
        sum_of_thermal = sum(sum(thermal_slice,[]))
        avg_temp = sum_of_thermal/(thermal_slice_rows*thermal_slice_cols)
        
        # Send out an alert if the temp is higher than required
        if avg_temp > threshold_temp:
            temp_alert()
            color = (255, 0, 0)
        # print the temp out
        cv2.putText(frame, str(int(avg_temp))+" C", (left, bottom + 20), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)
        # create boxes around faces
        cv2.rectangle(frame, (left, top), (right, bottom), color, 3)

    # display the camera feed to our screen
    cv2.imshow("Group 35 Thermal Mass Scanning", frame)
    #get the key input
    key = cv2.waitKey(1) & 0xFF
    # quit when q is pressed
    if key == ord("q"):
        break

    # update the FPS counter
    fps.update()

fps.stop()
print("[INFO] elasped time: {:.2f}".format(fps.elapsed()))
print("[INFO] approx. FPS: {:.2f}".format(fps.fps()))

# cleanup
cv2.destroyAllWindows()
vs.stop()

