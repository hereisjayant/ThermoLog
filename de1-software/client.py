import ctypes
from socket import *
import numpy as np

height = 8
width = 8

# open hardware accelerator shared object
so_file = "./accelerator.so"
accelerator = ctypes.cdll.LoadLibrary(so_file)

# define accelerator function
compute_pixel = accelerator.compute_pixel
compute_pixel.restype = ctypes.c_int
compute_pixel.argtypes = [
    ctypes.c_int, 
    ctypes.c_int, 
    ctypes.c_int, 
    ctypes.c_int, 
    ctypes.c_int, 
    ctypes.c_int, 
    ctypes.c_int, 
    ctypes.c_int, 
    ctypes.c_int
]

def denoise(arr):

    # create array to store result
    result = np.zeros((height, width), dtype=np.uint32)

    # initialize hardware accelerator
    accelerator.init_hw()

    # scan through image to apply the accelerator
    for i in range(height):
        for j in range(width):

            curr_row = i
            if i - 1 < 0: prev_row = i
            else: prev_row = i - 1
            if i + 1 >= height: next_row = i
            else: next_row = i + 1

            curr_col = j
            if j - 1 < 0: prev_col = j
            else: prev_col = j - 1
            if j + 1 >= height: next_col = j
            else: next_col = j + 1

            result[i][j] = compute_pixel(
                arr[prev_row][prev_col],
                arr[prev_row][curr_col],
                arr[prev_row][next_col],
                arr[curr_row][prev_col],
                arr[curr_row][curr_col],
                arr[curr_row][next_col],
                arr[next_row][prev_col],
                arr[next_row][curr_col],
                arr[next_row][next_col]
            )

    # release hardware accelerator
    accelerator.close_hw()

    return result

def main():

    # define server port number
    serverName = "192.168.0.10"
    serverPort = 12000

    # creates client TCP socket
    clientSocket = socket(AF_INET, SOCK_STREAM)

    # establish TCP connection with server
    clientSocket.connect((serverName,serverPort))

    print("Client socket connected to server at " + serverName)

    while True:

        # recieve bytes from server 
        msg = clientSocket.recv(1024)

        print("Received data from server")

        # decode data
        arr = np.frombuffer(msg, dtype=np.uint32).reshape((height, width))

        print("Decoded data from server")

        # process data
        result = denoise(arr)

        print("Processed data with hardware accelerator")

        # send data to server
        clientSocket.send(result.tostring())

        print("Result sent to server succesfully")

    clientSocket.close()

if __name__ == "__main__":
    main()
