import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('15190201_01_001_01.jpg', 0)

# ----------------------------------------------------------------------------------------------------
# First step : Binarize the image using the mean intensity value as threshold
sum = 0
for y in range(img.shape[0]):
    for x in range(img.shape[1]):
        sum += img[y, x]
mean = sum / (img.shape[0] * img.shape[1])

print('Intensity mean of the image: ', mean)

# now let's modify the pixels
for y in range(img.shape[0]):
    for x in range(img.shape[1]):
        # global threshold
        if img[y, x] >= mean + 25:
            img[y, x] = 0
        else:
            img[y, x] = 255

plt.figure(1), plt.imshow(img, 'gray'), plt.title('Binarized image'), plt.show()
# ----------------------------------------------------------------------------------------------------
# Now that we have our binarized image, we have to find structuring element that match with the patterns found in the image
# As we can see, the image contains a lot of circles of different sizes. The shape of the SE will then be an ellipse.
sum_image = np.sum(img)
f_history = []

# Thus, we apply the opening operation on different kernel sizes (increasing)
plt.figure(2)
plt.subplot(2, 2, 1), plt.imshow(img, 'gray'), plt.title('Original Image')
for index in range(70, 140, 10):
    # Create a structuring element of various size
    se = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (index, index))
    # Applies the opening operation on the image given the SE
    opening = cv2.morphologyEx(img, cv2.MORPH_OPEN, se)
    # Gets the size distribution factor (sum(new image) / sum(original image)
    f_history.append(np.sum(opening) / sum_image)
    if index == 80:
        plt.subplot(2, 2, 2), plt.imshow(opening, 'gray'), plt.title('Ellipse size: 80')
    if index == 100:
        plt.subplot(2, 2, 3), plt.imshow(opening, 'gray'), plt.title('Ellipse size: 100 ')
    if index == 130:
        plt.subplot(2, 2, 4), plt.imshow(opening, 'gray'), plt.title('Ellipse size: 130 ')

plt.show()
# Plot the size distribution
y = np.linspace(70, 140, 7)
plt.figure(3)
plt.plot(y, f_history)
plt.show()
