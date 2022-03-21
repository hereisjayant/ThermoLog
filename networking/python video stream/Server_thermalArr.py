import socket
import pickle

# Just a test function for creating 2d arr
def create_2d_array(i):
    rows, cols = (8, 8)
    arr = [[i]*cols]*rows
    return arr

# server socket
s = socket.socket()
s.bind((socket.gethostname(), 1234))
# max num of client that can connect
s.listen(5)

while True:
    clientsocket, addr = s.accept()
    print(f"Connection from {addr} has been established!")
    i = 0 # just a counter for testing
    # this will be an inf loop in our case
    while i < 1000:
        i+=1
        arr = create_2d_array(i)
        # this is how you convert python obj to pickle obj. to send over the socket
        pickled_arr = pickle.dumps(arr) # this takes care of byte conversion too!
        clientsocket.send(pickled_arr)

        # receive the negated array from the client
        msg = clientsocket.recv(1024)
        negative_arr = pickle.loads(msg)
        print(negative_arr)
        
    clientsocket.close()


