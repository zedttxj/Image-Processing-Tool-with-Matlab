# FUNCTIONS-CODES.pdf

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
    After three dilations, we have generated all possible subsets of 𝐴, mimicking how binary toggling would work.  

- Effects: This **reduces computation time** from `O(2^(|A|))` (where `|A|` is the length of set A or the number of `1`s of matrix A) in the set-based approach to `O((max(rows(𝐴)) x max(cols(𝐴)))⁴)` for the `matrixDecomposition` function that transforms the input matrices.
- Recommendation:
  - Use Matrix-Based Dilation when `|𝐴|` is large enough (ideally below 676) and `max(rows(𝐴))` or `max(cols(𝐴))` is not too big.
  - Use Set-Based Dilation (introduced in the below section) when `|𝐴|` is small enough (ideally below 36).  

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

