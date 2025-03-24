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
     If the `order` is `[3 2; 2 1]` (2D matrix) and the 3rd parameter of the `customSorting` function is `[1 3 2]` (meaning "R < B < G"), the output might look like this:
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
  ![{E00ACA93-416A-401F-8015-4878DB7E3892}](https://github.com/user-attachments/assets/c996b159-844a-4963-8bc1-1c3a887a1707)  

## Dilation1, Erosion1, Opening1, Closing1 (binaryMatrix1, binaryMatrix2)
- Notes: Some books have different definition of erosion function though most of their functions of dilation are commutative. I keep the traditional erosion and dilation functions as many book described in `Erosion1` and `Dilation1`, respectively. Hence, only `Dilation1` is commutative.
- Input:
  - binaryMatrix1 (2D or 3D logical): an image with or without red, green, and blue channels.
  - binaryMatrix2 (2D or 3D logical): a kernel with or without red, green, and blue channels.
- Output:
  - Logical 2D (gray) or 3D (rgb) image.
- Explanation. When applying `Dilation1` and `Erosion1`, it will scale the values (logical values) by multiplying the values inside the kernel and then find `max` and `min`, respectively. In the case of `Erosion1`, if any "0" is encountered in the kernel, it simply ignores that part and does not reduce the center value to "0". This means that the center pixel value will be preserved as long as there are enough "1"s in the region to meet the kernel’s size, effectively only removing noise or small interruptions in the foreground. This adds additional flexibility to the function.
- Example: Consider the binary matrices of `test.png` and `test2.png` (downloaded the images) in this case:
  ```matlab
  image = ImageProcessor.readImage('test.png');
  image2 = ImageProcessor.readImage('test2.png');
  image2 = image2(230:235,230:235,:);
  image = image > 100;
  image2 = image2 > 100;
  ```
  - I used `imshow(uint8(image) * 255);` to show the image:  
  ![{7ABCE2D5-D49C-4DA8-9E40-2E58CACD13D0}](https://github.com/user-attachments/assets/b87f9b0e-588d-4ee9-8a11-7252f3622684)  
  - Same thing goes for image2:  
  ![{15C73C8D-005E-463D-9FD2-E8C506C2BD8B}](https://github.com/user-attachments/assets/17ccaf34-ae27-4ecf-8c7e-f0763ce9cca7)  
  - I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion1`:
    ```matlab
    output = ImageProcessor.Erosion1(image,image2);
    imshow(output);
    ```  
  - The output is like this:  
    ![{67D74618-8800-4307-9F3F-DC83350AC4E1}](https://github.com/user-attachments/assets/57a8d9c2-77ab-47d0-9b0d-039b913ed7c6)  
  - I tried with Dilation1, Opening1, and Closing1 respectively:  
    ![{B99D868B-E78F-4281-8C07-93736746A745}](https://github.com/user-attachments/assets/ba115749-bdfb-4307-bd36-f49e63da4f50)  
    ![{541CA048-BFAB-43B4-A79A-C3A40FD97550}](https://github.com/user-attachments/assets/1e381d0a-ccd0-48bb-8f20-f270ff430b69)  
    ![{5E195FDB-AD2B-4068-B312-1E8912D7B8C0}](https://github.com/user-attachments/assets/db1c5a0c-4d35-4f0e-8e78-cc498a9a7368)  
    - It's recommend to have smaller size of `image2` (ideally 5 to 35). Swapping the input position results in the same output image (only for dilation function):    
      ![{C40E3C47-5960-47BB-A05F-01140E2E3C30}](https://github.com/user-attachments/assets/16518dae-74f4-4d3f-95a5-17b880a633df)  
      ![{3CB73E92-8936-4F7C-98CB-FE8F9FC5E521}](https://github.com/user-attachments/assets/c44ec77c-894c-4382-8956-0cac16e04cc5)  
      ![{83643EB6-3FA3-4DFE-8193-664B6521D73D}](https://github.com/user-attachments/assets/e910e18f-ae29-4f8c-a3b8-7f0c233d004e)  
      ![{60B3C1E7-CEC7-469C-B71E-069EB4F7E830}](https://github.com/user-attachments/assets/800b2c12-a578-4b40-8a6c-9a9d8897a32d)  
  
  - An example of applying 2D binary matrices as inputs:  
    - `image` =  
  ![{45231E59-FDB2-4AAA-B240-A97CBB56902E}](https://github.com/user-attachments/assets/4f476b09-2cf9-4002-b99b-6d74636e7bb6)  
    - `image2` =  
  ![{742CCC11-EEF9-4A5F-A291-EF20376FECE0}](https://github.com/user-attachments/assets/dc8d838e-d6f9-403d-aeb0-d82a6b40b773)  
    - `output` =  
  ![{670A86FF-918B-4EF0-9E8F-5D0D659B15D7}](https://github.com/user-attachments/assets/aad91a6f-780f-44cf-85aa-cbdb3c197f23)
  
## Dilation2, Erosion2, Opening2, Closing2 (binaryMatrix1, binaryMatrix2)
- Input:
  - binaryMatrix1 (2D or 3D logical): an image with or without red, green, and blue channels.
  - binaryMatrix2 (2D or 3D logical): a kernel with or without red, green, and blue channels.
- Output:
  - Logical 2D (gray) or 3D (rgb) image.
- Explanation. When applying `Dilation2` and `Erosion2`, it will scale the values (colored or gray values) by multiplying the values inside the kernel and then find `max` and `min`, respectively.
- Example: Consider the binary matrices of `test.png` and `test2.png` (downloaded the images) in this case:
  ```matlab
  image = ImageProcessor.readImage('test.png');
  image2 = ImageProcessor.readImage('test2.png');
  image2 = image2(230:235,230:235,:);
  ```
  - I used `imshow(image);` to show the image:  
  ![{5334DE9F-F56B-461A-8A9F-60EB776444AE}](https://github.com/user-attachments/assets/79579b7e-c97b-4cd6-bc30-34acd2153da3)  
  - Same thing goes for image2:  
  ![{9C13C4B2-ACD4-4D8B-9944-18DAB2370919}](https://github.com/user-attachments/assets/8d931f6b-08c9-4fc5-9d21-b96644b64084)  
  - I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion2`:
    ```matlab
    output = ImageProcessor.Erosion2(image,image2);
    imshow(output);
    ```  
  - The output is like this:  
  ![{1ED3106D-9CF6-4EED-80AC-3CC55BBD884D}](https://github.com/user-attachments/assets/059abf02-e842-40fe-b5a2-17afcb41df2a)  
  - I tried with Dilation2, Opening2, and Closing2 respectively:  
  ![{DD04683F-FD41-4A38-90A1-19F021958589}](https://github.com/user-attachments/assets/fc85a739-e66d-47d7-9422-c388a18e05c3)  
  ![{66DA5B83-6D0B-4E07-A60B-35A41044C6FC}](https://github.com/user-attachments/assets/6fa8f52b-8b8e-459b-a7b3-f23356babb29)  
  ![{21F5E61E-380C-41DF-A713-EE63BE25A0FE}](https://github.com/user-attachments/assets/d16940a8-70b9-4204-b2fc-3674788a0aea)  
    - If I swap the input position of `image` and `image2` (`image` becoming 2nd parameter and `image2` becoming 1st parameter), the program stucks forever due to the larger mask being applied in the calculation. It's recommend to have smaller size of `image2` (ideally 5 to 35). Swapping the input position doesn't results in the output image being flipped up-side-down, left-to-right, or identical image compared to the original output. However (fun fact), applying Bayer filter seems to make the outputs very identical. In fact, if you flip the image up-side-down and left-to-right, it looks almost the same:  
    ![{10A3ED5F-C358-4CF9-ABC4-987CC81FF38F}](https://github.com/user-attachments/assets/99e9b567-5603-460b-b313-25e06f7d3613)  
    ![{F3449905-059C-43AF-B5A1-648F653C771B}](https://github.com/user-attachments/assets/a5522c27-722a-46e6-9093-b746ee7436aa)  
  - An example of applying 2D binary matrices as inputs:  
    - `image` =  
  ![{3BC14EFE-9688-499C-A05F-D0EDA888D444}](https://github.com/user-attachments/assets/1b1d0a09-582a-4859-867b-96bdedfe6679)  
    - `image2` =  
  ![{BE12C0BB-22E1-4B8D-92AD-998610501BB6}](https://github.com/user-attachments/assets/62345f1f-0fa3-47e9-89eb-3e4b3b02c301)  
    - `output` =  
  ![{5EAF7C85-D2C5-4FBD-9F65-0341703D94C7}](https://github.com/user-attachments/assets/4d37f91f-75d1-4534-a60f-3ef5b8fb28d6)

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
Dilation in matrix form is a well-known operation, but before applying it, we introduce a **special function**, called **MatrixDecomposition**, that transforms the input matrices. This function modifies both `A` and `B`, and then we apply **standard dilation** (as defined in most image processing literature) to the transformed versions.

### MatrixDecomposition Transformation
MatrixDecomposition works as follows:

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
This means for every point `(a,b)` in `A`, we add all points `(c,d)` from `B` to generate the dilated result.

#### Matrix-Based Dilation (Efficient Form):
- Instead of iterating over sets, **matrix dilation** is efficiently computed using **convolution operations** or **max filtering**, where a **structuring element (kernel)** is applied to the binary image.
- **MatrixDecomposition as Multiple Dilations**: We can redefine the **MatrixDecomposition** as a series of dilations for each element in the set, where the dilation operator ⊕ applies to each element in the set 𝐴. For each element, we consider the set that contains the coordinate [0,0] (the first coordinate) and the element itself so that ⊕ can be applied. The special function then becomes the **Riemann Dilation sum** of these dilations (like how `+` has **Riemann sum**, ⊕ has **Riemann Dilation sum**). This **reduces computation time** from `O(2^(|A|+|B|))` in the set-based approach to `O([max(rows(A)) × max(cols(A))]³)` for the `matrixDecomposition` function that transforms the input matrices.

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
- Run the code: ![{E86B4DFF-EDAC-4652-B698-685318D7A79E}](https://github.com/user-attachments/assets/fe38f19a-ce1f-4588-90ef-1d8a075f718f)  
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
- Run the code: ![{BD9875CA-0779-4290-B6A4-7C20D8919CC0}](https://github.com/user-attachments/assets/5d52c232-d2de-45c4-9a12-3e75d0dd332a)  
- **Fun fact**: No matter how you twist your input image, if it has enough entries that have value `1`, it will turn into this image shape. (Note: I used `matrixDecomposition` here for demonstration. `EXTRA.DILATION` also works with 2D binary matrices.
  - Example:  
    ![{69B45C5E-510D-4A13-B104-0F8992509B0F}](https://github.com/user-attachments/assets/c5d59428-4abd-4c9a-a3aa-ecb5f28570af)  
    As I increase the number of ones:  
    ![{74BE45FD-6BC5-4A01-A617-D92FBEF43327}](https://github.com/user-attachments/assets/1a524198-4f0f-43c1-82cc-7a9b0d87921f)

## EXTRA.DILATIONSET Function and Their Workflow

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
   - **Purpose**: This function takes a set of coordinates (like those generated by `matrixToCoords`) and converts them back into a binary matrix where `1`s are placed at the corresponding positions.
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
   - **Purpose**: This function performs the dilation operation between two sets, `A` and `B`. It calculates the set `A ⊕ B = { (a,b) + (c,d) | (a,b) ∈ A, (c,d) ∈ B }`, which involves adding every element of `B` to every element of `A`. 
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

The function `EXTRA.DILATIONSET` operates in a way that is conceptually similar to the function `EXTRA.DILATION`. Both of these functions can be considered **homomorphic**, meaning they perform a similar dilation operation, but on different data structures. The same concept applies to the relationship between `dilationSet` and the **standard dilation on matrices**.

- **Key Difference**: Unlike `EXTRA.DILATION`, which is designed to handle dilation on matrices of various dimensions, **`EXTRA.DILATIONSET`** is specifically optimized for working with 2D logical matrices in the set form (where elements are either `0` or `1` in matrix form are converted into set of coordinates).
  
- **Important Note**: It is not recommended to use `EXTRA.DILATIONSET` on RGB images or matrices with more than two dimensions. This function is intended to work with **2D logical matrices** represented in the set form.

### Dilation Process

This process ensures that the dilation operation is applied correctly, and the final result is returned as a matrix. The output is a new logical matrix that represents the dilation of the input sets.

### Test Flow

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
