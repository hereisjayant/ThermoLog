from ctypes import *
from PIL import Image
import numpy

# open hardware accelerator shared object
so_file = "/home/root/Desktop/accelerator.so"
accelerator = CDLL(so_file)

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

# for i in range(1, height - 1):
#     for j in range(1, width - 1):
#         for d in range(depth):
#             result[i][j][d] = accelerator.compute_pixel(
#                                         arr[(i - 1) * width + j - 1][d],
#                                         arr[(i - 1) * width + j][d],
#                                         arr[(i - 1) * width + j + 1][d],
#                                         arr[i * width + j - 1][d],
#                                         arr[i * width + j][d],
#                                         arr[i * width + j + 1][d],
#                                         arr[(i + 1) * width + j - 1][d],
#                                         arr[(i + 1) * width + j][d],
#                                         arr[(i + 1) * width + j + 1][d]
#                                     )

# write processed image to png
result_img = Image.fromarray(result, "RGB")
result_img.save("result.png")

print("Done")

# release hardware accelerator memory mapping
accelerator.close_hw();
