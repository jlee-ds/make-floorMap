#http://docs.opencv.org/trunk/dc/dc3/tutorial_py_matcher.html#gsc.tab=0
import numpy as np
import cv2
import matplotlib.pyplot as plt

cv2.ocl.setUseOpenCL(False) 

#load images
img1 = cv2.imread('box.png',0)
img2 = cv2.imread('box_in_scene.png',0)

#initiate ORB detector
orb = cv2.ORB_create()

#find the keypints and descriptors with ORB
kp1, des1 = orb.detectAndCompute(img1,None)
kp2, des2 = orb.detectAndCompute(img2,None)

#create BFMatcher object
bf = cv2.BFMatcher(cv2.NORM_HAMMING,crossCheck=True)

#match descriptors
matches = bf.match(des1,des2)

#sort them in the order of their distance
matches = sorted(matches,key=lambda x:x.distance)

#draw first 10 matches
img3 = cv2.drawMatches(img1,kp1,img2,kp2,matches,None,flags=2) 

print len(kp1);
print len(kp2);
print len(matches);
plt.imshow(img3),plt.show()

