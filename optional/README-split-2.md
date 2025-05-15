# FUNCTION2.pdf
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

- Effects: This **reduces computation time** from `O(2^(|𝐴|))` (where `|𝐴|` is the length of set 𝐴 or the number of `1`s of matrix 𝐴) in the set-based approach to `O((max(rows(𝐴)) x max(cols(𝐴)))⁴)` for the `matrixDecomposition` function that transforms the input matrices.
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
  ![{116ED977-56BE-4C20-801B-6134A69B4FCA}](https://github.com/user-attachments/assets/f3a72409-7f77-4641-a8ed-90bea9ead0af)  

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

- λ = (7, 4, 3, 2)  
- λ′ = (5, 3, 1)

Then:  

- `PD(λ, λ′) = (11, 10, 9, 8, 4, 2)`  
- `f₍₇,₄,₃,₂₎ ⊙ f₍₅,₃,₁₎ = f₍₁₂,₁₁,₁₀,₉,₅,₃₎`

We can conclude that `ƒ_{λ} ⊙ ƒ_{λ′} = ƒ_{PD(λ, λ′) + 1}`
