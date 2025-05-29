# Defining ASf, ASg, and AJF
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

## `ImageProcessor.sum_operator(A, B)` (⊛)

### Purpose:
This function implements a simple coordinate-wise addition of two sets A and B (each represented as a 2D matrix of coordinates), after sorting and removing duplicates. It is used to define the custom operation `⊛` in Poisson set.

### Mathematical Definition of ⊛  

Given:
- `A = [a₁; a₂; ...; aₙ],`
- `B = [b₁; b₂; ...; bₖ],`
with each `aᵢ = [xᵢ yᵢ]`, and likewise for `bᵢ`, the operation is: `A ⊛ B = C`, where `Cᵢ = aᵢ + bᵢ = [xᵢ + xᵢ′, yᵢ + yᵢ′]` for each row i up to min(n, k) and the remaining rows are copied from the longer matrix.  

Both A and B are sorted and deduplicated beforehand using unique(..., 'rows').

# Poisson Sets  

**Definition:** `Let B ⊆ E²`. I will use `A = {(1,0),(2,1),(2,4),(3,5),(4,8)}` throughout these examples:
```matlab
A = [
    1 0;
    2 1;
    2 4;
    3 5;
    4 8
];
```  
Additionally, I will use `imshow(ImageProcessor.coordsToMatrix(<set>))` to show the image of the set.

## 1. B is called a Poisson set of type I if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(J(θᴀ), R₁)⊕A⁽²⁾(J(θᴀ), R₂)`
- Example code:
```matlab
AJF_1 = ImageProcessor.AJF(A,2,1); % 2nd derivative over all columns
AJF_2 = ImageProcessor.AJF(A,2,2); % 2nd derivative over all columns with column-swapped version of A
B = ImageProcessor.dilationSet(AJF_1, AJF_2); % AJF(A,2,1) ⊕ AJF(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.AJF(A,2,1):" max(AJF_1)]);
disp(["Size of ImageProcessor.AJF(A,2,2):" max(AJF_2)]);
disp(["Size of AJF(A, 2, 1) ⊕ AJF(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.AJF(A,2,1)"    "80"    "160"
    
        "Size of ImageProcessor.AJF(A,2,2)"    "160"    "80"
    
        "Size of AJF(A, 2, 1) ⊕ AJF(A, 2, 2)"    "240"    "240"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.AJF(A,2,1)`:  
 
    ![{52DFB07C-6519-4B9C-A9C9-66031A778574}](https://github.com/user-attachments/assets/58eb87c4-c5eb-4000-8a08-6dcac22084d6)  
  - Image of `ImageProcessor.AJF(A,2,2)`:
 
    ![{553DB7D2-949D-4C42-B062-4CDDDC2A9BB6}](https://github.com/user-attachments/assets/09508fc7-c411-48e2-b76c-14112e21e8f4)  
  - Image of `AJF(A, 2, 1) ⊕ AJF(A, 2, 2)`:

    ![{AFB6CD6F-77AA-40D2-A172-08DE26A30876}](https://github.com/user-attachments/assets/73b0e657-1505-4e1f-bf4d-c6b589fcf7b3)  

## 2. B is called a Poisson set of type II if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊕A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.dilationSet(ASf_1, ASf_2); % ASf(A,2,1) ⊕ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASf(A, 2, 1) ⊕ ASf(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASf(A, 2, 1) ⊕ ASf(A, 2, 2)"    "84"    "168"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{BE68F33B-104C-4F71-98D1-715809C9DF7E}](https://github.com/user-attachments/assets/63ae0a52-a8ca-43fe-89ed-64b1fc405481)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{3CE1C96B-8CA5-4162-A99B-3ADA280025A5}](https://github.com/user-attachments/assets/215efe8e-4d82-43c7-8f97-33ff06b7a9ec)  
  - Image of `ASf(A, 2, 1) ⊕ ASf(A, 2, 2)`:

    ![{B7A7A00E-B892-48DB-BDD0-15E3A2B04287}](https://github.com/user-attachments/assets/3dc47d68-b45e-4d35-bb9c-d00230647dea)  

## 3. B is called a Poisson set of type III if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊕A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.dilationSet(ASg_1, ASg_2); % ASg(A,2,1) ⊕ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASg(A, 2, 1) ⊕ ASg(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASg(A, 2, 1) ⊕ ASg(A, 2, 2)"    "168"    "84"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{68672B17-46E6-4DBB-BBB3-367BE9173637}](https://github.com/user-attachments/assets/e2ddf59e-cec8-48b9-bb8f-4d17446a118d)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{FD993303-C721-4E30-82FE-73468254E1B9}](https://github.com/user-attachments/assets/8121e1b9-06a5-497e-82a0-7a9f6c3a79e8)    
  - Image of `ASg(A, 2, 1) ⊕ ASg(A, 2, 2)`:

    ![{77BFE00A-B653-4DF8-AD35-AA691D2E5852}](https://github.com/user-attachments/assets/37c32e40-e4a8-43cd-8302-ea1735910c23)    

## 6. B is called a Poisson set of type VI if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊕A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.dilationSet(ASf_1, ASg_2); % ASf(A,2,1) ⊕ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASf(A, 2, 1) ⊕ ASg(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASf(A, 2, 1) ⊕ ASg(A, 2, 2)"    "240"    "12"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{BE68F33B-104C-4F71-98D1-715809C9DF7E}](https://github.com/user-attachments/assets/63ae0a52-a8ca-43fe-89ed-64b1fc405481)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{FD993303-C721-4E30-82FE-73468254E1B9}](https://github.com/user-attachments/assets/8121e1b9-06a5-497e-82a0-7a9f6c3a79e8)    
  - Image of `ASf(A, 2, 1) ⊕ ASg(A, 2, 2)`:

    ![{86F0D556-1170-48DC-A21B-335BA897D211}](https://github.com/user-attachments/assets/e4a853e5-8af2-45bb-ad95-c0dc4b78740b)  
    
## 7. B is called a Poisson set of type VII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊕A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.dilationSet(ASg_1, ASf_2); % ASg(A,2,1) ⊕ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASg(A, 2, 1) ⊕ ASf(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASg(A, 2, 1) ⊕ ASf(A, 2, 2)"    "12"    "240"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{68672B17-46E6-4DBB-BBB3-367BE9173637}](https://github.com/user-attachments/assets/e2ddf59e-cec8-48b9-bb8f-4d17446a118d)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{3CE1C96B-8CA5-4162-A99B-3ADA280025A5}](https://github.com/user-attachments/assets/215efe8e-4d82-43c7-8f97-33ff06b7a9ec)  
  - Image of `ASg(A, 2, 1) ⊕ ASf(A, 2, 2)`:

    ![{145A0788-1129-4481-AAFC-47814412DCC9}](https://github.com/user-attachments/assets/5f188961-640c-4ae1-a86f-a246d1f0a643)  

## 8. B is called a Poisson set of type VIII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(J(θᴀ), R₁)⊛A⁽²⁾(J(θᴀ), R₂)`
- Example code:
```matlab
AJF_1 = ImageProcessor.AJF(A,2,1); % 2nd derivative over all columns
AJF_2 = ImageProcessor.AJF(A,2,2); % 2nd derivative over all columns with column-swapped version of A
B = ImageProcessor.sum_operator(AJF_1, AJF_2); % AJF(A,2,1) ⊛ AJF(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.AJF(A,2,1):" max(AJF_1)]);
disp(["Size of ImageProcessor.AJF(A,2,2):" max(AJF_2)]);
disp(["Size of AJF(A, 2, 1) ⊛ AJF(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.AJF(A,2,1)"    "80"    "160"
    
        "Size of ImageProcessor.AJF(A,2,2)"    "160"    "80"
    
        "Size of AJF(A, 2, 1) ⊛ AJF(A, 2, 2)"    "240"    "240"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.AJF(A,2,1)`:  
 
    ![{52DFB07C-6519-4B9C-A9C9-66031A778574}](https://github.com/user-attachments/assets/58eb87c4-c5eb-4000-8a08-6dcac22084d6)  
  - Image of `ImageProcessor.AJF(A,2,2)`:
 
    ![{553DB7D2-949D-4C42-B062-4CDDDC2A9BB6}](https://github.com/user-attachments/assets/09508fc7-c411-48e2-b76c-14112e21e8f4)  
  - Image of `AJF(A, 2, 1) ⊛ AJF(A, 2, 2)` (the coordinates are symmetric, where `xᵢ=yᵢ`):

    ![{913B6A1E-2943-4D9E-A472-DCAE8A5E4154}](https://github.com/user-attachments/assets/b656c61d-9e43-44c9-a059-1877e4ad1e89)

## 9. B is called a Poisson set of type IX if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊛A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.sum_operator(ASf_1, ASf_2); % ASf(A,2,1) ⊛ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASf(A, 2, 1) ⊛ ASf(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,…"    "80"    "8"
    
        "Size of ImageProcessor.ASf(A,2,…"    "4"    "160"
    
        "Size of ASf(A, 2, 1) ⊛ ASf(A, 2…"    "84"    "160"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{BE68F33B-104C-4F71-98D1-715809C9DF7E}](https://github.com/user-attachments/assets/63ae0a52-a8ca-43fe-89ed-64b1fc405481)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{3CE1C96B-8CA5-4162-A99B-3ADA280025A5}](https://github.com/user-attachments/assets/215efe8e-4d82-43c7-8f97-33ff06b7a9ec)  
  - Image of `ASf(A, 2, 1) ⊛ ASf(A, 2, 2)` (not symmetric as their coordinates are `{(1,29),(2,68),(14,160),(39,1),(84,4)}`:

    ![{F07AEF0A-8E5C-466F-B81B-A70D97AA1B59}](https://github.com/user-attachments/assets/0926c934-65ff-459f-a9b3-9017708b7c5a)

## 10. B is called a Poisson set of type X if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊛A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.sum_operator(ASg_1, ASg_2); % ASg(A,2,1) ⊛ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASg(A, 2, 1) ⊛ ASg(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASg(A, 2, 1) ⊛ ASg(A, 2, 2)"    "168"    "81"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{68672B17-46E6-4DBB-BBB3-367BE9173637}](https://github.com/user-attachments/assets/e2ddf59e-cec8-48b9-bb8f-4d17446a118d)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{FD993303-C721-4E30-82FE-73468254E1B9}](https://github.com/user-attachments/assets/8121e1b9-06a5-497e-82a0-7a9f6c3a79e8)    
  - Image of `ASg(A, 2, 1) ⊛ ASg(A, 2, 2)` (has a set `{(0,15),(1,40),(28,81),(65,2),(168,2)}`):

    ![{EDCAF0AB-38B4-47ED-969A-643DE0389728}](https://github.com/user-attachments/assets/c77c5b2e-4bbf-4f53-9a11-2829dd954250)    

## 13. B is called a Poisson set of type XIII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊛A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.sum_operator(ASf_1, ASg_2); % ASf(A,2,1) ⊛ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASf(A, 2, 1) ⊛ ASg(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASf(A, 2, 1) ⊛ ASg(A, 2, 2)"    "240"    "12"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{BE68F33B-104C-4F71-98D1-715809C9DF7E}](https://github.com/user-attachments/assets/63ae0a52-a8ca-43fe-89ed-64b1fc405481)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{FD993303-C721-4E30-82FE-73468254E1B9}](https://github.com/user-attachments/assets/8121e1b9-06a5-497e-82a0-7a9f6c3a79e8)    
  - Image of `ASf(A, 2, 1) ⊛ ASg(A, 2, 2)`:

    ![{8E02C979-DC0E-4C09-A01B-9ECC522BE2D2}](https://github.com/user-attachments/assets/4cf7942b-e51d-4225-87be-265699089c48)    
    
## 14. B is called a Poisson set of type XIV if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊛A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.sum_operator(ASg_1, ASf_2); % ASg(A,2,1) ⊛ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASg(A, 2, 1) ⊛ ASf(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASg(A, 2, 1) ⊛ ASf(A, 2, 2)"    "12"    "240"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{68672B17-46E6-4DBB-BBB3-367BE9173637}](https://github.com/user-attachments/assets/e2ddf59e-cec8-48b9-bb8f-4d17446a118d)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{3CE1C96B-8CA5-4162-A99B-3ADA280025A5}](https://github.com/user-attachments/assets/215efe8e-4d82-43c7-8f97-33ff06b7a9ec)  
  - Image of `ASg(A, 2, 1) ⊛ ASf(A, 2, 2)`:

    ![{CFB1C63F-95A9-4F6A-A6E7-636F35CDE7CC}](https://github.com/user-attachments/assets/9021c01a-19bf-4a38-99b8-587935f4be87)  

## 15. B is called a Poisson set of type XV if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(J(θᴀ), R₁)⊙A⁽²⁾(J(θᴀ), R₂)`
- Example code:
```matlab
AJF_1 = ImageProcessor.AJF(A,2,1); % 2nd derivative over all columns
AJF_2 = ImageProcessor.AJF(A,2,2); % 2nd derivative over all columns with column-swapped version of A
B = ImageProcessor.product_operator(AJF_1, AJF_2); % AJF(A,2,1) ⊙ AJF(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.AJF(A,2,1):" max(AJF_1)]);
disp(["Size of ImageProcessor.AJF(A,2,2):" max(AJF_2)]);
disp(["Size of AJF(A, 2, 1) ⊙ AJF(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.AJF(A,2,1)"    "80"    "160"
    
        "Size of ImageProcessor.AJF(A,2,2)"    "160"    "80"
    
        "Size of AJF(A, 2, 1) ⊙ AJF(A, 2, 2)"    "12800"    "12800"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.AJF(A,2,1)`:  
 
    ![{52DFB07C-6519-4B9C-A9C9-66031A778574}](https://github.com/user-attachments/assets/58eb87c4-c5eb-4000-8a08-6dcac22084d6)  
  - Image of `ImageProcessor.AJF(A,2,2)`:
 
    ![{553DB7D2-949D-4C42-B062-4CDDDC2A9BB6}](https://github.com/user-attachments/assets/09508fc7-c411-48e2-b76c-14112e21e8f4)  
  - The image below has very large size (a set as `{(288,288),(1584,1584),(6000,6000),(10560,10560),(12800,12800)}`). For that reason, I use dilation to enhance visualization (`C = ones([8 8]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(floor(B)/10),C));`) instead. Image of `AJF(A, 2, 1) ⊙ AJF(A, 2, 2)` (the coordinates are symmetric, where `xᵢ=yᵢ`):

    ![{25D08689-6C1F-4684-8DD0-DFBA6E9845B0}](https://github.com/user-attachments/assets/55c619d6-bba7-4038-815d-63922bb9faf6)  

## 16. B is called a Poisson set of type XVI if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊙A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.product_operator(ASf_1, ASf_2); % ASf(A,2,1) ⊙ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASf(A, 2, 1) ⊙ ASf(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASf(A, 2, 1) ⊙ ASf(A, 2, 2)"    "384"    "1304"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{BE68F33B-104C-4F71-98D1-715809C9DF7E}](https://github.com/user-attachments/assets/63ae0a52-a8ca-43fe-89ed-64b1fc405481)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{3CE1C96B-8CA5-4162-A99B-3ADA280025A5}](https://github.com/user-attachments/assets/215efe8e-4d82-43c7-8f97-33ff06b7a9ec)  
  - I also use dilation to enhance visualization of this image (`C = ones([8 8]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(B),C));`). Image of `ASf(A, 2, 1) ⊙ ASf(A, 2, 2)` (not symmetric as their coordinates are `{(0,120),(0,492),(12,1280),(60,1304),(176,156),(268,400),(316,640),(384,0),(320,0)}`:

    ![{86F419AC-9383-4F4F-8C28-63F1530B7A41}](https://github.com/user-attachments/assets/8a28aec3-4d62-4092-aefd-21aacf8b1859)
      
## 17. B is called a Poisson set of type XVII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊙A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.product_operator(ASg_1, ASg_2); % ASg(A,2,1) ⊙ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASg(A, 2, 1) ⊙ ASg(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASg(A, 2, 1) ⊙ ASg(A, 2, 2)"    "1280"    "396"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{68672B17-46E6-4DBB-BBB3-367BE9173637}](https://github.com/user-attachments/assets/e2ddf59e-cec8-48b9-bb8f-4d17446a118d)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{FD993303-C721-4E30-82FE-73468254E1B9}](https://github.com/user-attachments/assets/8121e1b9-06a5-497e-82a0-7a9f6c3a79e8)    
  - Image of `ASg(A, 2, 1) ⊙ ASg(A, 2, 2)` (has a set `{(0,36),(0,156),(0,396),(24,380),(156,176),(520,232),(1132,160),(1280,0),(1280,0)}`):

    ![{54A2F44F-6C88-42C6-B9F9-27FB7086BA76}](https://github.com/user-attachments/assets/c33d3e43-86d1-4c61-b0cc-13049657069b)    

## 20. B is called a Poisson set of type XVIII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊙A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.product_operator(ASf_1, ASg_2); % ASf(A,2,1) ⊙ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASf(A, 2, 1) ⊙ ASg(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASf(A, 2, 1) ⊙ ASg(A, 2, 2)"    "12800"    "44"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{BE68F33B-104C-4F71-98D1-715809C9DF7E}](https://github.com/user-attachments/assets/63ae0a52-a8ca-43fe-89ed-64b1fc405481)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{FD993303-C721-4E30-82FE-73468254E1B9}](https://github.com/user-attachments/assets/8121e1b9-06a5-497e-82a0-7a9f6c3a79e8)    
  - I use `C = ones([64 64]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(B),C));` to display the image. This is needed because B has large x-coordinates, making the image too narrow to see clearly. Dilation with a 64×64 kernel makes the points visible as the set `{(0,15),(0,44),(0,37),(0,21),(288,42),(1584,33),(6000,6),(10560,10),(12800,8)}` has long x-coordinate. Image of `ASf(A, 2, 1) ⊙ ASg(A, 2, 2)`:

    ![{AD2668CC-649C-4A4B-9A49-2CC41F8A705E}](https://github.com/user-attachments/assets/47e052f6-801f-4134-8f30-a061508b1588)      
    
## 21. B is called a Poisson set of type XIX if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊙A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.product_operator(ASg_1, ASf_2); % ASg(A,2,1) ⊙ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASg(A, 2, 1) ⊙ ASf(A, 2, 2):" max(B)]);
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASg(A, 2, 1) ⊙ ASf(A, 2, 2)"    "47"    "12800"
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{68672B17-46E6-4DBB-BBB3-367BE9173637}](https://github.com/user-attachments/assets/e2ddf59e-cec8-48b9-bb8f-4d17446a118d)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{3CE1C96B-8CA5-4162-A99B-3ADA280025A5}](https://github.com/user-attachments/assets/215efe8e-4d82-43c7-8f97-33ff06b7a9ec)  
  - I use `C = ones([64 64]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(B),C));` to display the image. This is needed because B has large x-coordinates, making the image too narrow to see clearly. Dilation with a 64×64 kernel makes the points visible as the set `{(0,288),(1,1584),(6,6000),(15,10560),(29,12800),(42,0),(47,0),(44,0),(32,0)}` has long y-coordinate. Image of `ASg(A, 2, 1) ⊙ ASf(A, 2, 2)`:

    ![{FAB5944F-3183-44F8-AA90-ADD7DC60E65A}](https://github.com/user-attachments/assets/40416bc6-841e-43b4-9945-dc04798bd798)    
