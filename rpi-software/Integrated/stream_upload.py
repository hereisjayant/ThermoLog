import cv2
import face_recognition
import time
from flask import Flask, render_template, Response


video = cv2.VideoCapture(0)
app = Flask('__name__')

def video_stream():
    while True:
        ret, frame = video.read()

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
                cv2.rectangle(frame, (left, top), (right, bottom),
                    (0, 255, 0), 3)
            
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
