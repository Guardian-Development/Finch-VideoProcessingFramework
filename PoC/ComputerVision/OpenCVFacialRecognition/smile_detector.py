import cv2

face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')
smile_cascade = cv2.CascadeClassifier('haarcascade_smile.xml')

def detect(grey_scale_image, original_image):
    faces = face_cascade.detectMultiScale(grey_scale_image, 1.3, 5)
    for (x, y, width, height) in faces:
        cv2.rectangle(original_image, (x, y), (x + width, y + height), (255, 0, 0), 2)
        grey_face_zone = grey_scale_image[y: y + height, x: x + width]
        original_face_zone = original_image[y: y + height, x: x + width]
        eyes = eye_cascade.detectMultiScale(grey_face_zone, 1.3, 7)
        for (eye_x, eye_y, eye_width, eye_height) in eyes:
            cv2.rectangle(original_face_zone, (eye_x, eye_y), (eye_x + eye_width, eye_y + eye_height), (0, 255, 0), 2)
        
        # detect smile inside face
        # increase parameters to make it more thorough when trying to find a smile
        smiles = smile_cascade.detectMultiScale(grey_face_zone, 1.7, 40)
        for (smile_x, smile_y, smile_width, smile_height) in smiles:
            cv2.rectangle(original_face_zone, (smile_x, smile_y), (smile_x + smile_width, smile_y + smile_height), (0, 0, 255), 2)
        
    return original_image

video_capture = cv2.VideoCapture(0)
while True: 
    _, frame = video_capture.read()
    grey_scale_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    canvas = detect(grey_scale_frame, frame)
    cv2.imshow('Video', canvas)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

video_capture.release()
cv2.destroyAllWindows()