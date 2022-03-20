import ctypes
from numpy.ctypeslib import ndpointer
from PIL import Image
import numpy
import time

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

# initialize hardware accelerator memory mapping
accelerator.init_hw();

# time program run time
start_time = time.time()

###################################################################

width = 8
height = 8

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

arr = numpy.array(values, dtype=numpy.int32).reshape((height, width))
result = numpy.zeros((height, width), dtype=numpy.uint32)

print(arr)

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

print(result)

###################################################################

# print timing
print("--- Done in %s seconds ---" % (time.time() - start_time))

# release hardware accelerator memory mapping
accelerator.close_hw();
