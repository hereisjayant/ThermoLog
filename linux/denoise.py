import ctypes
from PIL import Image
import numpy
import time

# time program run time
start_time = time.time()

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

# define image size
width = 640
height = 480
depth = 3

# read png to array
img = Image.open("noise.png")
arr = numpy.array(img.getdata())

# saved processed image to 3d array
result = numpy.zeros((height, width, depth), dtype=numpy.uint8)

for i in range(1, height - 1):
    curr_row = i * width
    prev_row = curr_row - width
    next_row = curr_row + width
    for j in range(1, width - 1):
        curr_col = j
        prev_col = j - 1
        next_col = j + 1
        for d in range(depth):
            result[i][j][d] = compute_pixel(
                    arr[prev_row + prev_col][d],
                    arr[prev_row + curr_col][d],
                    arr[prev_row + next_col][d],
                    arr[curr_row + prev_col][d],
                    arr[curr_row + curr_col][d],
                    arr[curr_row + next_col][d],
                    arr[next_row + prev_col][d],
                    arr[next_row + curr_col][d],
                    arr[next_row + next_col][d]
                )

# write processed image to png
result_img = Image.fromarray(result, "RGB")
result_img.save("result.png")

# print timing
print("--- Done in %s seconds ---" % (time.time() - start_time))

# release hardware accelerator memory mapping
accelerator.close_hw();
