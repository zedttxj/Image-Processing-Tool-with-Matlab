# Image Processing Tool with Matlab
**Disclaimer**: This project is provided "as is" without any warranties or representations, express or implied, including but not limited to the implied warranties of merchantability and fitness for a particular purpose. No copyrights, patents, licenses, or trade secrets are applied to this project. You are free to use, modify, and distribute it for academic, research, or commercial purposes, subject to applicable laws and regulations.
## Overview
The goal of this project is to simplify image processing tools in MATLAB, particularly for academic use, such as presentations in LaTeX. Currently, the goal is to simplify Bayer filter application tools that are easy to work with. To use it, download [ImageProcess.m](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/ImageProcessor.m). Additionally, you can test it with [test-script.m](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/test-script.m).  
## Current Significant Tools:
`convertPartition2Matrix` – Converts a partitioned structure (1D) into a matrix representation (2D).  
`convertMatrix2Partition` – Transforms a 2D matrix into a partitioned structure (1D).  
`partitionDecomposition` – Generates all possible 2D matrices that match the same partition structure.  
`convert2Bayer` – Converts an image into a Bayer pattern using a specified filter and configuration.  
`convertBayer2RGB` – Converts a Bayer-patterned image back into an RGB image.  
## Additional Tools
If you need more tools, you can explore the `optional` folder.
## Warning
When calling a command in MATLAB, please make sure to put a `;` at the end of the command to prevent unnecessary logs. This helps keep your MATLAB console clean and avoids displaying function outputs that you do not need.

## Features
### Common Features
#### 1. ImageProcessor.readImage
- Use `ImageProcess.readImage` to input your image into variable in MATLAB. For example:  
```
img = ImageProcessor.readImage('test.png', true);
```
##### 1st parameter (required) - filename: The file path of the image you want to load. In this case, 'test.png' is used as the input file name.
- Make sure that the image file is in the same directory as `ImageProcessor.m`.  
##### 2nd parameter (optional) - log: A boolean flag that controls whether logs are displayed when the image is read.
- Default: false (Logs are disabled).  
- Recommended: Do not pass the second parameter unless you want to display logs in the console (it is generally not needed for typical usage).  
#### 2. ImageProcessor.dimension
- Use `ImageProcess.dimension` to check dimension of the object of your image in MATLAB. For example:  
```
ImageProcessor.dimension(img);
```
![{B6BD7928-69FD-475A-9577-A0C507832C4A}](https://github.com/user-attachments/assets/1926e69b-3828-41c5-83e0-7c1c5afb7c5c)  
Here, `408` is the height, `612` is the width, and `3` is the number of the channels (which are red, green, and blue)
##### 1st parameter (required) - img: 
- The image variable for which you want to display the dimensions.
- This can be any image object, whether it's a 2D grayscale image or a 3D RGB image.
  - For a grayscale image, the dimension will be (height x width).
  - For an RGB image, the dimension will be (height x width x 3), where 3 represents the three color channels (Red, Green, and Blue).
#### 3. ImageProcessor.showImage - Feature
- Use `ImageProcess.showImage` to show your image in MATLAB. For example:  
```
ImageProcessor.showImage(img);
```
##### 1st parameter (required) - img: 
- The image variable that you want to display. It can be a 2D image (height x width), typically used for black-and-white images, or a 3D image (height x width x channels), which is used for RGB color images.
- Ensure that the image variable (`img` in this case) has already been loaded or processed before calling this function.
- 3D image example (dimension is showed in the left): ![{B38A2799-8675-4D87-B6F3-AFD516DD7E42}](https://github.com/user-attachments/assets/30471daf-6ae5-4414-b3ce-d964c1a533ed)  
- 2D image example (dimension is showed in the left): ![{FBCBEBFB-5EC1-4259-9BBF-FC0BAA67F9B7}](https://github.com/user-attachments/assets/3e46f42d-1237-4a3a-b46c-c189a634c454)  
### 4. ImageProcessor.saveImage - Feature  
- Use `ImageProcess.saveImage` to save your image in MATLAB folder. For example:  
#### 1st parameter (required) - img:
- The image object that you want to save. It can be a 2D or 3D matrix.

#### 2nd parameter (required) - filename:
- The name of the output file (including the extension).  
- Additionally, it also shows the path where the image is saved.

#### Example:
```
ImageProcessor.saveImage(bayerImage, 'output.png');
```
![{A4290582-DA96-4C45-BB61-DC1EE93F2F80}](https://github.com/user-attachments/assets/53d7271c-e1b1-4387-8ff2-8e2c978e450f)
### Convert image object from 3D (rgb) into 2D (gray) using Bayer Filter - Feature  
- Usage: `ImageProcessor.convert2Bayer`  
#### 1st parameter (required) - rgbImage:
- The 3D image object that you have imported. You can use `ImageProcessor.readImage` to import the image.
#### 2st parameter (required) - filter:
- The 2D Bayer filter that is used. You can manually set it like this:
```
filter = [
    1, 2;
    2, 3;
];
```
In this case, the filter is 'RGGB'.  
- `3` represents the blue channel.
- `2` represents the green channel.
- `1` represents the red channel.
The filter size doesn't have to be a square matrix.
#### 3rd parameter (optional) - show:
A boolean variable that is automatically set to true. For example:
![{EE49952E-F8CB-41C8-A691-24E18E29EF1A}](https://github.com/user-attachments/assets/8d137ace-91fa-4c77-acb5-e720ceaba63c)  
If enabled, the function will display:
- The Bayer filter matrix in the console log (below the line "Filter matrix:").
- The Swapping matrix in the console log (only if ord is set to 2, which is explained in the 6th parameter).
#### 4th parameter (optional) - rgb:
- Pick colors to apply the filter. 1st element represents the red color, 2nd one represents the green color, 3rd one represents the blue color.
- Example: To use the red & blue pixel matrices only, set the 4th parameter to `[true false true]` (excluding the green pixel matrix by setting it to `false`):
![{0ED9AA32-9DC5-451B-B05F-7C228026B3C4}](https://github.com/user-attachments/assets/79c319d7-5189-4b60-92d0-7c9ed85a3583)
#### 5th parameter (optional) - filtersize:
- Expand the filter into a larger size. For example, from 2x2 filter into 4x5 filter (in MATLAB, I put `[4 5]`).  
![{EB4FE867-5B9D-440B-8664-5C2A181AEFE5}](https://github.com/user-attachments/assets/ee9ccdb4-7bc3-4d09-97f6-371cb6300c4c)
However, if the size of the filter fits the expanded size nicely (2x2 fits 6x4 for example), this doesn't affect the image without the 6th parameter due to the nature of the calculation.
#### 6th parameter (optional) - `ord`:
Sorts the **Bayer filter** based on the specified order.  
Currently, there are **3 modes**:

- **Mode `0`**: No sorting applied.  
- **Mode `1`**: Sorts by **color order only**:
  - The default order is **`R < G < B`** (this can be adjusted in future versions).
  - Sorting is performed **column-wise first, then row-wise** (this can also be adjusted in the future).  
- **Mode `2`**: Sorts by **color order**, affecting the **position of the matrices**:
  - This mode swaps the order of matrices according to the color order in **Mode `1`**.
  - The **Swapping matrix** will be displayed in the console log to visualize how the positions have been altered.

Example usage:
```
ImageProcessor.convert2Bayer(img, filter, true, [true false true], [4 5], 2);
```
Visual example for mode `1`:
![{2C550A8F-714B-4309-95F9-DCA1D59750CB}](https://github.com/user-attachments/assets/f37fdda0-4bbf-4f55-9441-612b2c168252)
Visual example for mode `2`:
![{8246FC8B-6697-4320-B6D2-EAE65E9A26A1}](https://github.com/user-attachments/assets/855d0441-1182-4ba9-a580-3df5dfee308d)
In this example, you can see the Swapping matrix in the console log. Let's use the element at position [1, 3] as an example. The element at position [1, 3] will be swapped with the element at position [1, 5].  
The element at [1, 3] stands at the 1st row and 3rd column of the image.  
When applying the Bayer filter in mode 2, the element at [1, 3] will be replaced with the element at [1, 5] (as seen in the Swapping matrix).  
This swap is based on the color order defined in mode 1 and happens according to the positions in the Swapping matrix.  
### Convert Bayer image object from 2D (gray) into 3D (rgb) using Bayer Filter - Feature  
This function converts a 2D Bayer image into a 3D RGB image using a Bayer filter. The parameters are almost the same as ImageProcessor.convert2Bayer, except for the 6th parameter:
- `ord` == 0 → No sorting
- `ord` > 0 → Sorts by color order (R < G < B). Sorting is applied column-first, then row-wise (this can be adjusted in the future).  
![{4287F959-1393-4967-B19E-2AE8F60B04EE}](https://github.com/user-attachments/assets/2230400e-e16c-4c39-8fc2-dd3b6163a7bb)  
### Custom Sorting Function - Feature  
Usage: Use `ImageProcessor.customSorting(data, custom_order, ord)` to get the sorted 2D matrix. It will return the sorted matrix along with the row and column indices where the values were swapped. For example:  

![{D497C850-D8B3-4A76-B43B-CFFDBB3D80E4}](https://github.com/user-attachments/assets/c62b12f9-4694-4ece-a1f1-eb952eb946b5)  
#### 1st Parameter (required) - `data`
- The 2D matrix that you want to sort.
#### 2nd parameter (required) - `ord`
Defines the order in which sorting happens:
- `r`: Sort by rows first.
- `c`: Sort by columns first.
- `rc`: Sort by rows first, then columns.
You can repeat the sorting type (e.g., rcr), but it won't change the outcome (since sorting by rows twice is redundant).
#### 3rd parameter (optional) - `custom_order`
- Default: The default custom order is [1 2 3 ...], meaning the sorting order is ascending (1 < 2 < 3 ...).
- Custom Example: In the example, you can set the custom order as [2 1 3], meaning that 2 < 1 < 3 for sorting purposes.
#### Naming Clarification:
- rows: Although it is named "rows," it actually represents the column indices where the values have been moved in the sorted matrix. You can display these column indices with the following code:
```
disp(rows)  % This represents the column indices, but the name might be confusing
```
- cols: Similarly, cols represents the row indices where the values have been moved in the sorted matrix. You can display these row indices with the following code:
```
disp(cols)  % This represents the row indices, but the name might be confusing
```
## Update: New Features for ImageProcessor.convert2Bayer and ImageProcessor.convertBayer2RGB
Both functions now support 7th and 8th parameters, which function similarly to the 2nd and 3rd parameters in the customSorting feature.  
- 7th parameter: Defines the primary sorting order (r, c, rc, etc.).
- 8th parameter: Allows for a custom sorting order, enabling specific prioritization of values.
![{8F5B8348-86CE-469A-9006-E4B73F1C2206}](https://github.com/user-attachments/assets/f267934d-6f24-496a-b017-2c165ef3287b)

## New Features: `convertPartition2Matrix`, `convertMatrix2Partition`, and `partitionDecomposition`
Main usage: analyzing the 2D matrices in young tableau or partition form.  
### 1. `convertPartition2Matrix` & `convertMatrix2Partition`
These two functions allow conversion between 1D partitions and 2D matrices:  
- convertPartition2Matrix: map a partition (1D) into a 2D matrix in a ***SORTED*** order.  
- convertMatrix2Partition: flatten a matrix back into its original partition. The matrix does ***NOT*** have to be sorted.  
#### *Both functions serve different purposes and using both at the same time does NOT NECESSARILY make the data stays the same*
#### Clarification: Partition Format (1D array) 
The partition form follows this structure: `[ <number of rows> <number of columns> <1d partition...> ]`
- The first value represents the number of rows in the matrix.
- The second value represents the number of columns in the matrix.
- The remaining values represent the partition data, where each entry defines the number of filled positions (1s) per row.  
#### **Example 1**:
A partition like:
```
partition = [3, 4, 2, 3, 1];
```
Means the corresponding 2D matrix would be:
```
1 1 0 0
1 1 1 0
1 0 0 0
```
#### **Example 2**:
![{FFEF9CBD-E44A-4894-8DE3-6F04D0977DBF}](https://github.com/user-attachments/assets/7d669b28-91cb-4bd6-8e73-c3592ac116c9)  

**Example 3**:
Consider the following matrix:
```
data = [
    1 0 1 0;
    1 1 1 0;
    0 0 0 1;
];
```
The output would be this:
![{5D3C4B0D-5466-47FE-A705-A7AC706B5474}](https://github.com/user-attachments/assets/1897dea0-3b29-4232-b01b-4e89a3b790b6)  
Apparently, you can combine with `ImageProcessor.customSorting` to auto sort the `data` matrix (using `ImageProcessor.customSorting(data, "rc", [1 0])`) by rows and columns into this:
```
     1     1     1     0
     1     1     0     0
     1     0     0     0
```
### 2. `partitionDecomposition`
Main Usage: This function generates all possible matrices that match the same partition structure.  
Recommendation: set the 2nd parameter into `true`. Explained below:
- 1st parameter (required) - partition: the partition (1D) structure you wanna decompose into all possible matrices
- 2nd parameter (optional) - binary: set it into `true` if you want binary matrices instead of numeric matrices. This helps reduce the amount of data used for constructing the matrices. 
#### **Example 1**:  
Consider this code:
```
data = [2 4 3 4];
tmp = ImageProcessor.partitionDecomposition(data);
disp(tmp);
return;
```
This will output multiple 2D matrices, where each one follows the partition structure but with different arrangements:  
```
(:,:,1) =

     1     1     1     0
     1     1     1     1


(:,:,2) =

     1     1     0     1
     1     1     1     1


(:,:,3) =

     1     0     1     1
     1     1     1     1


(:,:,4) =

     0     1     1     1
     1     1     1     1

>>
```
Each `(:,:,i)` represents a different valid matrix that satisfies the given partition `[2 4 3 4]`.  
#### **Example 2**:  
![{563EF65F-5C19-4DA2-A380-534016B4FFCB}](https://github.com/user-attachments/assets/0285a38e-a844-4ee2-84ad-eb9dd128bf4b)  
#### **Eample 3** (with time lapse):  
![{D02D2C62-4075-4559-A593-BBAAF5AF5675}](https://github.com/user-attachments/assets/d57b0ba2-2215-4184-b2c8-667253f73107)

