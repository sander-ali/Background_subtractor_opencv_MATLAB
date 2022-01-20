close all
clear all
clc
%Background subtractor using OpenCV in MATLAB
%Make sure you install opencv package in MATLAB follow the instructions on
%this page https://mathworks.com/help/vision/ug/opencv-interface.html. The
%easiest way is to type visionSupportPackages in your MATLAB command
%window, a window will appear, install it.

%% Load the video
videoSample = VideoReader("atrium.mp4");
videoSample.CurrentTime = 0.1;
%% Import OpenCV Package
import clip.opencv.*;
import vision.opencv.*;
%% Specify parameter values for Background Subtractor
history = 300; threshold = 400; shadow = true;
%% Create a utility function for background subtractor class
cvPtr = cv.createBackgroundSubtractorKNN(history, threshold, shadow);
KNNBase = util.getBasePtr(cvPtr);
%% Select the number of K-nearest neighbor
KNNBase.setKNNSamples(2);
%% Extract the foreground region using backgroundSubtractorKNN
foregroundmask = zeros(videoSample.Height, videoSample.Width, videoSample.NumFrames);
while hasFrame(videoSample)
    frame = readFrame(videoSample);
    [inMat, imgInput] = util.createMat(frame);
    [outMat, outImg] = util.createMat();
    KNNBase.apply(imgInput, outImg);
    foregroundmask = util.getImage(outImg);

    foregroundmask = rescale(foregroundmask);
    foregroundmask = cast(foregroundmask, "like", frame);

    foreground(:,:,1) = frame(:,:,1).*foregroundmask;
    foreground(:,:,2) = frame(:,:,2).*foregroundmask;
    foreground(:,:,3) = frame(:,:,3).*foregroundmask;

    image(foreground, Parent=gca);
    pause(0.01);
end