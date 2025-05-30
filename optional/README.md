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
  ![{7ABCE2D5-D49C-4DA8-9E40-2E58CACD13D0}](https://github.com/user-attachments/assets/b87f9b0e-588d-4ee9-8a11-7252f3622684)  
  - Same thing goes for image2:  
  ![{15C73C8D-005E-463D-9FD2-E8C506C2BD8B}](https://github.com/user-attachments/assets/17ccaf34-ae27-4ecf-8c7e-f0763ce9cca7)  
  - I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion1`:
    ```matlab
    output = ImageProcessor.Erosion1(image,image2);
    imshow(output);
    ```  
  - The output is like this:  
    ![{A443E44E-B85E-433E-9B47-EA056B9BB1EF}](https://github.com/user-attachments/assets/cfda9906-2d75-48e1-b2f4-b9c71bbd2c8b)  
  - I tried with Dilation1, Opening1, and Closing1 respectively:  
    ![{B1E3F47E-0A99-49DB-A9EC-1541E33EF0EB}](https://github.com/user-attachments/assets/943e1fa0-135c-4bb0-98cc-e19b21f1763d)  
    ![{77A873A5-E969-458B-8A4C-9DD4F88EAC6E}](https://github.com/user-attachments/assets/c5f533b0-672f-4dc6-8e9f-95e382b9993d)  
    ![{97A44743-FC25-47FF-A172-7055058C4306}](https://github.com/user-attachments/assets/34a30c89-cad4-469a-9c38-01e6f89d3335)  
    - It's recommend to have smaller size of `image2` (ideally 5 to 35). Swapping the input position results in the same output image (only for dilation function)  
  
  - An example of applying 2D binary matrices as inputs:  
    - `image` =  
  ![{45231E59-FDB2-4AAA-B240-A97CBB56902E}](https://github.com/user-attachments/assets/4f476b09-2cf9-4002-b99b-6d74636e7bb6)  
    - `image2` =  
  ![{742CCC11-EEF9-4A5F-A291-EF20376FECE0}](https://github.com/user-attachments/assets/dc8d838e-d6f9-403d-aeb0-d82a6b40b773)  
    - `output` =  
  ![{9EC6401C-701E-4429-B4DD-01BFE769DAAE}](https://github.com/user-attachments/assets/ac3ca2ef-b307-4d97-8cda-ee862e7f008d)
  
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
  - A **sorted 1D array** representing the **merged** partition of `partition1` and `partition2` using the special operation **⊔**.  

- Explanation of the **⊔** Operation:
  - The **⊔** operation constructs a new partition by taking the **multiset union** of the elements from `partition1` and `partition2`. After merging, the resulting partition is **reordered** in **weakly decreasing** order.
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
`{(a,b)+(c,d)+... | (a,b),(c,d),... ∈ A and (a,b) ≠ (c,d) ≠ ...}`
where `...` can be empty or multiple elements of `A`.

3. **Convert this transformed set back into a matrix** representation.

### Comparison Between Set-Based and Matrix-Based Dilation  

#### Set-Based Dilation:
In set notation, the **dilation of two sets** `A` and `B` is defined as:  
A ⊕ B = { (a,b) + (c,d) | (a,b) ∈ A, (c,d) ∈ B }  
For every point `(a,b)` in `A`, we add all points `(c,d)` from `B` to generate the dilated result.  

#### Matrix-Based Dilation (Efficient Form):
- Instead of iterating over sets, **matrix dilation** is efficiently computed using **convolution operations** or **max filtering**, where a **structuring element (kernel)** is applied to the binary image.
- **MatrixDecomposition as Multiple Dilations**: We can think of the **MatrixDecomposition** as a series of dilations for each element in the set, where the dilation operator `⊕` applies to each element in the set 𝐴. For each element, we consider the set that contains the coordinate [0,0] (the first coordinate) and the element itself so that `⊕` can be applied. The special function then becomes the **Riemann Dilation sum** of these dilations (like how `+` has **Riemann sum**, `⊕` has **Riemann Dilation sum**). Consider this example:
  - Example: Generating Subsets Using Dilation
  
    Consider a set  
    **A = {a, b, c}**  
    Normally, we could generate subsets by toggling bits (e.g., using binary representation), but instead, we use the **dilation operator** (⊕):
  
    - Step 1: Start with the Base Set  
      𝑆₀={[0,0]}  
    This represents the empty set as a starting point.
    
    - Step 2: Apply Dilation with Each Element  
    
      - First dilation with element a:  
      𝑆₁=𝑆₀⊕{[0,0],a}={[0,0], a}  
    
      - Second dilation with element b:  
      𝑆₂=𝑆₁⊕{[0,0],b}={[0,0],a,b,a+b}
    
      - Third dilation with element c:  
      𝑆₃=𝑆₂⊕{[0,0],c}={[0,0],a,b,c,a+b,a+c,b+c,a+b+c}
  
    - **Resulting Set:**  
    After three dilations, we have generated all possible subsets of A, mimicking how binary toggling would work.  

- Effects: This **reduces computation time** from `O(2^(|A|))` (where `|A|` is the length of set A or the number of `1`s of matrix A) in the set-based approach to `O((max(row(A)) × max(col(A)))⁴)` for the `matrixDecomposition` function that transforms the input matrices.
- Recommendation:
  - Use Matrix-Based Dilation when `|A|` is large enough (ideally below 676) and `max(row(A))` or `max(col(A))` is not too big.
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
- **Fun fact**: No matter how you twist your input image, if it has enough entries that have value `1`, it will turn into the oval-like form with two pointed ends.
  - Note: I used `matrixDecomposition` here for demonstration. `EXTRA.DILATION` also works with 2D binary matrices.
  - Example:  
    ![{69B45C5E-510D-4A13-B104-0F8992509B0F}](https://github.com/user-attachments/assets/c5d59428-4abd-4c9a-a3aa-ecb5f28570af)  
    As I increase the number of ones:  
    ![{74BE45FD-6BC5-4A01-A617-D92FBEF43327}](https://github.com/user-attachments/assets/1a524198-4f0f-43c1-82cc-7a9b0d87921f)

#### The Shape of EXTRA.EROSION  

- Example code:
```matlab
  tic;
  B = ImageProcessor.readImage('test.png');
  A = B(200:205,200:205,:) > 160;
  B = B(200:215,200:215,:) > 160;
  t = ImageProcessor.EXTRA.EROSION(B,A);
  imshow(t);
  elapsedTime = toc;
  disp(elapsedTime);
  disp("Size of input image: " + strjoin(arrayfun(@num2str, size(B), 'UniformOutput', false), ' '));
  disp("Size of output image: " + strjoin(arrayfun(@num2str, size(t), 'UniformOutput', false), ' '));
  ```

- Run the code:
![{C0D3C166-1553-4270-A46B-42CB1F4B6530}](https://github.com/user-attachments/assets/0d3458d9-502c-4e8c-8505-ffedf0bd2640)  

- Another example code:
```matlab
tic;
B = ImageProcessor.readImage('test.png');
A = B(200:210,200:210,:) > 160;
B = B(200:215,200:215,:) > 160;
t = ImageProcessor.EXTRA.EROSION(B,A);
imshow(t);
elapsedTime = toc;
disp(elapsedTime);
disp("Size of input image: " + strjoin(arrayfun(@num2str, size(B), 'UniformOutput', false), ' '));
disp("Size of output image: " + strjoin(arrayfun(@num2str, size(t), 'UniformOutput', false), ' '));
```

- Run the code:
![{1228EA46-9CB7-4B05-B47A-B6E683F19E53}](https://github.com/user-attachments/assets/6289414b-da2e-404e-9657-4abd9d01e382)  

## EXTRA.DILATIONSET and dilationSet Functions with Added Customized Functions  

### 1. **matrixToCoords(A)**
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

### 2. **coordsToMatrix(B)**
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

### 3. **dilationSet(A, B)**
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

### EXTRA.DILATIONSET Function and its Comparison to EXTRA.DILATION

The function `EXTRA.DILATIONSET` operates in a way that is conceptually similar to the function `EXTRA.DILATION`. Both of these functions can be considered **homomorphic** (set that has negative coordinates can't be converted into matrix), meaning they perform a similar dilation operation, but on different data structures. The same concept applies to the relationship between `dilationSet` and the **standard dilation on matrices**.

- **Important Note**: Unlike `EXTRA.DILATION`, which is designed to handle dilation on matrices of various dimensions, `EXTRA.DILATIONSET` is specifically optimized for working with 2D logical matrices in the **set form** (where elements are either `0` or `1` in matrix form are converted into set of coordinates).  

### Test Flow

This process ensures that the dilation operation is applied correctly, and the final result is returned as a matrix. The output is a new logical matrix that represents the dilation of the specially transformed input sets.

1. **Define the sets A and B** as matrices.
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

### Additionally:

- `EXTRA.EROSIONSET` = Works similarly to `EXTRA.EROSION`.
- `EXTRA.EROSIONSET` is **not suitable** for RGB images or matrices with multiple channels so you may have to manually separate the channels to calculate it.
- Both `EXTRA.EROSION` and `EXTRA.EROSIONSET` can be considered **homomorphic** in their operation.

## ASf(A, d, ind)
- Input:
  - A (required): A 2D numerical matrix containing logical, integer, or decimal values.  
  - d (required): An integer representing the number of times the derivative is computed.  
  - ind (required): An integer representing the column or the columns of A to differentiate. Only that column is differentiated while the others remain unchanged.
- Output:
  - Jacobian (a 2D matrix): A 2D matrix representing the derivatives of `A` after `d` differentiations.
- Explanation: The `ASf` function computes the derivative of a matrix `A` a specified number of times (`d`). If an optional column index (`ind`) is provided, only that column is differentiated. But first, the elements have to be sorted first in the 'rows' order (can be achieved by using command `unique(A, 'rows')`).
  Consider the polynomial:
  
  𝑃(𝑥,𝑦) = 3𝑥 + 5𝑦 + 5𝑥² + 4𝑦² + 𝑥³ + 4𝑥⁴  
  
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

  **NOTICE:** The matrix A will be **sorted internally** during computation, typically in ascending order by the x-column (always). Hence, the actual polynomial being differentiated is not `3𝑥 + 5𝑦 + 5𝑥² + 4𝑦² + 𝑥³ + 4𝑥⁴`, but instead: `1𝑥 + 3𝑥² + 5𝑦² + 4𝑥³ + 5𝑥⁴ + 4𝑦⁴`
  
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
      24     1
      60     5
       0     0
       0     4
    ```
    This result means that after two derivative operations, the only nonzero entry comes from the x-column, corresponding to the `6x + 48x²` term. The y-column stays the same, as expected.
- **NOTICE:** The input matrix A should **not** contain any constant values from the polynomial. As a result, the output will also ignore any constant values after differentiation.  

### PURPOSES
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
  ![{116ED977-56BE-4C20-801B-6134A69B4FCA}](https://github.com/user-attachments/assets/f3a72409-7f77-4641-a8ed-90bea9ead0af)

- Advanced use case (calculating `ASf(A, 2, 1) ⊕ ASf(A, 2, 2)`):
```matlab
A = [
  3 5;
  4 8;
  1 0;
  2 1;
  2 4
];

% A after sorting should be like this:
% 
%      1     0
%      2     1
%      2     4
%      3     5
%      4     8

B = ImageProcessor.dilationSet(ImageProcessor.ASf(A,2,1),ImageProcessor.ASf(A,2,2));
B = ImageProcessor.coordsToMatrix(B);
A = ImageProcessor.coordsToMatrix(A);

% ImageProcessor.ASf(A,2,1) should be like this:
% 
%     12     0
%     36     1
%     80     4
%      0     5
%      0     8

% ImageProcessor.ASf(A,2,2) should be like this:
% 
%      1    24
%      2    60
%      2   160
%      3     0
%      4     0

```

- Visual outputs:
  - Image of A:

    ![{31DF0FA4-0166-4127-B7E0-8B432B67D9A2}](https://github.com/user-attachments/assets/1712ef23-deed-4c4f-beee-fdb5a5e5b91a)
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{BE68F33B-104C-4F71-98D1-715809C9DF7E}](https://github.com/user-attachments/assets/63ae0a52-a8ca-43fe-89ed-64b1fc405481)
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{5F765D05-3D78-40BB-AA2A-44908A7FBFF5}](https://github.com/user-attachments/assets/39af5f20-bd43-446d-841f-9731ee7d9d03)  
  - Image of B:

    ![{B8E7C152-B85F-4B86-8A52-4E15D0499B97}](https://github.com/user-attachments/assets/e356644e-e852-41c5-81c9-18997c442186)

  - **Image Size Inspection:** The output image has smaller pixels as the image is spanning. To check the size of the image based on the set, you can run the command `max(<set>)` to check for the size:  
    - Example code:
      ```matlab
        A = [
          3 5;
          4 8;
          1 0;
          2 1;
          2 4
        ];
        
        ASf_1 = ImageProcessor.ASf(A,2,1);
        ASf_2 = ImageProcessor.ASf(A,2,2);
        B = ImageProcessor.dilationSet(ASf_1, ASf_2); % ASf(A, 2, 1) ⊕ ASf(A, 2, 2)
        disp("Size is the heigh-width of the image:");
        disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
        disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
        
        disp(["Size of ASf(A, 2, 1) ⊕ ASf(A, 2, 2):" max(B)]);
      ```
    - Run the code:
      ```matlab
        >> 
        Size is the heigh-width of the image:
            "Size of ImageProcessor.ASf(A,2,1):"    "80"    "8"
        
            "Size of ImageProcessor.ASf(A,2,2):"    "4"    "160"
        
            "Size of ASf(A, 2, 1) ⊕ ASf(A, 2, 2):"    "84"    "168"
      ```

## ASg(A, d, ind)
- Input:  
  - A (required): A 2D numerical matrix containing logical, integer, or floating-point values.
  - d (required): A non-negative integer specifying the number of times the derivative is computed.
  - ind (required): An integer indicating the column of A to differentiate. Only this column is modified; the other columns remain unchanged.
- Output:
  - FlippedJacobian (2D matrix): The output of ASf(A, d, ind) with all coordinate pairs flipped (i.e., [x y] → [y x]). In the matrix form, this function does not modify the values of the matrix, only the order of columns (coordinate axes) in the result.
- Example code:
  ```matlab
    A = [
      3 5;
      5 4;
      1 1;
      4 0
    ];
    
    B = ImageProcessor.ASg(A, 2, 1);
    disp(B);
  ```
- If ASf(A, 2, 1) yields:
```matlab
>> 
    24     1
    60     5
     0     0
     0     4
```
- Then ASg(A, 2, 1) will return:
```matlab
>> 
     1    24
     5    60
     0     0
     4     0
```

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
  ![{5D2EE982-EC81-4320-B977-000EAA144969}](https://github.com/user-attachments/assets/4c27a4cc-fdd5-407e-9135-d58d979c2027)  

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

### Relation to Tropical Polynomial Product

Given two tropical polynomials:

`f(x) = μ₁⨂x⁰⊕μ₂⨂x¹⊕μ₃⨂x²⊕μ₄⨂x³`  
`g(x) = 𝜈₁⨂x⁰⊕𝜈₂⨂x¹⊕𝜈₃⨂x²`

Their tropical product is defined as:  

`f(x) ⊙ g(x) = (μ₁⨂𝜈₁)⨂x⁰⊕(μ₂⨂𝜈₁⊕μ₁⨂𝜈₂)⨂x¹⊕(μ₃⨂𝜈₁⊕μ₂⨂𝜈₂⊕μ₁⨂𝜈₃)⨂x²⊕(μ₃⨂𝜈₂⊕μ₂⨂𝜈₃⊕μ₁⨂𝜈₄)⨂x³⊕(μ₃⨂𝜈₃⊕μ₂⨂𝜈₄)⨂x⁴⊕(μ₃⨂𝜈₄)⨂x⁵`  

Or:  

`f(x) ⊙ g(x) = max(max(μ₁+𝜈₁)+0x,max(μ₂+𝜈₁,μ₁+𝜈₂)+1x,max(μ₃+𝜈₁,μ₂+𝜈₂,μ₁+𝜈₃)+2x,max(μ₃+𝜈₂,μ₂+𝜈₃,μ₁+𝜈₄)+3x,max(μ₃+𝜈₃,μ₂+𝜈₄)+4x,max(μ₃+𝜈₄)+5x)`  

**Notice** that the PDilation has all of its values substracted by 1. PDilation is not exactly tropical multiplication of the raw polynomial terms:  

#### Example: (`PD` stands for `PDilation`)
Let:  

- `λ = (7, 4, 3, 2)`  
- `λ′ = (5, 3, 1)`  

Then:  

- `PD(λ, λ′) = (11, 10, 9, 8, 4, 2)`  
- `f₍₇,₄,₃,₂₎ ⊙ f₍₅,₃,₁₎ = f₍₁₂,₁₁,₁₀,₉,₅,₃₎`

We can conclude that `ƒ_(λ) ⊙ ƒ_(λ′) = ƒ_(PD(λ, λ′) + 1)`
