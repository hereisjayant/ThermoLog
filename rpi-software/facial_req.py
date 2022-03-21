from imutils.video import VideoStream
from imutils.video import FPS
import face_recognition
import imutils
import time
import cv2


print("[INFO] loading face detector...")

# src = 0 : for the PiCam # change this to change the camera source
vs = VideoStream(src=0,framerate=10).start()
# start the FPS counter
fps = FPS().start()

# loop over frames from the video file stream
while True:
	# Lower the frame width to increase processing speed
	frame = vs.read()
	frame = imutils.resize(frame, width=300)
	# Detect the fce boxes
	boxes = face_recognition.face_locations(frame)

	# loop over the recognized faces
	for (top, right, bottom, left) in boxes:
		# draw the predicted face name on the image - color is in BGR
		cv2.rectangle(frame, (left, top), (right, bottom),
			(0, 255, 0), 3)
		
	# display the camera feed to our screen
	cv2.imshow("Face Detection", frame)
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
