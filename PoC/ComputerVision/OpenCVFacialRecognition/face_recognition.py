# import libraries
import cv2

# cascade is a series of filters that will apply one after the other to detect the face
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')

# define a function that will detect face and eyes 
def detect(grey_scale_image, original_image):
    # returns coordinates of all face in image
    # 1.3 is the scaling applied to the image for search
    # 5 is the number of feature that must be detected in an image for it to be perceived as a face
    faces = face_cascade.detectMultiScale(grey_scale_image, 1.3, 5)

    # coordinate of each face (x, y) with the width and height
    for (x, y, width, height) in faces:
        # 2 is the thickness of the rectangle
        cv2.rectangle(original_image, (x, y), (x + width, y + height), (255, 0, 0), 2)

        # detect eyes
        grey_face_zone = grey_scale_image[y: y + height, x: x + width]
        original_face_zone = original_image[y: y + height, x: x + width]

        # returns coordinates of all eyes in grey_face_zone
        eyes = eye_cascade.detectMultiScale(grey_face_zone, 1.1, 3)
        for (eye_x, eye_y, eye_width, eye_height) in eyes:
            cv2.rectangle(original_face_zone, (eye_x, eye_y), (eye_x + eye_width, eye_y + eye_height), (0, 255, 0), 2)
    
    # return original image with the rectangles drawn
    return original_image

# use the webcam to get the stream of input frames to detect faces in

# 0 is the internal webcam, 1 is an external webcam
video_capture = cv2.VideoCapture(0)

# capture video
while True: 
    # last frame of the webcam
    _, frame = video_capture.read()
    grey_scale_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # result of facial detection 
    canvas = detect(grey_scale_frame, frame)
    cv2.imshow('Video', canvas)

    # stop webcam and face detection
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# turn off webcam
video_capture.release()

# destroy all displayed windows by cv2
cv2.destroyAllWindows()