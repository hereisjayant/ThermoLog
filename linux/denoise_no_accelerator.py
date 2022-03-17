from PIL import Image
import numpy
import time

# time program run time
start_time = time.time()

# define image size
width = 500
height = 480
depth = 3

# read png to array
img = Image.open("noise.png")
arr = numpy.array(img.getdata())

# saved processed image to 3d array
result = numpy.zeros((height, width, depth), dtype=numpy.uint8)

def compute_pixel(p1, p2, p3, p4, p5, p6, p7, p8, p9):
    sum = 0.0
    sum += p1 * 0.05 + p2 * 0.10 + p3 * 0.05
    sum += p4 * 0.10 + p5 * 0.40 + p6 * 0.10
    sum += p7 * 0.05 + p8 * 0.10 + p9 * 0.05
    return p5

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
