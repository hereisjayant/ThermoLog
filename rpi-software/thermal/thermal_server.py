from socket import *
import numpy as np
import time
import busio
import board
import adafruit_amg88xx

i2c = busio.I2C(board.SCL, board.SDA)
amg = adafruit_amg88xx.AMG88XX(i2c)

height = 8
width = 8

"""
# Just a test function for creating 2d arr
def create_2d_array():

    values = [
        50, 0, 50, 50, 0, 50, 50, 50, 
        50, 50, 0, 50, 50, 0, 50, 50, 
        50, 50, 50, 0, 50, 50, 0, 50, 
        50, 0, 50, 50, 0, 50, 50, 50, 
        50, 50, 0, 50, 50, 0, 50, 50, 
        50, 50, 50, 0, 50, 50, 0, 50, 
        50, 0, 50, 50, 0, 50, 50, 50, 
        50, 50, 0, 50, 50, 0, 50, 50
    ]

    return np.array(values, dtype=np.uint32).reshape((height, width))
"""

# define server port number
serverName = "169.254.248.30"
serverPort = 12001

# create TCP socket
serverSocket = socket(AF_INET, SOCK_STREAM)

# associate the server port number with this socket
serverSocket.bind((serverName, serverPort))

# listen for TCP connections requests
serverSocket.listen(1)

# print host name
print("The server is ready to receive at: " + gethostname())

# accept incoming connection
clientSocket, addr = serverSocket.accept()

print("Connection from: " + str(addr))

while True:

    # arr = amg.pixels
    arr = np.array(amg.pixels, dtype=np.uint32).reshape((height, width))
    print(arr)

    # send data to client
    clientSocket.send(arr.tobytes())

    # receive data from client
    msg = clientSocket.recv(1024)

    # decode data
    result = np.frombuffer(msg, dtype=np.uint32).reshape((height, width))

    print(result)

    time.sleep(1)

clientSocket.close()
