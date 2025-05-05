import numpy as np
from PIL import Image
from PIL import ImageFilter
from noise import pnoise2
import os
from tqdm import tqdm

def generate_smooth_noise(width, height, time, scale=0.03, octaves=2):
    x = np.arange(width)
    y = np.arange(height)
    xx, yy = np.meshgrid(x, y)
    
    # Base noise with time evolution
    nx = xx * scale + time * 0.2
    ny = yy * scale + time * 0.8
    
    noise_values = np.zeros_like(xx, dtype=float)
    amplitude = 1.0
    
    for _ in range(octaves):
        layer = np.array([[pnoise2(i, j) for i, j in zip(row_x, row_y)] 
                         for row_x, row_y in zip(nx, ny)])
        noise_values += amplitude * layer
        amplitude *= 0.5
        scale *= 4.0
    
    return noise_values / octaves


def create_distortion_field(width, height, time):
    # Generate smoother noise
    noise_x = generate_smooth_noise(width, height, time)
    noise_y = generate_smooth_noise(width, height, time + 0.3)  # Offset for variation
    
    # Create gentler vertical wave pattern
    yy = np.arange(height)[:, np.newaxis]
    xx = np.arange(width)[:, np.newaxis]
    wave_freq = 0.07  # Lower frequency for smoother waves
    wave_phase = time * 15.0 + yy * wave_freq + 0.002 * np.sin(xx * 0.02)

    # Smoother intensity modulation using cosine
    intensity = ((np.cos(2 * np.pi * wave_phase) + 1) / 2) ** 3 * 0.4
    
    
    
    # Blend noise and wave patterns
    distortion_x = 9 * noise_x * (intensity + 0.6)  # Add base level
    distortion_y = 9 * noise_y * (intensity + 0.6)
    
    # Apply horizontal smoothing (fixed syntax)
    kernel = np.array([0.25, 0.5, 0.25])
    distortion_x = np.apply_along_axis(lambda x: np.convolve(x, kernel, mode='same'), 1, distortion_x)
    distortion_y = np.apply_along_axis(lambda x: np.convolve(x, kernel, mode='same'), 1, distortion_y)
    
    return distortion_x[:, :width], distortion_y[:, :width]

def apply_distortion(image, dx, dy):
    h, w = image.shape
    x_coords, y_coords = np.meshgrid(np.arange(w), np.arange(h))
    new_x = np.clip(x_coords + dx, 0, w-1).astype(int)
    new_y = np.clip(y_coords + dy, 0, h-1).astype(int)
    return image[new_y, new_x]

# Main execution
if __name__ == "__main__":
    img = Image.open("jetplane.png").convert('L')
    img_np = np.array(img)
    h, w = img_np.shape
    
    num_frames = 100
    os.makedirs("./frames4/", exist_ok=True)
    
    for frame in tqdm(range(num_frames)):
        t = frame / num_frames
        dx, dy = create_distortion_field(w, h, t)
        distorted = apply_distortion(img_np, dx, dy)
        distorted_img = Image.fromarray(distorted)
        # Apply Gaussian blur
        distorted_blurred = distorted_img.filter(ImageFilter.GaussianBlur(radius=1.3))

        # Add Gaussian noise
        distorted_np = np.array(distorted_blurred).astype(np.float32)
        noise_sigma = 6  # noise strength (standard deviation)
        noisy_distorted = distorted_np + noise_sigma * np.random.randn(*distorted_np.shape)
        noisy_distorted = np.clip(noisy_distorted, 0, 255).astype(np.uint8)

        Image.fromarray(noisy_distorted).save(f"./frames4/frame{frame:03d}.png")
    
    print("Done! Frames saved in ./frames4/")




