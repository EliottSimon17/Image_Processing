import numpy as np
import cv2
from matplotlib import pyplot as plt


# -------------------------------------------------------------------------------------------------------
# First Video
def compute_MEI(vidcap):
    success, image = vidcap.read()
    image_vector = []
    while success:
        image_vector.append(image)  # save frame as JPEG file
        success, image = vidcap.read()

    graysc_vector = []
    # Converts all the images to GrayScale
    for image in image_vector:
        new_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        graysc_vector.append(new_image)

    # Finds the difference in intensities
    def find_d(frame1, frame2):
        D = np.zeros((frame1.shape[0], frame2.shape[1]))
        for c in range(1, D.shape[0] - 1):
            for r in range(1, D.shape[1] - 1):
                if frame2[c, r] >= frame1[c, r]:
                    value = frame2[c, r] - frame1[c, r]
                else:
                    value = frame1[c, r] - frame2[c, r]
                D[c, r] = value
        return D

    d_history = []
    for index in range(1, len(graysc_vector) - 1):
        D = find_d(graysc_vector[index+1], graysc_vector[index])
        d_history.append(D)

    d_f_history = []
    flag = False
    for index in range(1, len(d_history) - 1):
        if flag:
          D = find_d(d_history[index], D)
        else:
          flag = True
          D = find_d(d_history[index], d_history[index+1])
        d_f_history.append(D)

    # Displays some results
    counter = 1
    plt.figure()
    for index in range(2,len(d_f_history)):

        if index % 5 == 0 and counter <= 9:
            plt.subplot(3, 3, counter), plt.imshow(d_f_history[index], 'gray'), plt.title('MEI')
            counter = counter + 1
    plt.show()
    pass


# -------------------------------------------------------------------------------------------------------
vidcap = cv2.VideoCapture('ira_walk.avi')
vidcap2 = cv2.VideoCapture('lyova_side.avi')
vidcap3 = cv2.VideoCapture('ido_pjump.avi')

compute_MEI(vidcap)
compute_MEI(vidcap2)
compute_MEI(vidcap3)
