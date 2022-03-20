import socket
import pickle
import time


s = socket.socket()
s.connect((socket.gethostname(), 1234))


while True:
    # this is the size of our buffer
    msg = s.recv(1024)
    arr = pickle.loads(msg)
    print(arr)

    # sleeps for 2.5 secs
    time.sleep(2.5)

    # processing the data (negating the array)
    negative_arr = [[-val for val in row] for row in arr]
    # pickling the data
    pickled_negative_arr = pickle.dumps(negative_arr)
    # sending it back to the server
    s.send(pickled_negative_arr)

