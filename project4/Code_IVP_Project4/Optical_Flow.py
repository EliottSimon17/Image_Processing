import numpy as np
import cv2
from matplotlib import pyplot as plt

cap = cv2.VideoCapture('ira_walk.avi')
cap2 = cv2.VideoCapture('lyova_side.avi')
cap3 = cv2.VideoCapture('ido_pjump.avi')

# params for ShiTomasi corner detection
feature_params = dict( maxCorners = 100,
                       qualityLevel = 0.3,
                       minDistance = 7,
                       blockSize = 7 )
# Parameters for lucas kanade optical flow
lk_params = dict( winSize  = (15,15),
                  maxLevel = 2,
                  criteria = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 10, 0.03))

# Create some random colors
color = np.random.randint(0,255,(100,3))


ret, old_frame = cap.read()
print(np.shape(old_frame))

v = cv2.cvtColor(old_frame, cv2.COLOR_RGB2GRAY)
old_gray = cv2.cvtColor(old_frame, cv2.COLOR_BAYER_GB2GRAY)

old_points = np.array([[]])
while (1):
    ret, frame = cap.read()
    frame_gray = cv2.cvtColor(frame,
                              cv2.COLOR_BGR2GRAY)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
