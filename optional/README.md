# FUNCTIONS-CODES.pdf

## BP(A)
- Input:
  - Binary matrix: 2D
- Output:
  - Partition (contains the original size of the binary matrix): 1D
- Explanation: The function BP(A) processes a binary matrix by sorting each row and each column, counting the number of ones in each row, and then storing the count in a partition vector. The partition vector represents the number of ones in each row. An alternative approach is to count the number of ones in each row first, and then sort them in descending order. Both approaches produce the same result.
- Example code:
  ```matlab
  data = [
    1 1 1 0;
    0 1 0 1;
    0 1 0 0
  ];
  disp(ImageProcessor.BP(data));
  ```
- Run the code:  
  ```
  >> 
     3     4     3     2     1
  ```
- To visualize the sorting process:
  Here, the first value (`3`) stands for the height of the original matrix and the second value (`4`) stands for the width of the original matrix. Followed by that is the partition `[3 2 1]`. You can check the sorted `data` matrix with `disp(ImageProcessor.customSorting(data,"rc",[1 0]));` though the actual code of this function is different.
  - Sorted Matrix Output:
    ```
    >> 
       1     1     1     0
       1     1     0     0
       1     0     0     0
    ```

## PC(lambda, G, order)

- **Explanation:**  
Think of this function as a derivation of `BP(A)`. The parameters `lambda` and `order` are used to construct the `data` matrix (whose structure is unknown initially). Then, we extract the colors from `data` based on the provided `G`. Finally, we sort and count, similar to `BP(A)`.

- **Input:**
  - `lambda` (1D): Contains the lengths of each row of the matrix to be constructed.
  - `G` (string or charArray): Specifies the colors to extract (e.g., `"RB"` means extracting only red and blue colors from the matrix).
  - `order` (2D): A matrix that will be replicated to match the sizes indicated by `lambda`.

- **Output:**  
  Colored partitions (after extracting and counting the specified colors).

- **Example Code:**
    ```matlab
    lambda = [4 2 1];
    order = [
        3 2;
        2 1;
    ];
    disp(ImageProcessor.PC(lambda, "RB", order));
    ```

- **Explanation of Example:**

  - In this example, `3` stands for blue, `2` stands for green, and `1` stands for red.  
  - The `order` matrix will be replicated according to `lambda` to match the row sizes. Here’s how `order` looks after replication:
  
    ```
    3 2 3 2 3 2 3 2...
    2 1 2 1 2 1 ...
    3 2 3 2 ...
    2 1 2 1 2 1 ...
    ...
    ```

  - Now, we cut the rows according to `lambda` to get the following structure:
    ```
    3 2 3 2
    2 1
    3
    ```

  - We then extract the red and blue colors since `G = "RB"`. The extracted values are:
    ```
    1 0 1 0
    0 1
    1
    ```

  - Finally, we apply the `BP(A)` function to get the `coloredPartition`, which is the output without the size of the constructed matrix.

- **Run the Code:**
  ```
  >> script
    Warning: lambda shouldn't contain the sizes of the matrix
         2     1     1
  ```
  To disable the warning, put 'false' in the 4th parameter (after `order`).

## IC1(A, G, order)

- **Input:**
  - `A` (2D): A 2D matrix (e.g., an image matrix or any numerical matrix).
  - `G` (string or charArray): Specifies the sorting order of the channels (similar to the `G` parameter in the `PC` function). For example, "RB" would mean sorting by Red first, then Blue, and "BR" would mean sorting by Blue first, then Red.
  - `order` (2D): A matrix that specifies the color channels. It's similar to `order` in `PC` function.

- **Output:**  
  - **Filtered Matrices:** The function sorts the matrix `A` based on the channel order specified in `G` and `order`. It tracks the corresponding entries' positions during the sorting process and applies those changes to `A`.

- **Explanation:**
  1. **Matrix Sorting by Channel Order:** The `IC1` function takes an input matrix `A` and sorts it according to the channel order specified in `G` and `order`. For example, if `G = "RB"` (meaning `order = [1 3 2]` in `customSorting`), the matrix `A` will be sorted first by the Red channel, then Blue, and lastly by Green. If `G = "GR"`(meaning `order = [2 1 3]` in `customSorting`), it will sort by Green, then Red, and then Blue.
  
  2. **Tracking Indices:** The function keeps track of the indices during sorting, so that after sorting, it can correctly reapply the changes to the original matrix `A`.

  3. **Custom Sorting:** To see how the sorting works, you can track the row and column indices of `order` using the `customSorting` function. Here's an example:
    ```matlab
    [data, rows, cols] = ImageProcessor.customSorting(order,"rc",[1 3 2]);
    disp(cols + "," + rows);
    ```

  4. **Sorted Output Example:**  
     If the `order` is `[3 2; 2 1]` (2D matrix) and the 3rd parameter of the `customSorting` function is `[1 3 2]` (meaning "R < B < G"), the output looks like this:
     ```matlab
     >> script
        "2,2"    "1,2"
        "1,1"    "2,1"
      
     Sorted order:
          1     2
          3     2
     ```
     The `IC1` function uses these row and column indices to apply the sorting to the matrix `A`.

- **Example Code + Explanation:**
    ```matlab
    A = [
        1 2 3 4;
        5 6 7 8;
        9 10 11 12;
        13 14 15 16;
    ];
    order = [
        3 2;
        2 1;
    ];
    disp(ImageProcessor.IC1(A, "RB", order));
    ```

- **Explanation of Example:**  
   In this example:
   - `3` stands for Blue (B), `2` stands for Green (G), and `1` stands for Red (R).  
   - The string `"RB"` means Red is sorted first, followed by Blue, and then Green (not explicitly). So, the sorting process will rearrange the elements based on the order.

- **Run the Code (Output of `disp(ImageProcessor.IC1(A, "RB", order));`):**
    ```matlab
    >> script
        6     2     8     4
        1     5     3     7
        14    10    16    12
        9     13    11    15
    ```

## IC2(image, G, order)
- Input (3D): an image with red, green, and blue channels
- Output (3D): a filtered image with red, green, and blue channels (sorted based on GBR, BGR, etc, and the corresponding entries sorted at the same time).
- Example code:
  ```matlab
  image = ImageProcessor.readImage('test.png');
  order = [
      3 2;
      2 1
  ];
  output = ImageProcessor.IC2(image,"RB",order);
  ImageProcessor.showImage(output);
  ```
- Run the code:  
  ![{5B9BA0E2-804D-4AFF-AB8D-40B4D9BB4452}](https://private-user-images.githubusercontent.com/179333283/423690629-9c8cec0a-c268-4b13-9d48-12963bd0b8bf.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNjkwNjI5LTljOGNlYzBhLWMyNjgtNGIxMy05ZDQ4LTEyOTYzYmQwYjhiZi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT04MzllODg5YjA1YmM2NjY3MTg3NTdhMTIwM2E1ODY0ODYxYTMyYjM0ZjBjY2Q0NjE0YzcyZDBmNDFkYWIyM2Y2JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.Ne8Tzz4tdAuByJ61TdxoPKjmebj0K8pu2RfKcYmTm0c)  
- Explanation: Think of this like an enhanced version of `IC1` that works for 3D instead of 2D. It keeps all 3 channels as it swapping the values. Let's say the `image` can be represented like this:
  ```matlab
  [
    A(1,1,:) A(1,2,:);
    A(2,1,:) A(2,2,:)
  ];
  ```
  If the indices are
  ```
        "2,2"    "1,2"
        "1,1"    "2,1"
  ```
  , the function `IC2` will swap the entries like this:
  ```matlab
  [
    A(2,2,:) A(1,2,:);
    A(1,1,:) A(2,1,:)
  ];
  ```

## Bayer1(image, G, order)
- Input (3D):
  - Image (or binary image, 3D): an image with red, green, and blue channels
  - G (string or charArray): similar to `IC2` and `IC1`
  - order (2D): similar to `IC2` and `IC1`
- Output (2D): filtered matrix
- Explanation: It functions similar to `IC2` except it will only pick one channel to represent on the gray scale. Let's say the `image` can be represented like this:
  ```matlab
  [
    A(1,1,1:3) A(1,2,1:3);
    A(2,1,1:3) A(2,2,1:3)
  ];
  ```
  If the indices after sorting are
  ```
        "2,2"    "1,2"
        "1,1"    "2,1"
  ```
  and the order sorted (the input order doesn't have to be sorted) in the order of "RB" is
  ```
     Sorted order:
          1     2
          3     2
  ```
  , the function `IC2` will pick the entries like this:
  ```matlab
  [
    A(2,2,1) A(1,2,2);
    A(1,1,3) A(2,1,2)
  ];
  ```  
- Example code:  
  ```matlab
  image = ImageProcessor.readImage('test.png');
  order = [
      3 2;
      2 1
  ];
  output = ImageProcessor.Bayer1(image,"RB",order);
  ImageProcessor.showImage(output);
  ```
- Run the code:  
  ![{E5F123A2-BC6C-4F87-A5CE-7EEE3BFFEB3A}](https://private-user-images.githubusercontent.com/179333283/423701430-40ad3e33-cc9c-4050-83f4-1c618831bf7b.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzAxNDMwLTQwYWQzZTMzLWNjOWMtNDA1MC04M2Y0LTFjNjE4ODMxYmY3Yi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1iNGFjNDllZDBhMTgxMDE5OTE2NTEwM2QyZTBlYjg5Zjg0MTYzMjM0ZTU1MzhhMzRkZGQxYzk1YWYwMTdjNTkzJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.GpITmszhxHE9LUsuUIxCVeJcG8nqtQrTKxJWN3t-T9c)

## Bayer2(image, G, order)
- Input (3D):
  - `image` (3D): an image (or binary image) with red, green, and blue channels.
  - `G` (string or charArray): similar to `G` in `IC1` and `IC2` functions.
  - `order` (2D): similar to `order` in `IC1` and `IC2` functions.
- Output (3D): a filtered image with red, green, and blue channel.
- Explanation: similar to `Bayer1` function but instead of producing gray image, it erases other colors and only keep the color based on the sorted `order` (which doesn't have to be sorted as input).
- Example: Pick the same example in `Bayer1` explanation. Instead of this output
  ```matlab
  [
    A(2,2,1) A(1,2,2);
    A(1,1,3) A(2,1,2)
  ];
  ```
  , it will have this output:
  ```matlab
  [
    [A(2,2,1), 0, 0] [0, A(1,2,2), 0];
    [0, 0, A(1,1,3)] [0, A(2,1,2), 0]
  ];
  ```
- Example code:
  ```matlab
  order = [
      3 2 2 1;
      2 1 3 3;
      2 3 1 2;
      3 3 1 1
  ];
  image = ImageProcessor.readImage('test.png');
  imshow(ImageProcessor.Bayer2(image,"RBG",order));
  ```
- Run the code:  
  ![{E00ACA93-416A-401F-8015-4878DB7E3892}](https://private-user-images.githubusercontent.com/179333283/424498976-c996b159-844a-4963-8bc1-1c3a887a1707.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDI0NDk4OTc2LWM5OTZiMTU5LTg0NGEtNDk2My04YmMxLTFjM2E4ODdhMTcwNy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mOGRmM2JkMTc0NDY2MzYzYmQ4ZDMzYmUyNzY3MGM0ODZmNWJkOTE3MjM5NDIwZDBiZWM0ZWRiOTI3ZDJjOGJiJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.Wk_cmY3tg-Ycy4YtkDpWAWIswOlHERVjkNnou3uuOeU)  

## Dilation1, Erosion1, Opening1, Closing1 (binaryMatrix1, binaryMatrix2)
- Notes: Some books have different definition of erosion function though most of their functions of dilation are commutative. I keep the traditional erosion and dilation functions as many book described in `Erosion1` and `Dilation1`, respectively. Hence, only `Dilation1` is commutative.
- Input:
  - binaryMatrix1 (2D or 3D logical): an image with or without red, green, and blue channels.
  - binaryMatrix2 (2D or 3D logical): a kernel with or without red, green, and blue channels.
- Output:
  - Logical 2D (gray) or 3D (rgb) image.
- Explanation. When applying `Dilation1` and `Erosion1`, it will scale the values (logical values) by multiplying the values inside the kernel and then find `max` and `min`, respectively. In the case of `Erosion1`, if any "0" is encountered in the kernel, it simply ignores that part and does not reduce the center value to "0". This means that the center pixel value will be preserved as long as there are enough "1"s in the region to meet the kernel’s size, effectively only removing noise or small interruptions in the foreground, adding additional flexibility to the function.
- Example: Consider the binary matrices of `test.png` and `test2.png` (downloaded the images):
  ```matlab
  image = ImageProcessor.readImage('test.png');
  image2 = ImageProcessor.readImage('test2.png');
  image2 = image2(230:235,230:235,:);
  image = image > 100;
  image2 = image2 > 100;
  ```
  - I used `imshow(uint8(image) * 255);` to show the image:  
  ![{7ABCE2D5-D49C-4DA8-9E40-2E58CACD13D0}](https://private-user-images.githubusercontent.com/179333283/423710265-b87f9b0e-588d-4ee9-8a11-7252f3622684.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzEwMjY1LWI4N2Y5YjBlLTU4OGQtNGVlOS04YTExLTcyNTJmMzYyMjY4NC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hY2U1NjYyNGY2NGI2YTlkOTY4MmE3ODJjNTllOWYxMDA0NTRiNWMzZDIxNzg0YWJiMWVjM2U5YTc1Yzk3Njg4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.GNnjhcGQyp5Zl45f9QGkSrK30Q2jhNMg7LnKsZC4K4o)  
  - Same thing goes for image2:  
  ![{15C73C8D-005E-463D-9FD2-E8C506C2BD8B}](https://private-user-images.githubusercontent.com/179333283/423710672-17ccaf34-ae27-4ecf-8c7e-f0763ce9cca7.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzEwNjcyLTE3Y2NhZjM0LWFlMjctNGVjZi04YzdlLWYwNzYzY2U5Y2NhNy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kNTkyZDk2OTQ2NTA2NTZlMjY5YTJmZTg0MDM5MTVjMjYzNjcxNmJjYzgxMjNmODFmOWVkYjdiZGQ2ZjI5ZGI5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.5HbMhodJOG6T1GrBGbEYPgVivgU7qI33-SUbTiMdRUo)  
  - I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion1`:
    ```matlab
    output = ImageProcessor.Erosion1(image,image2);
    imshow(output);
    ```  
  - The output is like this:  
    ![{67D74618-8800-4307-9F3F-DC83350AC4E1}](https://private-user-images.githubusercontent.com/179333283/423711411-57a8d9c2-77ab-47d0-9b0d-039b913ed7c6.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzExNDExLTU3YThkOWMyLTc3YWItNDdkMC05YjBkLTAzOWI5MTNlZDdjNi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kODdjNDVmMmQyYTQwMDQ2OTE0YjFmODIwN2Y0ZTk3MTFkZGRmZTNiZTNiN2VjZDFhNDdmMjJlM2NjOTQxMDkyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.wCxgQHgTKbXJsw7dIcA2dlpE4DJFDYh0yhvnrI3FFFw)  
  - I tried with Dilation1, Opening1, and Closing1 respectively:  
    ![{B99D868B-E78F-4281-8C07-93736746A745}](https://private-user-images.githubusercontent.com/179333283/423711697-ba115749-bdfb-4307-bd36-f49e63da4f50.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzExNjk3LWJhMTE1NzQ5LWJkZmItNDMwNy1iZDM2LWY0OWU2M2RhNGY1MC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT02Nzc4NmZkMTA2OGQxNDJlZTM1YzI2NjQyYjJkN2ZiNTkxNDRmNzJiZTc0Mjg0YWYyNzViNjZmZWQ0N2QzODBjJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.JJHEHmS4rxSNLqPNkUU7YuC8PBlhTff0UtW8_k4FUBA)  
    ![{541CA048-BFAB-43B4-A79A-C3A40FD97550}](https://private-user-images.githubusercontent.com/179333283/423711846-1e381d0a-ccd0-48bb-8f20-f270ff430b69.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzExODQ2LTFlMzgxZDBhLWNjZDAtNDhiYi04ZjIwLWYyNzBmZjQzMGI2OS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jMGRhNGYzOTk2MTlhYTBlZWMyOTUwY2FhYjhjN2JhYmZlY2VhMmU0NmUzOWNhOGU1NzI4Yzc0ZmM3MzZiNTg1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.6jW8zvim6q1JPVTKcxCCxhpKmmABca78oKWut5MmVkc)  
    ![{5E195FDB-AD2B-4068-B312-1E8912D7B8C0}](https://private-user-images.githubusercontent.com/179333283/423712005-db1c5a0c-4d35-4f0e-8e78-cc498a9a7368.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzEyMDA1LWRiMWM1YTBjLTRkMzUtNGYwZS04ZTc4LWNjNDk4YTlhNzM2OC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hMWZlNjJmYmZkY2YyMzdkNjJmNjc1MTgzN2NmNTI5ZjljZDRkNzU2NTlhMmJmZDk4ODQ3MTkzZDI0ZThmYTRmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.GvYub5SvJN0mo7r9978d2NOhps_zQ24IUk3wKOxDpoc)  
    - It's recommend to have smaller size of `image2` (ideally 5 to 35). Swapping the input position results in the same output image (only for dilation function):    
      ![{C40E3C47-5960-47BB-A05F-01140E2E3C30}](https://private-user-images.githubusercontent.com/179333283/423779956-16518dae-74f4-4d3f-95a5-17b880a633df.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzc5OTU2LTE2NTE4ZGFlLTc0ZjQtNGQzZi05NWE1LTE3Yjg4MGE2MzNkZi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zOGJhMjNjYzFjOTIwNzMwMDYwMzU0NGY1ZTNiYzJmYzNkMWMzNTg5OGI2OTJmMjMxNzM2NmQ4ODZmOGQ2MzMyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.HW0LCZl7IXckqmgMWyM5Wy3DFypbAmoMI0qenEZFZug)  
      ![{3CB73E92-8936-4F7C-98CB-FE8F9FC5E521}](https://private-user-images.githubusercontent.com/179333283/423780116-c44ec77c-894c-4382-8956-0cac16e04cc5.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzgwMTE2LWM0NGVjNzdjLTg5NGMtNDM4Mi04OTU2LTBjYWMxNmUwNGNjNS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zMDZiNmJhODM5NWQ5ZGI1MzgwMTRhYTJjNDYyYTMyYTkwMGVmZDViNTNkODJmYjBiZDFkN2FiNGYyYjA1OTZlJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.fbwpzDz2SCp65c5QxxMFYMFK6lZtCRt1nVAT52JO0vM)  
      ![{83643EB6-3FA3-4DFE-8193-664B6521D73D}](https://private-user-images.githubusercontent.com/179333283/423781112-e910e18f-ae29-4f8c-a3b8-7f0c233d004e.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzgxMTEyLWU5MTBlMThmLWFlMjktNGY4Yy1hM2I4LTdmMGMyMzNkMDA0ZS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zZWU2ZDRmMDBkNzIxNTJmOTg4YTk1ZDBhODk4YjE0ZmZjNTJkNWIxZGM3NzUyYmRjNWIyYmI5YmU2OTJhNDE1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.YNrNiLZaibNEQDviG1LoK6id35q1RN73N3NJJwfSnkQ)  
      ![{60B3C1E7-CEC7-469C-B71E-069EB4F7E830}](https://private-user-images.githubusercontent.com/179333283/423782393-800b2c12-a578-4b40-8a6c-9a9d8897a32d.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzgyMzkzLTgwMGIyYzEyLWE1NzgtNGI0MC04YTZjLTlhOWQ4ODk3YTMyZC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1iZTI3YjYzMTRjN2Q3ODU3ODJkN2JjYTBmYTBlMmIyNDUxODYxNTZmNDA4OGQwMThhOGI1ZDEwYjM4ZmIxNjhhJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.N2iCeL1onsAENhC7iMOXocMiohTKPR57563Gwklx7o8)  
  
  - An example of applying 2D binary matrices as inputs:  
    - `image` =  
  ![{45231E59-FDB2-4AAA-B240-A97CBB56902E}](https://private-user-images.githubusercontent.com/179333283/423716186-4f476b09-2cf9-4002-b99b-6d74636e7bb6.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE2MTg2LTRmNDc2YjA5LTJjZjktNDAwMi1iOTliLTZkNzQ2MzZlN2JiNi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT01MDViZDk0MzVmYTlhZDEyNDU5ZmVhNTU4MzNjMjIzYjc2YWE2MTQxY2NlOThhMmRiNjFhZTA2ZmJlMzA3YjBiJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.v6WrnjHCovuBLuqgfmMv_0sOKwcvOocuV5Yyrztpsfs)  
    - `image2` =  
  ![{742CCC11-EEF9-4A5F-A291-EF20376FECE0}](https://private-user-images.githubusercontent.com/179333283/423716316-dc8d838e-d6f9-403d-aeb0-d82a6b40b773.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE2MzE2LWRjOGQ4MzhlLWQ2ZjktNDAzZC1hZWIwLWQ4MmE2YjQwYjc3My5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yZTdkNmRlNDFmOTEzNmE4MDhjMTVjOGE4YmMyYTViYmNkZGE2NjliNTNhZWNiODc4N2Y3MWYyYWYzMTM4Yzk5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.giue3pyCaXYrSw6KX_jJxk5BTNIUybQgcTQ5Fgbk39A)  
    - `output` =  
  ![{670A86FF-918B-4EF0-9E8F-5D0D659B15D7}](https://private-user-images.githubusercontent.com/179333283/423716428-aad91a6f-780f-44cf-85aa-cbdb3c197f23.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE2NDI4LWFhZDkxYTZmLTc4MGYtNDRjZi04NWFhLWNiZGIzYzE5N2YyMy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kYzE3MmQ0ODI0MzE1ZWY2ZWRjOWM1ZWFiNjI2YWFhOWY2NzI0MTFmOTFiM2NhZTJjOTk4MjQ1NDNmODU5Mjc3JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.xkICHqaMhZYtueY0RYtBuZP9MOURWqlcfpJaLHo2nts)
  
## Dilation2, Erosion2, Opening2, Closing2 (binaryMatrix1, binaryMatrix2)
- Input:
  - binaryMatrix1 (2D or 3D logical): an image with or without red, green, and blue channels.
  - binaryMatrix2 (2D or 3D logical): a kernel with or without red, green, and blue channels.
- Output:
  - Logical 2D (gray) or 3D (rgb) image.
- Explanation. When applying `Dilation2` and `Erosion2`, it will scale the values (colored or gray values) by multiplying the values inside the kernel and then find `max` and `min`, respectively.
- Example: Consider the binary matrices of `test.png` and `test2.png` (downloaded the images):
  ```matlab
  image = ImageProcessor.readImage('test.png');
  image2 = ImageProcessor.readImage('test2.png');
  image2 = image2(230:235,230:235,:);
  ```
  - I used `imshow(image);` to show the image:  
  ![{5334DE9F-F56B-461A-8A9F-60EB776444AE}](https://private-user-images.githubusercontent.com/179333283/423716785-79579b7e-c97b-4cd6-bc30-34acd2153da3.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE2Nzg1LTc5NTc5YjdlLWM5N2ItNGNkNi1iYzMwLTM0YWNkMjE1M2RhMy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kMDhmMjcyN2FiNDcwYzg5NGM5OWMzZWFlYzkyZjkxNzAyYzZiYTI1NmVjMTY2YjFkMDRkMDRmOTQ0YWZhZjc4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.RphwtVxsXt-9tvsEMSGtBJeJdM-19s95I095YqvmWUw)  
  - Same thing goes for image2:  
  ![{9C13C4B2-ACD4-4D8B-9944-18DAB2370919}](https://private-user-images.githubusercontent.com/179333283/423716857-8d931f6b-08c9-4fc5-9d21-b96644b64084.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE2ODU3LThkOTMxZjZiLTA4YzktNGZjNS05ZDIxLWI5NjY0NGI2NDA4NC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kMzFiM2ZjM2EyZDJmNjU2OTA1YzhhNzIyN2Y1MjliNzQxNGZhODQ0NDkyZDgxNDJlNzY2NWRiNjNmNmFiMWNkJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.pIoQWk3Mg8k7J8VXclK56fgzwVqQTA7NsVrfbvmQHOs)  
  - I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion2`:
    ```matlab
    output = ImageProcessor.Erosion2(image,image2);
    imshow(output);
    ```  
  - The output is like this:  
  ![{1ED3106D-9CF6-4EED-80AC-3CC55BBD884D}](https://private-user-images.githubusercontent.com/179333283/423716942-059abf02-e842-40fe-b5a2-17afcb41df2a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE2OTQyLTA1OWFiZjAyLWU4NDItNDBmZS1iNWEyLTE3YWZjYjQxZGYyYS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT03MzI0NDBkMDRkMDljYjRkOTk5NTk1YmRjODJlZDIyNDNmZTM0M2U2OTFlNWRlNzYwYTBkM2Q3MDI3NzRlMjNhJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.rjL-FDGlearScFHFVfAaskMUIMisvOoO4FJe6Ty1KT0)  
  - I tried with Dilation2, Opening2, and Closing2 respectively:  
  ![{DD04683F-FD41-4A38-90A1-19F021958589}](https://private-user-images.githubusercontent.com/179333283/423717073-fc85a739-e66d-47d7-9422-c388a18e05c3.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE3MDczLWZjODVhNzM5LWU2NmQtNDdkNy05NDIyLWMzODhhMThlMDVjMy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT03ZjRkMGE3MTgxZmRmYWI5MjNmNGYwMzBkNDBiZmIzNWI4M2I0ODExZTQxZTM3Nzc3YWUxZWUyMDE4YjY1ODQ2JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.jgmW6fFMCxtHwJDaFA7mQo2VVIW1ZDUwO6__4KBt1B0)  
  ![{66DA5B83-6D0B-4E07-A60B-35A41044C6FC}](https://private-user-images.githubusercontent.com/179333283/423717174-6fa8f52b-8b8e-459b-a7b3-f23356babb29.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE3MTc0LTZmYThmNTJiLThiOGUtNDU5Yi1hN2IzLWYyMzM1NmJhYmIyOS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1lODEzMzA2NjZmZGEzOWUzM2IyYzExN2E3MzVjZjI2MWQ1MThmMGM5NzBiY2NiYWE0NDhkY2VhNjQyNDI0MzEyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9._YwA_2krwXMPi2ZIA_BMmpUfESkHoOjsa_KRwNF6NIQ)  
  ![{21F5E61E-380C-41DF-A713-EE63BE25A0FE}](https://private-user-images.githubusercontent.com/179333283/423717304-d16940a8-70b9-4204-b2fc-3674788a0aea.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE3MzA0LWQxNjk0MGE4LTcwYjktNDIwNC1iMmZjLTM2NzQ3ODhhMGFlYS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1lMmRlNTNkNTdkMTQxZjlkMzBiNjg0OTY4MTBkNTdhODk2OTA5MGI1Zjc3ODg5ODUyMTc1MWM2ZDM0NjY1YTE1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.ATZHUdPrwlTWjZ2Pj5wTNkEe1Fil-NspdE1yMN6ttNY)  
    - If I swap the input position of `image` and `image2` (`image` becoming 2nd parameter and `image2` becoming 1st parameter), the program stucks forever due to the larger mask being applied in the calculation. It's recommend to have smaller size of `image2` (ideally 5 to 35). Swapping the input position doesn't results in the output image being flipped up-side-down, left-to-right, or identical image compared to the original output. However (fun fact), applying Bayer filter seems to make the outputs very identical. In fact, if you flip the image up-side-down and left-to-right, it looks almost the same:  
    ![{10A3ED5F-C358-4CF9-ABC4-987CC81FF38F}](https://private-user-images.githubusercontent.com/179333283/423720710-99e9b567-5603-460b-b313-25e06f7d3613.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzIwNzEwLTk5ZTliNTY3LTU2MDMtNDYwYi1iMzEzLTI1ZTA2ZjdkMzYxMy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mNmQ0NzM3YjhjODc4NmRkYTA5ZTM3NzgwZGU1Y2RiMDliNTkyYTIwMWI3MmM3ZjJlNDhiMmEzZWY1ODU0NDQ4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.uexm1wDAbUQVchSUVwD40mLpQdSjLvTHjKcnshBCTfA)  
    ![{F3449905-059C-43AF-B5A1-648F653C771B}](https://private-user-images.githubusercontent.com/179333283/423720801-a5522c27-722a-46e6-9093-b746ee7436aa.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzIwODAxLWE1NTIyYzI3LTcyMmEtNDZlNi05MDkzLWI3NDZlZTc0MzZhYS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kMDhhOTAwYTliZThmOWRhNzVjYmMwZWNmZTIxZDU2YmU2ZjJjYjAyYjVkOTkxYTZjZTE1YmNiNGViNDdkODlmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.iLOPxw809Key3ZWNTOypN8pEHzX8IVRR5jdJt0soe1Q)  
  - An example of applying 2D binary matrices as inputs:  
    - `image` =  
  ![{3BC14EFE-9688-499C-A05F-D0EDA888D444}](https://private-user-images.githubusercontent.com/179333283/423718818-1b1d0a09-582a-4859-867b-96bdedfe6679.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE4ODE4LTFiMWQwYTA5LTU4MmEtNDg1OS04NjdiLTk2YmRlZGZlNjY3OS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kZWRlMDRhZTY2NzU5MjVlNGJiMmM2NjdmNzk2NTFhYjYyNzRiMjUwYTM3NTRlNjdhZDkxMzM3OWJmYTA0Y2Y4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.3zYKJ2obEcbswLuAr6I8Tu36Npsnrm-xBor9fryMRrc)  
    - `image2` =  
  ![{BE12C0BB-22E1-4B8D-92AD-998610501BB6}](https://private-user-images.githubusercontent.com/179333283/423718980-62345f1f-0fa3-47e9-89eb-3e4b3b02c301.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE4OTgwLTYyMzQ1ZjFmLTBmYTMtNDdlOS04OWViLTNlNGIzYjAyYzMwMS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hMGU2MWEwMTk3MTZlMTYxNmI0YjExNjU5MzNlYWJmOGI4YWI4ODM3YjVjZDkyYjdiMzBmNjAzNzBhZTg2MzcxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.f0XkFvA7U2kNUT1NFPlIt_mau9tlHEedgiM9fDh88ts)  
    - `output` =  
  ![{5EAF7C85-D2C5-4FBD-9F65-0341703D94C7}](https://private-user-images.githubusercontent.com/179333283/423719087-4d37f91f-75d1-4534-a60f-3ef5b8fb28d6.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDIzNzE5MDg3LTRkMzdmOTFmLTc1ZDEtNDUzNC1hNjBmLTNlZjViOGZiMjhkNi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT02OWMwMzMzYWIxMjhjYzllZGY2MmFhYjY0NTQxYjc0M2U5NDRmNjk3MTc2YWE2ZmNkYWJlYTc1MTFjMWI0MzZkJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.ZFGvedO5ymGBcRuVVkXutYuRFS8jCzL3DId72G0oY2E)

## PPP1(partition1, partition2)
- Input:
  - Partition 1 (1D): 1D array that contains the coefficients of the first polynomial.
  - Partition 2 (1D): similar to partition1.
- Output: 1D array that contains the coefficients of the product of the 2 polynomials.
- Example code:
  ```matlab
  partition1 = [1 2 3 4];
  partition2 = [1 3 2 1];
  disp(ImageProcessor.PPP1(partition1, partition2));
  ```
- Run the code:
  ```
  >> 
     1     5    11    18    20    11     4
  ```
- Another example code:
  ```matlab
  tic;
  partition1 = 1:1000000;
  partition2 = 1:1000000;
  ImageProcessor.PPP1(partition1, partition2);
  elapsedTime = toc;
  fprintf('Elapsed time: %.6f seconds\n', elapsedTime);
  ```
- Run the code:
  ```
  >> 
  Elapsed time: 25.461543 seconds
  ```
  Even without using NTT, the code runs very fast thanks to built-in function `conv`.

## PPP2(partition1, partition2)
- Input:  
  - Partition 1 (1D): sorted 1D array.  
  - Partition 2 (1D): similar to partition1.  
- Output:  
  - A **sorted 1D array** representing the **merged** partition of `partition1` and `partition2` using the special operation **'⊔'**.  

- Explanation of the '⊔' Operation:
  - The **'⊔' operation** constructs a new partition by taking the **multiset union** of the elements from `partition1` and `partition2`. After merging, the resulting partition is **reordered** in **weakly decreasing** order.
  - Example:  
    Given **μ = (3,3,2,1)** and **ν = (4,1,1)**, the resulting partition is:  **μ ⊔ ν = (4,3,3,2,1,1,1)**  
- Example code:
  ```matlab
  tic;
  partition1 = 50000000:-1:1;
  partition2 = 50000000:-1:1;
  ImageProcessor.PPP2(partition1,partition2);
  elapsedTime = toc;
  disp(elapsedTime);
  ```
- Run the code:
  ```
  >> 
    1.6179
  ```

- Another example code:
  ```matlab
  partition1 = [6 4 2];
  partition2 = [8 5 3 1];
  disp(ImageProcessor.PPP2(partition1,partition2));
  ```
- Run the code:
  ```
  >> 
     8     6     5     4     3     2     1
  ```

## EXTRA.DILATION(binaryMatrix1, binaryMatrix2)

### Input:
- `binaryMatrix1` (2D or 3D logical): A binary image, with or without color channels (RGB).
- `binaryMatrix2` (2D or 3D logical): A binary structuring element (kernel), also with or without color channels.

### Output:
- A **logical** 2D (grayscale) or 3D (RGB) **image** after dilation.

### Explanation:
Dilation in matrix form is a well-known operation, but before applying it, we introduce a **special function** (called **MatrixDecomposition**) that transforms the input matrices. This function modifies both `A` and `B`, and apply **standard dilation** (as defined in most image processing books) to the transformed versions.

### MatrixDecomposition Transformation
MatrixDecomposition works as follows (the actual code has different workflow that works in matrix-based dilation instead of set-based dilation):

1. **Extract the coordinates** of all `1` values in the matrix and represent them as ordered pairs `(x, y)`. The first coordinate always starts at `[0,0]` (zero-based index).
   - Example: Given the matrix `A`:
     ```matlab
     A = [
       1 1 0 0;
       0 1 0 1
     ];
     ```
     The extracted set of coordinates is `{[0,0], [0,1], [1,1], [1,3]}`.

2. **Compute a new transformed set** satisfying:  
{(a,b) + (c,d) + ... | (a,b), (c,d), ... ∈ A and (a,b) ≠ (c,d) ≠ ...}
where `...` can be empty or multiple elements of `A`.

3. **Convert this transformed set back into a matrix** representation.

### Comparison Between Set-Based and Matrix-Based Dilation

#### Set-Based Dilation:
In set notation, the **dilation of two sets** `A` and `B` is defined as:  
A ⊕ B = { (a,b) + (c,d) | (a,b) ∈ A, (c,d) ∈ B }  
For every point `(a,b)` in `A`, we add all points `(c,d)` from `B` to generate the dilated result.

#### Matrix-Based Dilation (Efficient Form):
- Instead of iterating over sets, **matrix dilation** is efficiently computed using **convolution operations** or **max filtering**, where a **structuring element (kernel)** is applied to the binary image.
- **MatrixDecomposition as Multiple Dilations**: We can think of the **MatrixDecomposition** as a series of dilations for each element in the set, where the dilation operator ⊕ applies to each element in the set 𝐴. For each element, we consider the set that contains the coordinate [0,0] (the first coordinate) and the element itself so that ⊕ can be applied. The special function then becomes the **Riemann Dilation sum** of these dilations (like how `+` has **Riemann sum**, ⊕ has **Riemann Dilation sum**). Consider this example:
  - Example: Generating Subsets Using Dilation
  
    Consider a set  
    **A = {a, b, c}**  
    Normally, we could generate subsets by toggling bits (e.g., using binary representation), but instead, we use the **dilation operator** (⊕):
  
    - Step 1: Start with the Base Set  
      S₀ = {[0,0]}  
    This represents the empty set as a starting point.
    
    - Step 2: Apply Dilation with Each Element  
    
      - First dilation with element a:  
      S₁ = S₀ ⊕ {[0,0], a} = {[0,0], a}  
    
      - Second dilation with element b:  
      S₂ = S₁ ⊕ {[0,0], b} = {[0,0], a, b, a+b}
    
      - Third dilation with element c:  
      S₃ = S₂ ⊕ {[0,0], c} = {[0,0], a, b, c, a+b, a+c, b+c, a+b+c}
  
    - **Resulting Set:**  
    After three dilations, we have generated all possible subsets of A, mimicking how binary toggling would work.  

- Effects: This **reduces computation time** from `O(2^(|A|))` (where `|A|` is the length of set A or the number of `1`s of matrix A) in the set-based approach to `O((max(rows(A)) x max(cols(A)))⁴)` for the `matrixDecomposition` function that transforms the input matrices.
- Recommendation:
  - Use Matrix-Based Dilation when `|A|` is large enough (ideally below 676) and `max(rows(A))` or `max(cols(A))` is not too big.
  - Use Set-Based Dilation (introduced in the below section) when `|A|` is small enough (ideally below 36).  

- Example code:
  ```matlab
  tic;
  B = ImageProcessor.readImage('test.png');
  A = B(200:205,200:205,:) > 160;
  B = B(200:225,200:225,:) > 160;
  t = ImageProcessor.EXTRA.DILATION(B,A);
  imshow(t);
  elapsedTime = toc;
  disp(elapsedTime);
  disp("Size of input image: " + strjoin(arrayfun(@num2str, size(B), 'UniformOutput', false), ' '));
  disp("Size of output image: " + strjoin(arrayfun(@num2str, size(t), 'UniformOutput', false), ' '));
  ```
- Run the code: ![{E86B4DFF-EDAC-4652-B698-685318D7A79E}](https://private-user-images.githubusercontent.com/179333283/425777926-fe38f19a-ce1f-4588-90ef-1d8a075f718f.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDI1Nzc3OTI2LWZlMzhmMTlhLWNlMWYtNDU4OC05MGVmLTFkOGEwNzVmNzE4Zi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT01ZTU5NDZmZjc1Yzk4YTkyMTdlNGI2YjIzMDUxODRlMmI1NTY2MzIyOGI2MzViNmY3ZTVlMTE1MGExMTg1MjRmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.t7wjY94OskboMslPcq97RIXaNCX1SioQQy4C2tjxeWs)  
- Another example code:
  ```matlab
  tic;
  B = ImageProcessor.readImage('test.png');
  A = B(200:205,200:205,:) > 160;
  B = B(200:215,200:215,:) > 160;
  t = ImageProcessor.EXTRA.DILATION(B,A);
  imshow(t);
  elapsedTime = toc;
  disp(elapsedTime);
  disp("Size of input image: " + strjoin(arrayfun(@num2str, size(B), 'UniformOutput', false), ' '));
  disp("Size of output image: " + strjoin(arrayfun(@num2str, size(t), 'UniformOutput', false), ' '));
  ```
- Run the code: ![{BD9875CA-0779-4290-B6A4-7C20D8919CC0}](https://private-user-images.githubusercontent.com/179333283/425777760-5d52c232-d2de-45c4-9a12-3e75d0dd332a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDI1Nzc3NzYwLTVkNTJjMjMyLWQyZGUtNDVjNC05YTEyLTNlNzVkMGRkMzMyYS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1kNzVhMDAzNzU2MTJhZmU5ZWZjMDM5Yjk2YzQ2MWM5YWM1ZDY2YzA3MjI2MTY3NThhOTgxZTNlNmIzZTliMmYxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.qiAECNrt9bTA8Snul66H6NzdctdrP-xHJ5MK5ujvt0U)  
- **Fun fact**: No matter how you twist your input image, if it has enough entries that have value `1`, it will turn into the oval-like form with two pointed ends.
  - Note: I used `matrixDecomposition` here for demonstration. `EXTRA.DILATION` also works with 2D binary matrices.
  - Example:  
    ![{69B45C5E-510D-4A13-B104-0F8992509B0F}](https://private-user-images.githubusercontent.com/179333283/425776632-c5d59428-4abd-4c9a-a3aa-ecb5f28570af.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDI1Nzc2NjMyLWM1ZDU5NDI4LTRhYmQtNGM5YS1hM2FhLWVjYjVmMjg1NzBhZi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0xMDc1YjRjNTYzN2I2MjVhMTRjYWJiZTBhZTVmMGFlZWMzMzFiNTEwNTMwMTg5ZGJjN2Y5Zjk5ZjEyZmRhNWQ3JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.04Yu7zSLhr_n7ZejGOX7IcdNpzwKpdQ_-_vsazijekI)  
    As I increase the number of ones:  
    ![{74BE45FD-6BC5-4A01-A617-D92FBEF43327}](https://private-user-images.githubusercontent.com/179333283/425776727-1a524198-4f0f-43c1-82cc-7a9b0d87921f.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDI1Nzc2NzI3LTFhNTI0MTk4LTRmMGYtNDNjMS04MmNjLTdhOWIwZDg3OTIxZi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1lNjU1NmE0ZGE5MzExOWE3ZDRmNjEwYzc3YWY1ZGEyMmZmMzNmMDE3ZjE0Y2ZjNjJjODc0NTgzYzJhNjBkYzUxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.D62z3RxLCNql0Yyd3VAA-NGRVQRUxeMx1mn-6Ezn2BI)

## EXTRA.DILATIONSET and dilationSet Functions with Added Customized Functions

### 1. **`matrixToCoords(A)`**
   - **Purpose**: This function converts a matrix (like `A`) into a set of coordinates where the value is `1`.
   - **How it works**: The function scans through the matrix, identifying positions with `1`s, and stores these positions as coordinates in a 2D array.
   - **Example**:
     ```matlab
     A = [
       1 1 0 0;
       0 1 0 1
     ];
     coords = ImageProcessor.matrixToCoords(A);
     disp(coords);
     ```
     Output:
     ```
     >> 
     0     0
     0     1
     1     1
     1     3
     ```

### 2. **`coordsToMatrix(B)`**
   - **Purpose**: Takes a set of coordinates (like those generated by `matrixToCoords`) and converts them back into a binary matrix where `1`s are placed at the corresponding positions.
   - **How it works**: It initializes a zero matrix of the appropriate size, then iterates over the list of coordinates, placing `1`s at each position.
   - **Example**:
     ```matlab
     C = [0 0; 0 1; 1 1; 1 3];
     matrix = ImageProcessor.coordsToMatrix(C);
     disp(matrix);
     ```
     Output:
     ```
     >> 
     1     1     0     0
     0     1     0     1
     ```

### 3. **`dilationSet(A, B)`**
   - **Purpose**: Performs the dilation operation between two sets, `A` and `B`. It calculates the set `A ⊕ B = { (a,b) + (c,d) | (a,b) ∈ A, (c,d) ∈ B }`, adding every element of `B` to every element of `A`. 
   - **How it works**: The function expands both sets using `ndgrid`, then adds their coordinates to create a new set of dilated coordinates.
   - **Example**:
     ```matlab
     A = [0 0; 0 1; 1 1; 1 3];  % Example set A
     B = [0 0; 0 1; 1 0];       % Example set B
     C = ImageProcessor.dilationSet(A, B);
     disp(C);
     ```
     Output:
     ```
     >> 
     0     0
     0     1
     0     2
     1     0
     1     1
     1     2
     1     3
     1     4
     2     1
     2     3
     ```

### `EXTRA.DILATIONSET` Function and its Comparison to `EXTRA.DILATION`

The function `EXTRA.DILATIONSET` operates in a way that is conceptually similar to the function `EXTRA.DILATION`. Both of these functions can be considered **homomorphic** (set that has negative coordinates can't be converted into matrix), meaning they perform a similar dilation operation, but on different data structures. The same concept applies to the relationship between `dilationSet` and the **standard dilation on matrices**.

- **Important Note**: Unlike `EXTRA.DILATION`, which is designed to handle dilation on matrices of various dimensions, **`EXTRA.DILATIONSET`** is specifically optimized for working with 2D logical matrices in the **set form** (where elements are either `0` or `1` in matrix form are converted into set of coordinates).

### Test Flow

This process ensures that the dilation operation is applied correctly, and the final result is returned as a matrix. The output is a new logical matrix that represents the dilation of the specially transformed input sets.

1. **Define the sets `A` and `B`** as matrices.
2. **Convert the matrices into coordinates** using `matrixToCoords`.
3. **Perform the dilation operation** between `A` and `B` using `EXTRA.DILATIONSET`.
4. **Convert the result back into a matrix** using `coordsToMatrix` and display it.
```matlab
A = [
    1 1 0 0;
    0 1 0 1
];

B = [
    0 1;
    1 0
];

disp(ImageProcessor.EXTRA.DILATION(A,B));

A = ImageProcessor.matrixToCoords(A);
B = ImageProcessor.matrixToCoords(B);

C = ImageProcessor.EXTRA.DILATIONSET(A,B);
C = ImageProcessor.coordsToMatrix(C);
disp(C);
```

- Output:

```
>> 
     1     1     1     0     0     0     0
     1     1     1     1     1     1     0
     0     1     1     1     1     1     1
     0     0     0     0     1     1     1

     1     1     1     0     0     0     0
     1     1     1     1     1     1     0
     0     1     1     1     1     1     1
     0     0     0     0     1     1     1
```

### Summary:

- `EXTRA.DILATIONSET` = Works similarly to `EXTRA.DILATION`.
- `EXTRA.DILATIONSET` is **not suitable** for RGB images or matrices with multiple channels so you may have to manually separate the channels to calculate it.
- Both `EXTRA.DILATION` and `EXTRA.DILATIONSET` can be considered **homomorphic** in their operation.

## ASf(A, d, ind)
- Input:
  - A (required): A 2D numerical matrix containing logical, integer, or decimal values.  
  - d (required): An integer representing the number of times the derivative is computed.  
  - ind (required): An integer representing the column or the columns of A to differentiate. Only that column is differentiated while the others remain unchanged.
- Output:
  - Jacobian (a 2D matrix): A 2D matrix representing the derivatives of `A` after `d` differentiations.
- Explanation: The `ASf` function computes the derivative of a matrix **A** a specified number of times (`d`). If an optional column index (`ind`) is provided, only that column is differentiated.
  Consider the polynomial:
  P(x, y) = 3x + 5y + 5x² + 4y² + x³ + 4x⁴
  
  The coefficients of **x** and **y** are stored in a matrix form:  
  - The vector of **x-coefficients**: [3, 5, 1, 4]ᵀ → MATLAB notation: `[3; 5; 1; 4]`
  - The vector of **y-coefficients**: [5, 4, 0, 0]ᵀ → MATLAB notation: `[5; 4; 0; 0]`
  
  Thus, the **input matrix** `A` is:
  
  ```matlab
  [
    3 5;
    5 4;
    1 0;
    4 0
  ];
  ```
- Example code:
  ```matlab
  A = [
    3 5;
    5 4;
    1 1;
    4 0
  ];
  disp(ImageProcessor.ASf(A,2,1));
  ```
  - Run the Code:
    ```
    >> 
       6     5
      48     4
       0     1
    ```
    This result means that after two derivative operations, the only nonzero entry comes from the x-column, corresponding to the `6x + 48x²` term. The y-column stays the same, as expected.
- **NOTICE:** The input matrix A should **not** contain any constant values from the polynomial. As a result, the output will also ignore any constant values after differentiation.
### **PURPOSES**
The `ASf` function was developed to observe **patterns in an image after differentiation**. Below is an example of how to use it for **image processing**:
  ```matlab
  A = [
    1 1 0 0 1 1 0 0 1 1 0 0;
    0 1 0 1 0 1 0 1 0 1 0 1;
    1 1 0 0 1 1 0 0 1 1 0 0;
  ];
  A = ImageProcessor.matrixToCoords(A);
  A = ImageProcessor.ASf(A,2,1);
  A = ImageProcessor.coordsToMatrix(A);
  B = ones([3 3]);
  imshow(ImageProcessor.Dilation1(A,B)); % Apply dilation to enhance visualization
  ```
- Run the code:  
  ![{116ED977-56BE-4C20-801B-6134A69B4FCA}](https://private-user-images.githubusercontent.com/179333283/432958143-f3a72409-7f77-4641-a8ed-90bea9ead0af.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDMyOTU4MTQzLWYzYTcyNDA5LTdmNzctNDY0MS1hOGVkLTkwYmVhOWVhZDBhZi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hMDI5ZDBmNWVlYjdhMDNjOTk4NjU5MTU0YTFlYzEzNjVkOGViN2RkMTA3ODBmNzZjYWE4Y2QzY2UzMTVkMDEyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.38-dAerWluqFOqwYSuI4UTbxJ-_hmLYGK-YGXfMEOM4)  

## AJF(A, d, ind)
- Input:
  - A (required): A 2D numerical matrix containing logical, integer, or decimal values.  
  - d (required): An integer representing the number of times the derivative is computed.  
  - ind (optional): An integer (either 1 or 2). `1` indicates the function keeps **all** columns' positions the same. In the case of number `2`, columns' positions are reversed.
- Output:
  - Jacobian (a 2D matrix): A 2D matrix representing the derivatives of `A` after `d` differentiations.
- Explanation: The `AJF` function computes the derivative of a matrix **A** a specified number of times (`d`). It has similar inputs like `ASf` function.
- Example code:
  ```matlab
  A = [
    3 5;
    5 4;
    1 0;
    4 0
  ];
  disp(ImageProcessor.AJF(A,2,1));
  ```
- Run the code:
  ```matlab
  >> 
     6     0
    48     0
  ```
- Another example code:
  ```matlab
  A = [
    3 5;
    5 4;
    1 1;
    4 0
  ];
  disp(ImageProcessor.AJF(A,2,2));
  ```
- Run the Code:
  ```
  >> 
   6     6
   0    48
  ```
- **NOTICE:** The input matrix A should **not** contain any constant values from the polynomial. As a result, the output will also ignore any constant values after differentiation.
- Another example code:
  ```matlab
  A = [
    1 1 0 0 1 1 0 0 1 1 0 0;
    0 1 0 1 0 1 0 1 0 1 0 1;
    1 1 0 0 1 1 0 0 1 1 0 0;
  ];
  A = ImageProcessor.matrixToCoords(A);
  A = ImageProcessor.AJF(A,2,1);
  A = ImageProcessor.coordsToMatrix(A);
  B = ones([8 8]);
  imshow(ImageProcessor.Dilation1(A,B)); % Apply dilation to enhance visualization
  ```
- Run the code:  
  ![{5D2EE982-EC81-4320-B977-000EAA144969}](https://private-user-images.githubusercontent.com/179333283/432995845-4c27a4cc-fdd5-407e-9135-d58d979c2027.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDcxMDc3MzAsIm5iZiI6MTc0NzEwNzQzMCwicGF0aCI6Ii8xNzkzMzMyODMvNDMyOTk1ODQ1LTRjMjdhNGNjLWZkZDUtNDA3ZS05MTM1LWQ1OGQ5NzljMjAyNy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNTEzJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDUxM1QwMzM3MTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05NDFlN2NjYzAzZjk3YTFhYWI4ZjNkMzVkMjAwYzE0NmMyYjNkMDdlNGFhNGJiM2QyZDIzNTkxMGIzNTY5MTcwJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.KOj2YnU4Cqi2VVzgxqLLkBc9gG2BwH6bKvl-kawrfF4)

## PDilation(A, B) & reversedPDilation(Cs)
### Summary of PDilation
This is a custom convolution-like operation on 1D integer arrays A and B, defined as:
```matlab
dilatedPartition = ImageProcessor.M2P(ImageProcessor.Dilation1(ImageProcessor.P2M(A),ImageProcessor.P2M(B)));
```
Where `M2P` convert matrix into partition and `P2M` performs otherwise.
The code section of `PDilation` can be re-defined as:
```matlab
C = flip(partitionA - 1) + partitionB';
... % Some exceptions handling
```
Then the result dilatedPartition is formed by:
- Sliding across diagonals of `C`  
- Taking the maximum from each diagonal

This is like a max-plus convolution (like plus-multiplication `conv` from MATLAB), which appears in scheduling theory, image dilation, and mathematical morphology.  
There will be a separate [explanation](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/PDilation-reversedPDilation.md) as why is it (PDilation) defined this way. I would love to explain some theories like why divide-and-conquer may not be applicable in the case of `reversedPDilation` as well as show some properties.
#### Important Properties
***Commutative?***  
Yes, because `flip(A - 1) + B'` is symmetric in A and B, up to flipping; and, max of diagonals doesn’t depend on which array came first.  
***Associative?***  
Also a yes because of how flipping, addition, and max behave.
### PDilation(A, B)
- Input:
  - partitionA (required): non-increasing 1D non-negative integer vector 
  - partitionB (required): non-increasing 1D non-negative integer vector  
- Output:
  - dilatedPartition (1D integer vector): A 1D non-increasing non-negative integer vector
- Example code:
  ```matlab
  A = [5 4 3 2];
  B = [7 3 1];
  C = ImageProcessor.PDilation(A,B);
  disp(C);
  ```
- Run the code:
  ```
  >> 
    11    10     9     8     4     2
  ```
### reversedPDilation(A, B)
- Input:
  - Cs (required): A non-increasing, one-dimensional vector of non-negative integers  
- Output:
  - dilatedPartition (1D integer vector): A 2D cell array containing pairs of partitions, where `size(dilatedPartition)` would be `[<number of partitions> 2]`.
- Explanation: `reversedPDilation` generates all possible pairs of partitions such that applying `PDilation` to them results in `Cs`.
- Example code:
  ```matlab
  C = ImageProcessor.reversedPDilation([11    10     9     8     4     2]);
  disp(C);
  disp(size(C));
  ```
- Run the code:
  ```
  >>
    {[            1]}    {[11 10 9 8 4 2]}
    {[            2]}    {[ 10 9 8 7 3 1]}
    {[          2 1]}    {[   10 8 8 4 2]}
    {[          2 1]}    {[   10 9 8 4 2]}
    {[          3 2]}    {[    9 7 7 3 1]}
    {[          3 2]}    {[    9 8 7 3 1]}
    {[        3 1 1]}    {[      9 8 4 2]}
    {[        3 2 1]}    {[      9 8 4 2]}
    {[        4 2 2]}    {[      8 7 3 1]}
    {[        4 3 2]}    {[      8 7 3 1]}
    {[        7 3 1]}    {[      5 4 3 2]}
    {[        8 4 2]}    {[      4 3 2 1]}
    {[      4 3 2 1]}    {[        8 4 2]}
    {[      5 4 3 2]}    {[        7 3 1]}
    {[      8 7 3 1]}    {[        4 2 2]}
    {[      8 7 3 1]}    {[        4 3 2]}
    {[      9 8 4 2]}    {[        3 1 1]}
    {[      9 8 4 2]}    {[        3 2 1]}
    {[    9 7 7 3 1]}    {[          3 2]}
    {[    9 8 7 3 1]}    {[          3 2]}
    {[   10 8 8 4 2]}    {[          2 1]}
    {[   10 9 8 4 2]}    {[          2 1]}
    {[ 10 9 8 7 3 1]}    {[            2]}
    {[11 10 9 8 4 2]}    {[            1]}

    24     2
  ```
