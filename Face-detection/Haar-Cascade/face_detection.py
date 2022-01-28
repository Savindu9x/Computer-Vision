import cv2
import argparse

def detectAndDisplay(frame):
    frame_gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    frame_gray = cv2.equalizeHist(frame_gray)

    #detect faces
    faces = face_cascade.detectMultiScale(frame_gray)
    for (x,y,w, h) in faces:
        center = (x + w/2, y + h//2)
        frame = cv2.ellipse(frame, center, (w//2, h//2), 0, 0, 360, (255, 0, 255), 4)

    cv2.imshow('Capture - Face detection', frame)
    cv2.waitKey()

parser = argparse.ArgumentParser(description='Code for Cascade Classifier tutorial.')
parser.add_argument('--face_cascade', help='Path to face cascade.', default='haarcascade_frontalface_alt.xml')
parser.add_argument('--camera', help='Camera divide number.', type=int, default=0)
args = parser.parse_args()



face_cascade_name = args.face_cascade
face_cascade = cv2.CascadeClassifier()


# Load the cascades
if not face_cascade.load(cv2.samples.findFile(face_cascade_name)):
    print("Error - not found file")
    exit(0)

camera_device = args.camera
#read the video stream
cap = cv2.VideoCapture(camera_device)
if not cap.isOpened():
    print("Error- opening video capture")
    exit(0)

while True:
    ret, frame = cap.read()
    if frame is None:
        print("No captured frame")
        break

    detectAndDisplay(frame)

    if cv2.waitKey(10) == 27:
        break
