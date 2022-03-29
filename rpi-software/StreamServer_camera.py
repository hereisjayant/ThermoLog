import io
import struct
import socket
from PIL import Image
import matplotlib.pyplot as pl

server_socket = socket.socket()
# make sure server and RPi are on the same subnet

IP = '206.87.239.128'
port = 8000
server_socket.bind((IP, port))
server_socket.listen(0)

print("Server started")

# Accept a single connection and make a file-like object out of it
connection = server_socket.accept()[0].makefile('rb')

try:
    img = None
    while True:
        # Read the length of the image as a 32-bit unsigned int
        img_raw = struct.unpack('<L', connection.read(struct.calcsize('<L')))[0]
        # if the img is empty
        if not img_raw:
            break
        # write data from the connection to image stream
        img_stream = io.BytesIO()
        img_stream.write(connection.read(img_raw))

        # go to beginning of the stream
        img_stream.seek(0)
        # open it as PIL obj
        image = Image.open(img_stream)

        # display the image using matplotlib
        if img is None:
            img = pl.imshow(image)
        else:
            img.set_data(image)

        pl.pause(0.01)
        pl.draw()

        print('Image is %dx%d' % image.size)
        image.verify()
        print('Image is verified')
finally:
    connection.close()
    server_socket.close()
