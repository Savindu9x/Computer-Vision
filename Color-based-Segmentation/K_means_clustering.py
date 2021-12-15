# Import Libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import cv2
from sklearn.cluster import KMeans

# Loading Imag
img=cv2.imread('image_sample.jpg')
plt.imshow(img)

# Converting from BGR to RGB
img=cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
plt.imshow(img)
# Reshaping
img=img.reshape((img.shape[1]*img.shape[0],3))

# Applying K means
kmeans=KMeans(n_clusters=5)
s=kmeans.fit(img)

# determining labels
labels=kmeans.labels_
print(labels)
labels=list(labels)

# Determining Centroids of Clusters
centroid=kmeans.cluster_centers_
print(centroid)

#  Calculating the Percentages
percent=[]
for i in range(len(centroid)):
  j=labels.count(i)
  j=j/(len(labels))
  percent.append(j)
print(percent)
