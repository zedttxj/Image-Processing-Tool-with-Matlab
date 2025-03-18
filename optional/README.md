# FUNCTIONS-CODES.pdf

## BP(A)
- Input:
  - Binary matrix: 2D
- Output:
  - Partition (contains the original size of the binary matrix): 1D
- Explanation: The function BP(A) processes a binary matrix by sorting each row and each column, then counting the number of ones in each row and storing this count in a partition vector. The partition vector represents the number of ones in each row. An alternative approach is to count the number of ones in each row first, and then sort them in descending order. Both approaches produce the same result.
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
Think of this function as a derivative of `BP(A)`. The parameters `lambda` and `order` are used to construct the `data` matrix (whose structure is unknown initially). Then, we extract the colors from `data` based on the provided `G`. Finally, we apply the sorting and counting procedure, similar to `BP(A)`.

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
  - `G` (string or charArray): Specifies the color channels (similar to the `G` parameter in the `PC` function).
  - `order` (2D): A matrix that indicates the sorting order of the channels. For example, "RB" would mean sorting by Red first, then Blue, and "BR" would mean sorting by Blue first, then Red.

- **Output:**  
  - **Filtered Matrices:** The function sorts the matrix `A` based on the channel order specified in `G` and `order`. It tracks the corresponding entries' positions during the sorting process and applies those changes to `A`.

- **Explanation:**
  1. **Matrix Sorting by Channel Order:** The `IC1` function takes an input matrix `A` and sorts it according to the channel order specified in `G` and `order`. For example, if `G = "RB"` and `order = [1 3 2]`, the matrix `A` will be sorted first by the Red channel, then Blue, and lastly by Green. If `order = [2 1 3]`, it will sort by Green, then Red, and then Blue.
  
  2. **Tracking Indices:** The function keeps track of the indices during sorting, so that after sorting, it can correctly reapply the changes to the original matrix `A`.

  3. **Custom Sorting:** To see how the sorting works, you can track the row and column indices of `order` using the `customSorting` function. Here's an example:
    ```matlab
    [data, rows, cols] = ImageProcessor.customSorting(order,"rc",[1 3 2]);
    disp(cols + "," + rows);
    ```

  4. **Sorted Output Example:**  
     If the `order` is `[1 3 2]` (meaning sorting by Red, then Blue, then Green), the output might look like this:
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
   - The `order = [1 3]` means Red is sorted first, followed by Blue, and then Green (not explicitly). So, the sorting process will rearrange the elements based on the order.

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
  ![{5B9BA0E2-804D-4AFF-AB8D-40B4D9BB4452}](https://github.com/user-attachments/assets/9c8cec0a-c268-4b13-9d48-12963bd0b8bf)  
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
  ![{E5F123A2-BC6C-4F87-A5CE-7EEE3BFFEB3A}](https://github.com/user-attachments/assets/40ad3e33-cc9c-4050-83f4-1c618831bf7b)

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

## Dilation1, Erosion1, Opening1, Closing1 (binaryMatrix1, binaryMatrix2)
- Notes: Some books have different definition of erosion function. Their functions of dilation and erosion are commutative. However, it's different in my case (where only my dilaton function is commutative like traditional dilation function defined in many books), which will be demonstrated in the example below. Additionally, I keep the traditional erosion function as many book described (which is commutative) in `CommutativeErosion` function instead of put it in `Erosion1`.
- Input:
  - binaryMatrix1 (2D or 3D logical): an image with or without red, green, and blue channels.
  - binaryMatrix2 (2D or 3D logical): a kernel with or without red, green, and blue channels.
- Explanation. When applying `dilation1` and `erosion1`, it will scale the values (colored or gray values) by multiplying the values inside the kernel and then find `max` and `min`, respectively.
- Example: Consider the binary matrices of `test.png` and `test2.png` (downloaded the images) in this case:
  ```matlab
  image = ImageProcessor.readImage('test.png');
  image2 = ImageProcessor.readImage('test2.png');
  image2 = image2(230:235,230:235,:);
  image = image > 100;
  image2 = image2 > 100;
  ```
  I used `imshow(uint8(image) * 255);` to show the image:  
  ![{7ABCE2D5-D49C-4DA8-9E40-2E58CACD13D0}](https://github.com/user-attachments/assets/b87f9b0e-588d-4ee9-8a11-7252f3622684)  
  Same thing goes for image2:  
  ![{15C73C8D-005E-463D-9FD2-E8C506C2BD8B}](https://github.com/user-attachments/assets/17ccaf34-ae27-4ecf-8c7e-f0763ce9cca7)  
  I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion1`:
  ```matlab
  output = ImageProcessor.Erosion1(image,image2);
  imshow(output);
  ```  
  The output is like this:  
  ![{67D74618-8800-4307-9F3F-DC83350AC4E1}](https://github.com/user-attachments/assets/57a8d9c2-77ab-47d0-9b0d-039b913ed7c6)  
  I tried with Dilation1, Opening1, and Closing1 respectively:  
  ![{B99D868B-E78F-4281-8C07-93736746A745}](https://github.com/user-attachments/assets/ba115749-bdfb-4307-bd36-f49e63da4f50)  
  ![{541CA048-BFAB-43B4-A79A-C3A40FD97550}](https://github.com/user-attachments/assets/1e381d0a-ccd0-48bb-8f20-f270ff430b69)  
  ![{5E195FDB-AD2B-4068-B312-1E8912D7B8C0}](https://github.com/user-attachments/assets/db1c5a0c-4d35-4f0e-8e78-cc498a9a7368)  
  If I swap the input position of `image` and `image2` (`image` becoming 2nd parameter and `image2` becoming 1st parameter), the program stucks forever due to the larger mask being applied in the calculation. It's recommend to have smaller size of `image2` (ideally 5 to 35). Swapping the input position doesn't results in the output image being flipped up-side-down, left-to-right, or identical image compared the original output. However (fun fact), applying Bayer filter seems to make the outputs very identical. In fact, if you flip the image up-side-down and left-to-right, it looks almost the same:  
  ![{58DEFB5D-F4CB-46C0-9E1D-CB703B6AA823}](https://github.com/user-attachments/assets/2386d765-06b5-4ac2-8ca5-d62324ca80ee)  
  ![{7456C810-A333-4377-8619-9B2EAAC39A7D}](https://github.com/user-attachments/assets/2cefa4a9-c625-4c17-b7e2-4168ff0febf6)  
  An example of applying 2D binary matrices as inputs:  
  image =  
  ![{45231E59-FDB2-4AAA-B240-A97CBB56902E}](https://github.com/user-attachments/assets/4f476b09-2cf9-4002-b99b-6d74636e7bb6)  
  image2 =  
  ![{742CCC11-EEF9-4A5F-A291-EF20376FECE0}](https://github.com/user-attachments/assets/dc8d838e-d6f9-403d-aeb0-d82a6b40b773)  
  output =  
  ![{670A86FF-918B-4EF0-9E8F-5D0D659B15D7}](https://github.com/user-attachments/assets/aad91a6f-780f-44cf-85aa-cbdb3c197f23)
  
## Dilation2, Erosion2, Opening2, Closing2 (binaryMatrix1, binaryMatrix2)
- Input:
  - binaryMatrix1 (2D or 3D logical): an image with or without red, green, and blue channels.
  - binaryMatrix2 (2D or 3D logical): a kernel with or without red, green, and blue channels.
- Explanation. When applying `dilation1` and `erosion1`, it will scale the values (colored or gray values) by multiplying the values inside the kernel and then find `max` and `min`, respectively.
- Example: Consider the binary matrices of `test.png` and `test2.png` (downloaded the images) in this case:
  ```matlab
  image = ImageProcessor.readImage('test.png');
  image2 = ImageProcessor.readImage('test2.png');
  image2 = image2(230:235,230:235,:);
  ```
  I used `imshow(uint8(image) * 255);` to show the image:  
  ![{5334DE9F-F56B-461A-8A9F-60EB776444AE}](https://github.com/user-attachments/assets/79579b7e-c97b-4cd6-bc30-34acd2153da3)  
  Same thing goes for image2:  
  ![{9C13C4B2-ACD4-4D8B-9944-18DAB2370919}](https://github.com/user-attachments/assets/8d931f6b-08c9-4fc5-9d21-b96644b64084)  
  I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion2`:
  ```matlab
  output = ImageProcessor.Erosion2(image,image2);
  imshow(output);
  ```  
  The output is like this:  
  ![{1ED3106D-9CF6-4EED-80AC-3CC55BBD884D}](https://github.com/user-attachments/assets/059abf02-e842-40fe-b5a2-17afcb41df2a)  
  I tried with Dilation2, Opening2, and Closing2 respectively:  
  ![{DD04683F-FD41-4A38-90A1-19F021958589}](https://github.com/user-attachments/assets/fc85a739-e66d-47d7-9422-c388a18e05c3)  
  ![{66DA5B83-6D0B-4E07-A60B-35A41044C6FC}](https://github.com/user-attachments/assets/6fa8f52b-8b8e-459b-a7b3-f23356babb29)  
  ![{21F5E61E-380C-41DF-A713-EE63BE25A0FE}](https://github.com/user-attachments/assets/d16940a8-70b9-4204-b2fc-3674788a0aea)  
  If I swap the input position of `image` and `image2` (`image` becoming 2nd parameter and `image2` becoming 1st parameter), the program stucks forever due to the larger mask being applied in the calculation. It's recommend to have smaller size of `image2` (ideally 5 to 35). Swapping the input position doesn't results in the output image being flipped up-side-down, left-to-right, or identical image compared to the original output. However (fun fact), applying Bayer filter seems to make the outputs very identical. In fact, if you flip the image up-side-down and left-to-right, it looks almost the same:  
  ![{10A3ED5F-C358-4CF9-ABC4-987CC81FF38F}](https://github.com/user-attachments/assets/99e9b567-5603-460b-b313-25e06f7d3613)  
  ![{F3449905-059C-43AF-B5A1-648F653C771B}](https://github.com/user-attachments/assets/a5522c27-722a-46e6-9093-b746ee7436aa)  
  An example of applying 2D binary matrices as inputs:  
  image =  
  ![{3BC14EFE-9688-499C-A05F-D0EDA888D444}](https://github.com/user-attachments/assets/1b1d0a09-582a-4859-867b-96bdedfe6679)  
  image2 =  
  ![{BE12C0BB-22E1-4B8D-92AD-998610501BB6}](https://github.com/user-attachments/assets/62345f1f-0fa3-47e9-89eb-3e4b3b02c301)  
  output =  
  ![{5EAF7C85-D2C5-4FBD-9F65-0341703D94C7}](https://github.com/user-attachments/assets/4d37f91f-75d1-4534-a60f-3ef5b8fb28d6)

## PPP1(partition1, partition2)
- Input:
  - Partition 1 (1D): 1D array that contains the coefficients of the first polynomial.
  - Partition 2 (1D): similar to partition1.
- Output: 1D array that contains the coefficients of the product of the 2 polynomials.
- Example code:
  ```matlab
  tic;
  partition1 = 1:100000;
  partition2 = 1:100000;
  ImageProcessor.PPP1(partition1, partition2);
  elapsedTime = toc;
  fprintf('Elapsed time: %.6f seconds\n', elapsedTime);
  ```
- Run the code:
  ```
  >> 
  Elapsed time: 0.252894 seconds
  ```
  Even without using NTT, the code runs very fast thanks to built-in function `conv`.
