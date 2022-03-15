# import io
import socket
import struct
# import time

image = "swallow.jpg"

client_socket = socket.socket()

client_socket.connect(('206.87.235.152', 8000))  # ADD IP HERE

# Make a file-like object out of the connection
connection = client_socket.makefile('wb')
try:

    # open local image 
    myfile = open(image, 'rb')
    bytes = myfile.read()
    size = len(bytes)


    # Write the length of the capture to the stream and flush to
    # ensure it actually gets sent
    connection.write(struct.pack('<L', size))
    connection.flush()
    connection.write(bytes)
    # Write a length of zero to the stream to signal we're done
    connection.write(struct.pack('<L', 0))
finally:
    connection.close()
    client_socket.close()
