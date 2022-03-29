from imutils.video import VideoStream
from imutils.video import FPS
import face_recognition
import imutils
import time
import cv2
# For thermal:
import numpy as np
import busio
import board
import adafruit_amg88xx

# thermal sensor init 
i2c = busio.I2C(board.SCL, board.SDA)
amg = adafruit_amg88xx.AMG88XX(i2c)
thermal_arr = amg.pixels


print("[INFO] loading face detector...")

# src = 0 : for the PiCam # change this to change the camera source
vs = VideoStream(src=0).start()
# start the FPS counter
fps = FPS().start()

# loop over frames from the video file stream
while True:
    # Lower the frame width to increase processing speed
    frame = vs.read()
    frame = imutils.resize(frame, width=500, height=500)
    # Detect the fce boxes
    boxes = face_recognition.face_locations(frame)

    # loop over the recognized faces
    for (top, right, bottom, left) in boxes:
        print(top, right,bottom,left)
        time.sleep(1)
        color = (0, 255, 0)
        # draw the predicted face name on the image - color is in BGR
        sum_of_thermal = sum(sum(thermal_arr,[]))
        cv2.putText(frame, sum_of_thermal/64, (left-50, bottom + 20), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)
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

