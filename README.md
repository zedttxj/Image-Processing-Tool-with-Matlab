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
##### 1st argument (required) - filename: The file path of the image you want to load. In this case, 'test.png' is used as the input file name.
Make sure that the image file is in the same directory as `ImageProcessor.m`.  
##### 2nd argument (optional) - log: A boolean flag that controls whether logs are displayed when the image is read.
Default: false (Logs are disabled).  
Recommended: Do not pass the second argument unless you want to display logs in the console (it is generally not needed for typical usage).  
#### 2. ImageProcessor.dimension
Use `ImageProcess.dimension` to check dimension of the object of your image in MATLAB. For example:  
```
ImageProcessor.dimension(img);
```
![{B6BD7928-69FD-475A-9577-A0C507832C4A}](https://github.com/user-attachments/assets/1926e69b-3828-41c5-83e0-7c1c5afb7c5c)  
Here, `408` is the height, `612` is the width, and `3` is the number of the channels (which are red, green, and blue)
##### 1st argument (required) - img: 
- The image variable for which you want to display the dimensions.
- This can be any image object, whether it's a 2D grayscale image or a 3D RGB image.
  - For a grayscale image, the dimension will be (height x width).
  - For an RGB image, the dimension will be (height x width x 3), where 3 represents the three color channels (Red, Green, and Blue).
#### 3. ImageProcessor.showImage - Feature
Use `ImageProcess.showImage` to show your image in MATLAB. For example:  
```
ImageProcessor.showImage(img);
```
### 4. ImageProcessor.saveImage - Feature  
Use `ImageProcess.showImage` to save your image in MATLAB folder. For example:  
#### 1st argument (required) - img:
- The image object that you want to save. It can be a 2D or 3D matrix.

#### 2nd argument (required) - filename:
- The name of the output file (including the extension).  
- Additionally, it also shows the path where the image is saved.

#### Example:
```matlab
ImageProcessor.saveImage(bayerImage, 'output.png');
```
![{A4290582-DA96-4C45-BB61-DC1EE93F2F80}](https://github.com/user-attachments/assets/53d7271c-e1b1-4387-8ff2-8e2c978e450f)
##### 1st argument (required) - img: 
- The image variable that you want to display. It can be a 2D image (height x width), typically used for black-and-white images, or a 3D image (height x width x channels), which is used for RGB color images.
- Ensure that the image variable (`img` in this case) has already been loaded or processed before calling this function.
- 3D image example (dimension is showed in the left): ![{B38A2799-8675-4D87-B6F3-AFD516DD7E42}](https://github.com/user-attachments/assets/30471daf-6ae5-4414-b3ce-d964c1a533ed)  
- 2D image example (dimension is showed in the left): ![{FBCBEBFB-5EC1-4259-9BBF-FC0BAA67F9B7}](https://github.com/user-attachments/assets/3e46f42d-1237-4a3a-b46c-c189a634c454)  
### Convert image object from 3D into 2D using Bayer Filter - Feature  
Usage: ImageProcessor.convert2Bayer  
#### 1st argument (required) - rgbImage:
- The 3D image object that you have imported. You can use `ImageProcessor.readImage` to import the image.
#### 2st argument (required) - filter:
- The 2D Bayer filter that is used. You can manually set it like this:
```
filter = [
    1, 2;
    2, 3;
];
```
In this case, the filter is 'grbg', which is the most common Bayer filter pattern.  
- `3` represents the blue channel.
- `2` represents the green channel.
- `1` represents the red channel.
The filter size doesn't have to be a square matrix.
#### 3rd argument (optional) - show:
A boolean variable that is automatically set to true. For example:
```
```
If enabled, the function will display:
- The Bayer filter matrix in the console log (below the line Filter matrix:).
- The Swapping matrix in the console log (only if ord is set to 2, which is explained in the 6th argument).
