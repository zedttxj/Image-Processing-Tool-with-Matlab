# Image-Processing-Tool-with-Matlab

## Overview
The goal of this project is to simplify image processing tools in MATLAB, particularly for academic use, such as presentations in LaTeX. Currently, the goal is to simplify Bayer filter application tools that are easy to work with. To use it, download [ImageProcess.m](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/ImageProcessor.m). Additionally, you can test it with [test.m](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/test-script.m).
## Warning
When calling a command in MATLAB, please make sure to put a `;` at the end of the command to prevent unnecessary logs. This helps keep your MATLAB console clean and avoids displaying function outputs that you do not need.

## Features
### Common Features
#### 1. ImageProcessor.readImage
Use `ImageProcess.readImage` to input your image into variable in MATLAB. For example:  
```
img = ImageProcessor.readImage('test.png', true);
```
##### 1st argument (required): The file path of the image you want to load. In this case, 'test.png' is used as the input file name.
Make sure that the image file is in the same directory as `ImageProcessor.m`.  
#####  (optional): A boolean flag that controls whether logs are displayed when the image is read.
Default: false (Logs are disabled).  
Recommended: Do not pass the second argument unless you want to display logs in the console (it is generally not needed for typical usage).  
#### 2. ImageProcessor.dimension
Use `ImageProcess.dimension` to check dimension of the object of your image in MATLAB. For example:  
```
ImageProcessor.dimension(img);
```
![{B6BD7928-69FD-475A-9577-A0C507832C4A}](https://github.com/user-attachments/assets/1926e69b-3828-41c5-83e0-7c1c5afb7c5c)
Here, `408` is the height, `612` is the width, and `3` is the number of the channels (which are red, green, and blue)
##### 1st argument (required): 
- The image variable for which you want to display the dimensions.
- This can be any image object, whether it's a 2D grayscale image or a 3D RGB image.
  - For a grayscale image, the dimension will be (height x width).
  - For an RGB image, the dimension will be (height x width x 3), where 3 represents the three color channels (Red, Green, and Blue).
#### 3. ImageProcessor.showImage
Use `ImageProcess.showImage` to show your image in MATLAB. For example:  
```
ImageProcessor.showImage(img);
```
##### 1st argument (required): 
- The image variable that you want to display. It can be a 2D image (height x width), typically used for black-and-white images, or a 3D image (height x width x channels), which is used for RGB color images.
- Ensure that the image variable (`img` in this case) has already been loaded or processed before calling this function.
- 3D image example (dimension is showed in the left): ![{B38A2799-8675-4D87-B6F3-AFD516DD7E42}](https://github.com/user-attachments/assets/30471daf-6ae5-4414-b3ce-d964c1a533ed)
- 2D image example (dimension is showed in the left): ![{FBCBEBFB-5EC1-4259-9BBF-FC0BAA67F9B7}](https://github.com/user-attachments/assets/3e46f42d-1237-4a3a-b46c-c189a634c454)
### Bayer Filter
      
