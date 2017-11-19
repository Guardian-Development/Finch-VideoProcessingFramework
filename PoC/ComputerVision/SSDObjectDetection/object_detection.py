# Importing the libraries

# PyTorch Neural Network and computer vision
import torch
from torch.autograd import Variable
# Import CV2 for rectangle drawing
import cv2
# BaseTransform: transform input images to the neccessary format for the Neural Network 
# VOC_CLASSES: maps the text field of the classes to integers
from data import BaseTransform, VOC_CLASSES as labelmap
# Single Shot MultiBox Detection Model
from ssd import build_ssd
# Process frames of the video
import imageio

# Defining function that will do the detections 
# frame : image to perform object detection on
# network: SSD neural network to use for detection, pre-trained already to detect a variety of objects
# transform: will transform image to be in right format for neural network
def detect(frame, network, transform): 
    # get first 2 indexes of shape, which are the height and width
    height, width = frame.shape[:2]

    # first returned param is numpy array
    frame_t = transform(frame)[0]

    # convert numpy array to a torch tensor 
    # convert image from RGB to BRG for this trained network
    x = torch.from_numpy(frame_t).permute(2, 0, 1)

    # create new dimension for the batch and then convert to a torch Variable
    x = Variable(x.unsqueeze(0))

    # feed x to the neural network getting the output
    y = network(x)

    # we only want first element of Torch Variable wich is the Tensor
    # detections = [batch, number of classes, number of occurences of a class, (score, x0, y0, x1, y1)]
    # score is threshold with the coordintes of the location of the object
    detections = y.data
    scale = torch.Tensor([width, height, width, height])

    for i in range(detections.size(1)):
        j = 0
        # score of occurence j of the class i 
        while detections[0, i, j, 0] >= 0.6:
            # get the location of the object 
            # normalise points, to get location of points at the scale of the original image
            pt = (detections[0, i, j, 1:] * scale).numpy()

            # draw rectangle from th found object
            cv2.rectangle(frame, (int(pt[0]), int(pt[1])), (int(pt[2]), int(pt[3])), (255, 0, 0), 2)

            # print label for object
            # image to use, text to display, position to display text, font, font size, font colour, font width, continous text
            cv2.putText(frame, labelmap[i - 1], (int(pt[0]), int(pt[1])), cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 255, 255), 2, cv2.LINE_AA)
            j += 1

    return frame


# Create SSD neural network 
network = build_ssd('test')
# load pre trained network into our network object
network.load_state_dict(torch.load('ssd300_mAP_77.43_v2.pth', map_location = lambda storage, loc: storage))

# Create the image transformation, target size of images to be given to network based on the pre trained network
transform = BaseTransform(network.size, (104/256.0, 117/256.0, 123/256.0))

# Do object detection on a video 
reader = imageio.get_reader('funny_dog.mp4')
fps = reader.get_meta_data()['fps']
writer = imageio.get_writer('output.mp4', fps = fps)

for i, frame in enumerate(reader): 
    frame = detect(frame, network.eval(), transform)
    writer.append_data(frame)
    print(i)

writer.close()
