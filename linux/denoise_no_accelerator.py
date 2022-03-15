from PIL import Image
import numpy

width = 640
height = 480
depth = 3

img = Image.open("noise.png")
arr = numpy.array(img.getdata())

result = numpy.zeros((height, width, depth), dtype=numpy.uint8)

def get_pixel(p1, p2, p3, p4, p5, p6, p7, p8, p9):
    return p5

for i in range(1, height - 1):
    for j in range(1, width - 1):
        for d in range(depth):
            result[i][j][d] = get_pixel(
                                        arr[(i - 1) * width + j - 1][d],
                                        arr[(i - 1) * width + j][d],
                                        arr[(i - 1) * width + j + 1][d],
                                        arr[i * width + j - 1][d],
                                        arr[i * width + j][d],
                                        arr[i * width + j + 1][d],
                                        arr[(i + 1) * width + j - 1][d],
                                        arr[(i + 1) * width + j][d],
                                        arr[(i + 1) * width + j + 1][d]
                                    )

result_img = Image.fromarray(result, "RGB")
result_img.save("result.png")

print("Done")
