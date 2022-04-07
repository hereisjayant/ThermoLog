import cv2
import face_recognition
import time
from flask import Flask, render_template, Response
# for the temprature
import numpy as np
import busio
import board
import adafruit_amg88xx

threshold_temp = 25
video = cv2.VideoCapture(0)
i2c = busio.I2C(board.SCL, board.SDA)
amg = adafruit_amg88xx.AMG88XX(i2c)
app = Flask('__name__')

def video_stream():
    while True:
        ret, frame = video.read()
        
        thermal_arr = amg.pixels
        # TODO: if needed, Lower the frame width to increase processing speed
        # frame = vs.read()
        # frame = imutils.resize(frame, width=300)

        if not ret:
            break
        else:
            boxes = face_recognition.face_locations(frame)

            # loop over the recognized faces
            for (top, right, bottom, left) in boxes:
                # draw the predicted face name on the image - color is in BGR
                color = (0, 255, 0)
                # these are the coordinates for thermal cam corresponding to the face:
                thermal_top = round(top/63)
                thermal_right = round(right/63)
                thermal_bottom = round(bottom/63)
                thermal_left = round(left/63)
                thermal_slice = [thermal_arr[i][thermal_left:thermal_right] for i in range(thermal_top,thermal_bottom)]
                # num of row and cols in the slice
                thermal_slice_rows = len(thermal_slice)
                thermal_slice_cols = len(thermal_slice[0])
                sum_of_thermal = sum(sum(thermal_slice,[]))
                # Avg temp of the face
                avg_temp = sum_of_thermal/(thermal_slice_rows*thermal_slice_cols)
                
                # Send out an alert if the temp is higher than required
                if avg_temp > threshold_temp:
                    temp_alert()
                    color = (255, 0, 0)
                    
                # print the temp out
                cv2.putText(frame, str(int(avg_temp))+" C", (left, bottom + 20), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)
                # create boxes around faces
                cv2.rectangle(frame, (left, top), (right, bottom), color, 3)

                
                cv2.rectangle(frame, (left, top), (right, bottom),
                    color, 3)
                
            
            _, buffer = cv2.imencode('.jpeg',frame)
            frame = buffer.tobytes()
            yield (b' --frame\r\n' b'Content-type: imgae/jpeg\r\n\r\n' + frame +b'\r\n')       



@app.route('/camera')
def camera():
    return render_template('camera.html')


@app.route('/video_feed')
def video_feed():
    return Response(video_stream(), mimetype='multipart/x-mixed-replace; boundary=frame')


app.run(host='0.0.0.0', port='5000', debug=False)
