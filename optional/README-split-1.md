# FUNCTIONS-CODES.pdf

## ASf(A, d, ind)
- Input:
  - A (required): A 2D numerical matrix containing logical, integer, or decimal values.  
  - d (required): An integer representing the number of times the derivative is computed.  
  - ind (required): An integer representing the column or the columns of A to differentiate. Only that column is differentiated while the others remain unchanged.
- Output:
  - Jacobian (a 2D matrix): A 2D matrix representing the derivatives of `A` after `d` differentiations.
- Explanation: The `ASf` function computes the derivative of a matrix `A` a specified number of times (`d`). If an optional column index (`ind`) is provided, only that column is differentiated.
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
