from socket import *
import time
import numpy

height = 8
width = 8

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

    return numpy.array(values, dtype=numpy.uint32).reshape((height, width))

# define server port number
serverName = "0.0.0.0"
serverPort = 12000

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

    arr = create_2d_array()

    print(arr)

    # send data to client
    clientSocket.send(arr.tobytes())

    # receive data from client
    msg = clientSocket.recv(1024)

    # decode data
    result = numpy.frombuffer(msg, dtype=numpy.uint32).reshape((height, width))

    print(result)

    time.sleep(1)

clientSocket.close()
