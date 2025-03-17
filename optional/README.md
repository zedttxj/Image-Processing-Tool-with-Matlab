# FUNCTIONS-CODES.pdf

## BP(A)
- Input:
  - Binary matrix: 2D
- Output:
  - Partition (contains the original size of the binary matrix): 1D
- Explanation: The function BP(A) processes a binary matrix by sorting each row and each column, then counting the number of ones in each row and storing this count in a partition vector. The partition vector represents the number of ones in each row. An alternative approach is to count the number of ones in each row first, and then sort them in descending order. Both approaches produce the same result.
- Example code:
  ```
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
  ```
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
  ```
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
  ```
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
  ```
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
  ```
  [
    A(2,2,1) A(1,2,2);
    A(1,1,3) A(2,1,2)
  ];
  ```  
- Example code:  
  ```
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
  ```
  [
    A(2,2,1) A(1,2,2);
    A(1,1,3) A(2,1,2)
  ];
  ```
  , it will have this output:
  ```
  [
    [A(2,2,1), 0, 0] [0, A(1,2,2), 0];
    [0, 0, A(1,1,3)] [0, A(2,1,2), 0]
  ];
  ```

## Dilation1, Erosion1, Opening1, Closing1 (binaryMatrix1, binaryMatrix2)
- Notes: Some books have different definition of these functions. Their functions of dilation and erosion are commutative. However, it's different in my case, which will be demonstrated in the example below.
- Input:
  - binaryMatrix1 (2D or 3D logical): an image with or without red, green, and blue channels.
  - binaryMatrix2 (2D or 3D logical): a kernel with or without red, green, and blue channels.
- Explanation. When applying `dilation1` and `erosion1`, it will scale the values (colored or gray values) by multiplying the values inside the kernel and then find `max` and `min`, respectively.
- Example: Consider the binary matrices of `test.png` and `test2.png` (downloaded the images) in this case:
  ```
  image = ImageProcessor.readImage('test.png');
  image2 = ImageProcessor.readImage('test2.png');
  image2 = image2(230:235,230:235,:);
  image = image > 100;
  image2 = image2 > 100;
  ```
  I used `imshow(uint8(image) * 255);` to show the image: ![{7ABCE2D5-D49C-4DA8-9E40-2E58CACD13D0}](https://github.com/user-attachments/assets/b87f9b0e-588d-4ee9-8a11-7252f3622684)
  Same thing goes for image2: ![{15C73C8D-005E-463D-9FD2-E8C506C2BD8B}](https://github.com/user-attachments/assets/17ccaf34-ae27-4ecf-8c7e-f0763ce9cca7)
  I only extract 5x5 grid of the image2 in this example (which explains why it appears to be small). Now, I apply `Erosion1`:
  ```
  output = ImageProcessor.Erosion1(image,image2);
  imshow(output);
  ```  
  The output is like this:
  ![{67D74618-8800-4307-9F3F-DC83350AC4E1}](https://github.com/user-attachments/assets/57a8d9c2-77ab-47d0-9b0d-039b913ed7c6)  
  I tried with Dilation1, Opening1, and Closing1 respectively:  
  ![{B99D868B-E78F-4281-8C07-93736746A745}](https://github.com/user-attachments/assets/ba115749-bdfb-4307-bd36-f49e63da4f50)  
  ![{541CA048-BFAB-43B4-A79A-C3A40FD97550}](https://github.com/user-attachments/assets/1e381d0a-ccd0-48bb-8f20-f270ff430b69)  
  ![{5E195FDB-AD2B-4068-B312-1E8912D7B8C0}](https://github.com/user-attachments/assets/db1c5a0c-4d35-4f0e-8e78-cc498a9a7368)  
  If I swap the input position of `image` and `image2` (`image` becoming 2nd parameter and `image2` becoming 1st parameter) and apply Erosion1, Dilation1, Opening1, and Closing1 respectively:
