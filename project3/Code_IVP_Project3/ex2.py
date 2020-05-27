import cv2
import numpy as np
from matplotlib import pyplot as plt

# Load an color image in grayscale
img = cv2.imread('branches.png', 0)

# First let's find the intensity mean of the image
sum = 0
for y in range(img.shape[0]):
    for x in range(img.shape[1]):
        sum += img[y, x]
mean = sum / (img.shape[0] * img.shape[1])

print('Intensity mean of the image: ', mean)


def binarize_img(img, threshold):
    new_im = np.zeros(np.shape(img))
    for y in range(new_im.shape[0]):
        for x in range(new_im.shape[1]):
            # global threshold
            if img[y, x] >= threshold:
                new_im[y, x] = 255
            else:
                new_im[y, x] = 0
    return new_im


# --------------------------------------------------------------
img_mean_global_threshold = binarize_img(img, mean)
# --------------------------------------------------------------
# Given C* STD(image)
c = 2;
std_away = (c * np.std(img)) + mean
img_std_global_threshold = binarize_img(img, std_away)
# --------------------------------------------------------------

save_img = cv2.imread('branches.png', 0)

# Adaptive Gaussian threshold

adaptive_thresh = cv2.adaptiveThreshold(save_img, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, \
                                        cv2.THRESH_BINARY, 11, C=7)
# To remove the noise I use the closing operation (with a small kernel)
kernel = np.ones((2, 2), np.uint8)
newAdapt = cv2.morphologyEx(adaptive_thresh, cv2.MORPH_CLOSE, kernel)

s = 'gray'
plt.figure(1)
plt.subplot(2, 2, 1), plt.imshow(save_img, s), plt.title('Original Image')
plt.subplot(2, 2, 2), plt.imshow(img_mean_global_threshold, s), plt.title('Global Threshold (Mean value)')
plt.subplot(2, 2, 3), plt.imshow(img_std_global_threshold, s), plt.title('Global Threshold (C = 2)')
plt.subplot(2, 2, 4), plt.imshow(adaptive_thresh, s), plt.title('Adaptive Gauss Threshold')
plt.show()

plt.figure(2)
plt.subplot(1, 2, 1), plt.imshow(adaptive_thresh, s), plt.title('Original Adaptive Thresholding')
plt.subplot(1, 2, 2), plt.imshow(newAdapt, s), plt.title('Adaptive Thresholding after opening operation')
plt.show()

# Morphological operations
# Had to test to find the best kernel
kernel = np.ones((5, 5), np.uint8)
morph = cv2.morphologyEx(img_mean_global_threshold, cv2.MORPH_OPEN, kernel)
# make a new (smaller) kernel for the next operation
newKernel = np.ones((3, 3), np.uint8)
erosion = cv2.erode(img_mean_global_threshold, newKernel, iterations=1)

plt.figure(3)
plt.subplot(2, 2, 1), plt.imshow(img_mean_global_threshold, s), plt.title('Binarized Image')
plt.subplot(2, 2, 2), plt.imshow(morph, s), plt.title('After Opening')
plt.subplot(2, 2, 3), plt.imshow(erosion, s), plt.title('After Erosion')
plt.show()
