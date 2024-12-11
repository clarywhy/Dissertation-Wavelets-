from PIL import Image, ImageFilter
import numpy as np
import noise
import os
import random

# Parameters
width, height = 512, 512
image_path = "/Users/clarissahui/Desktop/Uni/Dissertation/Dissertation-Wavelets-/Code/standard_test_images/cameraman.tif"
output_path = "distorted_image.png"

# Load and resize image
img = Image.open(image_path).resize((width, height))
pixels = np.array(img)

# Vector field function
def vector_field(x, y):
    amount1 = random.uniform(0.1, 0.3)
    scale1 = random.uniform(200, 400)
    noise_x1 = noise.pnoise2(scale1 * x, scale1 * y)
    noise_y1 = noise.pnoise2(100 + scale1 * x, scale1 * y)

    amount2 = random.uniform(0.01, 0.05)
    scale2 = random.uniform(600, 600)
    noise_x2 = noise.pnoise2(scale2 * x, scale2 * y)
    noise_y2 = noise.pnoise2(100 + scale2 * x, scale2 * y)

    displacement_x = (amount1 * (noise_x1 - 0.5)) + (amount2 * (noise_x2 - 0.5))
    displacement_y = (amount1 * (noise_y1 - 0.5)) + (amount2 * (noise_y2 - 0.5))
    
    return np.array([displacement_x, displacement_y])

    #return np.array([amount * (noise_x - 0.5), 4 * amount * (noise_y - 0.5)])

# Apply distortion to each pixel
distorted_image = np.zeros_like(pixels)
for i in range(width):
    for j in range(height):
        res = vector_field(i, j)
        ii = int(np.clip(i + res[0], 0, width - 1))
        jj = int(np.clip(j + res[1], 0, height - 1))
        distorted_image[i, j] = pixels[ii, jj]

# Save the distorted image
distorted_img = Image.fromarray(distorted_image.astype(np.uint8))

#blurred_distorted_img = distorted_img.filter(ImageFilter.GaussianBlur(radius=0.01))

distorted_img.save(output_path)

print(f"Distorted image saved as {output_path}.")

