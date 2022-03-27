import io
import socket
import picamera
import struct

client_socket = socket.socket()
IP = '206.87.239.128'
port = 8000
client_socket.connect((IP, port))

# write to buffer and make a file out of it
connection = client_socket.makefile('wb')
try:
    camera = picamera.PiCamera()
    camera.resolution = (500, 480)

    camera.start_preview()

    stream = io.BytesIO()
    for cap in camera.capture_continuous(stream, 'jpeg'):
        # write the stream to the connection and flush to send it out
        connection.write(struct.pack('<L', stream.tell()))
        connection.flush()
        # Go to the begining of the stream and and send it over the connection
        stream.seek(0)
        connection.write(stream.read())
        # Reset stream for next capture
        stream.seek(0)
        stream.truncate()
    # Send 0 to signal end of communication
    connection.write(struct.pack('<L', 0))
finally:
    connection.close()
    client_socket.close()

