"""Provides detection of different elements within an image represented as an ndarray

Makes use of open_cv to detect features in an image
"""
from typing import List, Tuple
from numpy import ndarray
import numpy as np
import cv2
from imutils.object_detection import non_max_suppression

class Detector:
    """Detects a specific feature in an image

    Allows for generic detection to be made on an image represented as a numpy array
    """


    def detect(self, frame: ndarray) -> List[Tuple[float, float, float, float]]:
        """Detects a feature within a numpy array 
        
        Returns the list of locations in the image the feature occurs 
        Returns the x and y coordinates of the bottom left corner, then the x + width and y + height
        
        Arguments:
            frame: ndarray {[ndarray]} -- [the image to detect features within]
        
        Raises:
            NotImplementedError -- should be implemented in child classes
        """
        raise NotImplementedError

class PersonDetector(Detector):
    """Detects people within an image 

    Makes use of opencv to detect all people within an image
    """
    
    def __init__(self):
        hog = cv2.HOGDescriptor()
        hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector())
        self.hog_detector = hog

    def detect(self, frame: ndarray) -> List[Tuple[float, float, float, float]]:
        """Detects people in an image and returns a list of people that are seen.

        Makes use of opencv hog model with an SVM detector to find the people
        It then uses object detection non_max_suppression function to help merge false positives
        
        Arguments:
            frame: ndarray {[ndarray]} -- The image to detect people in
        
        Returns:
            [List[Tuple[float, float, float, float]]] -- [a list of coordinates that people are found at in the image]
        """
        rectangles, weights = self.hog_detector.detectMultiScale(frame, winStride=(4,4), padding=(32,32), scale=1.05)
        rectangles = [r for (r, w) in zip(rectangles, weights) if w > 0.7]

        initial_people = np.array([[x, y, x + w, y + h] for (x, y, w, h) in rectangles])
        final_detected_people = non_max_suppression(initial_people, probs=None, overlapThresh=0.65)
        return final_detected_people
