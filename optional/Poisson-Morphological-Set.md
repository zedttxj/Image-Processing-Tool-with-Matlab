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
      24     0
      60     4
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
  ![{D6FD22CA-7C9B-4848-B7D6-D0304C04B69E}](https://github.com/user-attachments/assets/ded4dc3f-c057-4419-9a14-34154d55243b)

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
%     12     4
%     36     5
%     80     8

% ImageProcessor.ASf(A,2,2) should be like this:
% 
%      2    24
%      3    60
%      4   160

```

- Visual outputs:
  - Image of A:

    ![{31DF0FA4-0166-4127-B7E0-8B432B67D9A2}](https://github.com/user-attachments/assets/1712ef23-deed-4c4f-beee-fdb5a5e5b91a)
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{49898FD2-6BDA-4B83-A413-9BF88A3A5BBC}](https://github.com/user-attachments/assets/36e43e1c-4a78-4f1c-bacb-7e7070123f20)
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{8F44935A-7EB0-4490-BC87-11EA7AE58A19}](https://github.com/user-attachments/assets/326ead04-ce56-4c75-a67d-1abb64a70002)  
  - Image of B:

    ![{07B122BB-0E50-4E1A-895A-1DF63F1A2DAF}](https://github.com/user-attachments/assets/140c8e39-7e21-4c0a-8b18-8423fe9c0034)

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
            "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
        
            "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
        
            "Size of ASf(A, 2, 1) ⊕ ASf(A, 2, 2)"    "84"    "168"

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
- If `ASf(A, 2, 1)` yields:
```matlab
>> 
    24     0
    60     4
```
- Then `ASg(A, 2, 1)` will return:
```matlab
>> 
     0    24
     4    60
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
    24     0
    60    48
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
     0    24
    48    60
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
  ![{03799FBD-2EA0-4BA5-96C1-0E95BE3B8C68}](https://github.com/user-attachments/assets/575b1aa4-bff6-4035-828d-2ccf0d6b092c)

## `ImageProcessor.sum_operator(A, B)` (`sum_operator`)
**Symbol:** `⊛`
### Purpose:
This function implements a simple coordinate-wise addition of two sets A and B (each represented as a 2D matrix of coordinates), after sorting and removing duplicates. It is used to define the custom operation `⊛` in Poisson set.

### Mathematical Definition of `sum_operator`  
Given:
- `A = [a₁; a₂; ...; aₙ]`,
- `B = [b₁; b₂; ...; bₖ]`,
with each `aᵢ = [xᵢ yᵢ]`, and likewise for `bᵢ`, the operation is: `A ⊛ B = C`, where `Cᵢ = aᵢ + bᵢ = [xᵢ + xᵢ′, yᵢ + yᵢ′]` for each row i up to min(n, k) and the remaining rows are copied from the longer matrix.  

Both A and B are sorted and deduplicated beforehand using unique(..., 'rows').

## `ImageProcessor.product_operator(A, B)` (`product_operator`)
**Symbol:** `⊙`
### Purpose:
Performs a convolution-based combination of two sets of coordinates A and B. This operator is useful for detecting joint patterns or shared structures across two derivative sets.

### Definition of `product_operator`

Given: `A = [a₁; a₂; ...], B = [b₁; b₂; ...]` with `aᵢ = [xᵢ yᵢ], bᵢ = [xᵢ′ yᵢ′]`. We define: `A ⊙ B = conv(xₐ, x_b) × conv(yₐ, y_b)`, where `conv(·,·)` is the 1D convolution of coordinate components.

This means:  
- The first column (x) of the result is `conv(A(:,1), B(:,1))`
- The second column (y) is `conv(A(:,2), B(:,2))`

### Polynomial Interpretation

Let:  
- `A(:,1)` represent coefficients of a polynomial in x, and  
- `A(:,2)` represent coefficients in y (same for B)  

Then:  `A ⊙ B = [conv(xₐ, x_b), conv(yₐ, y_b)]`, which gives the coordinate-wise convolution (i.e., multiplication) of the two polynomials.

This is equivalent to:  
- Multiplying the x-polynomials of A and B
- Multiplying the y-polynomials of A and B

### 2D Convolution Insight  
If you compute `conv2(A, B)`, then the left and right columns of the result are exactly `product_operator(A, B)`

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

## 1. Poisson set of type I
**Definition:** B is called a Poisson set of type I if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(J(θᴀ), R₁)⊕A⁽²⁾(J(θᴀ), R₂)`
- Example code:
```matlab
AJF_1 = ImageProcessor.AJF(A,2,1); % 2nd derivative over all columns
AJF_2 = ImageProcessor.AJF(A,2,2); % 2nd derivative over all columns with column-swapped version of A
B = ImageProcessor.dilationSet(AJF_1, AJF_2); % AJF(A,2,1) ⊕ AJF(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.AJF(A,2,1):" max(AJF_1)]);
disp(["Size of ImageProcessor.AJF(A,2,2):" max(AJF_2)]);
disp(["Size of AJF(A, 2, 1) ⊕ AJF(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.AJF(A,2,1)"    "80"    "160"
    
        "Size of ImageProcessor.AJF(A,2,2)"    "160"    "80"
    
        "Size of AJF(A, 2, 1) ⊕ AJF(A, 2, 2)"    "240"    "240"
    
    {(36,36),(60,72),(72,60),(96,96),(104,172),(140,196),(172,104),(196,140),(240,240)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.AJF(A,2,1)`:  
 
    ![{45A9AAD4-DDED-4768-AED7-7A2839ED4BE8}](https://github.com/user-attachments/assets/cad05314-2b0b-44c6-ad7b-65f1a5afb914)  
  - Image of `ImageProcessor.AJF(A,2,2)`:
 
    ![{69B97356-9714-42AB-9B16-B576AEA2A4CF}](https://github.com/user-attachments/assets/03a7049a-64f6-4949-a203-9c3ba38ef789)  
  - Image of `AJF(A, 2, 1) ⊕ AJF(A, 2, 2)`:

    ![{02983517-6827-4BA5-A4E9-6AD23F668A6B}](https://github.com/user-attachments/assets/949f4cfd-709a-4461-9692-a7ca6bc82cf4)  

## 2. Poisson set of type II
**Definition:** B is called a Poisson set of type II if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊕A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.dilationSet(ASf_1, ASf_2); % ASf(A,2,1) ⊕ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASf(A, 2, 1) ⊕ ASf(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display ASf(A,2,1) ⊕ ASf(A,2,2) in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASf(A, 2, 1) ⊕ ASf(A, 2, 2)"    "84"    "168"
    
    {(14,28),(15,64),(16,164),(38,29),(39,65),(40,165),(82,32),(83,68),(84,168)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{0BDFEF0F-9942-4D2A-AB7B-1A817474833C}](https://github.com/user-attachments/assets/09536ed2-42ce-4e6c-b34d-f6bb8cda8515)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{40F5FD43-B9E8-4D56-A2F0-AE84D008F917}](https://github.com/user-attachments/assets/2aae9709-d364-4eaa-9105-23e288531e5f)  
  - Image of `ASf(A, 2, 1) ⊕ ASf(A, 2, 2)`:

    ![{E898B185-C583-4915-9AAE-E5E3A02E1D77}](https://github.com/user-attachments/assets/3b4523a9-0e3b-479c-81b8-5dca194cd33f)  

## 3. Poisson set of type III
**Definition:** B is called a Poisson set of type III if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊕A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.dilationSet(ASg_1, ASg_2); % ASg(A,2,1) ⊕ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASg(A, 2, 1) ⊕ ASg(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display ASg(A,2,1) ⊕ ASg(A,2,2) in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASg(A, 2, 1) ⊕ ASg(A, 2, 2)"    "168"    "84"
    
    {(28,14),(29,38),(32,82),(64,15),(65,39),(68,83),(164,16),(165,40),(168,84)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{A6465E01-9C8C-4902-8852-F3A0A5FFF261}](https://github.com/user-attachments/assets/162f15c9-5149-48af-925f-166ac9fbc306)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{4B23FDA0-837D-465E-89BE-E0050D7F8AB0}](https://github.com/user-attachments/assets/a36d1a3a-2db6-4364-99a8-417afce7f7a9)    
  - Image of `ASg(A, 2, 1) ⊕ ASg(A, 2, 2)`:

    ![{31CB362C-C3DA-4B50-BFF4-028E14C339D4}](https://github.com/user-attachments/assets/206700ce-ff67-421e-b192-7ce72c96b9d9)    

## 6. Poisson set of type VI
**Definition:** B is called a Poisson set of type VI if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊕A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.dilationSet(ASf_1, ASg_2); % ASf(A,2,1) ⊕ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASf(A, 2, 1) ⊕ ASg(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display ASf(A,2,1) ⊕ ASg(A,2,2) in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASf(A, 2, 1) ⊕ ASg(A, 2, 2)"    "240"    "12"

    {(36,6),(60,7),(72,7),(96,8),(104,10),(140,11),(172,8),(196,9),(240,12)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{0BDFEF0F-9942-4D2A-AB7B-1A817474833C}](https://github.com/user-attachments/assets/09536ed2-42ce-4e6c-b34d-f6bb8cda8515)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{4B23FDA0-837D-465E-89BE-E0050D7F8AB0}](https://github.com/user-attachments/assets/a36d1a3a-2db6-4364-99a8-417afce7f7a9)    
  - Image of `ASf(A, 2, 1) ⊕ ASg(A, 2, 2)`:

    ![{B5569392-3C6F-4CA3-AE6E-49058BC7C658}](https://github.com/user-attachments/assets/b6736e04-1c89-465a-8c8f-53b367164687)  
    
## 7. Poisson set of type VII
**Definition:** B is called a Poisson set of type VII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊕A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.dilationSet(ASg_1, ASf_2); % ASg(A,2,1) ⊕ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASg(A, 2, 1) ⊕ ASf(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display ASg(A,2,1) ⊕ ASf(A,2,2) in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASg(A, 2, 1) ⊕ ASf(A, 2, 2)"    "12"    "240"
    
    {(6,36),(7,60),(7,72),(8,96),(8,172),(9,196),(10,104),(11,140),(12,240)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{A6465E01-9C8C-4902-8852-F3A0A5FFF261}](https://github.com/user-attachments/assets/162f15c9-5149-48af-925f-166ac9fbc306)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{40F5FD43-B9E8-4D56-A2F0-AE84D008F917}](https://github.com/user-attachments/assets/2aae9709-d364-4eaa-9105-23e288531e5f)  
  - Image of `ASg(A, 2, 1) ⊕ ASf(A, 2, 2)`:

    ![{1C3D78D0-6BA2-40EF-A88B-6654F63D9308}](https://github.com/user-attachments/assets/dd98e3c2-414b-494b-9245-ac695b0936c2)  

## 8. Poisson set of type VIII
**Definition:** B is called a Poisson set of type VIII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(J(θᴀ), R₁)⊛A⁽²⁾(J(θᴀ), R₂)`
- Example code:
```matlab
AJF_1 = ImageProcessor.AJF(A,2,1); % 2nd derivative over all columns
AJF_2 = ImageProcessor.AJF(A,2,2); % 2nd derivative over all columns with column-swapped version of A
B = ImageProcessor.sum_operator(AJF_1, AJF_2); % AJF(A,2,1) ⊛ AJF(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.AJF(A,2,1):" max(AJF_1)]);
disp(["Size of ImageProcessor.AJF(A,2,2):" max(AJF_2)]);
disp(["Size of AJF(A, 2, 1) ⊛ AJF(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.AJF(A,2,1)"    "80"    "160"
    
        "Size of ImageProcessor.AJF(A,2,2)"    "160"    "80"
    
        "Size of AJF(A, 2, 1) ⊛ AJF(A, 2, 2)"    "240"    "240"
    
    {(36,36),(96,96),(240,240)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.AJF(A,2,1)`:  
 
    ![{45A9AAD4-DDED-4768-AED7-7A2839ED4BE8}](https://github.com/user-attachments/assets/cad05314-2b0b-44c6-ad7b-65f1a5afb914)  
  - Image of `ImageProcessor.AJF(A,2,2)`:
 
    ![{69B97356-9714-42AB-9B16-B576AEA2A4CF}](https://github.com/user-attachments/assets/03a7049a-64f6-4949-a203-9c3ba38ef789)  
  - Image of `AJF(A, 2, 1) ⊛ AJF(A, 2, 2)` (the coordinates are symmetric, where `xᵢ=yᵢ`):

    ![{34E8BB79-90E0-4EAD-A940-E6715E31AB16}](https://github.com/user-attachments/assets/3baaf3c2-64a0-4352-bb7f-8191ffdd0052)

## 9. Poisson set of type IX
**Definition:** B is called a Poisson set of type IX if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊛A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.sum_operator(ASf_1, ASf_2); % ASf(A,2,1) ⊛ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASf(A, 2, 1) ⊛ ASf(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASf(A, 2, 1) ⊛ ASf(A, 2, 2)"    "84"    "168"
    
    {(14,28),(39,65),(84,168)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{0BDFEF0F-9942-4D2A-AB7B-1A817474833C}](https://github.com/user-attachments/assets/09536ed2-42ce-4e6c-b34d-f6bb8cda8515)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{40F5FD43-B9E8-4D56-A2F0-AE84D008F917}](https://github.com/user-attachments/assets/2aae9709-d364-4eaa-9105-23e288531e5f)  
  - Image of `ASf(A, 2, 1) ⊛ ASf(A, 2, 2)` (not symmetric as their coordinates are `{(1,29),(2,68),(14,160),(39,1),(84,4)}`:

    ![{14064DAE-6202-4BCD-9546-28C7C822E2B3}](https://github.com/user-attachments/assets/0e7e8571-a0e7-414a-b7a6-b53c9d31fb2d)

## 10. Poisson set of type X
**Definition:** B is called a Poisson set of type X if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊛A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.sum_operator(ASg_1, ASg_2); % ASg(A,2,1) ⊛ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASg(A, 2, 1) ⊛ ASg(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASg(A, 2, 1) ⊛ ASg(A, 2, 2)"    "168"    "84"
    
    {(28,14),(65,39),(168,84)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{A6465E01-9C8C-4902-8852-F3A0A5FFF261}](https://github.com/user-attachments/assets/162f15c9-5149-48af-925f-166ac9fbc306)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{4B23FDA0-837D-465E-89BE-E0050D7F8AB0}](https://github.com/user-attachments/assets/a36d1a3a-2db6-4364-99a8-417afce7f7a9)    
  - Image of `ASg(A, 2, 1) ⊛ ASg(A, 2, 2)` (has a set `{(0,15),(1,40),(28,81),(65,2),(168,2)}`):

    ![{ACDA7E29-752F-4E4C-B903-A32F32D2AC51}](https://github.com/user-attachments/assets/5248c9a0-4972-42b4-a08b-7535eaa8d605)      

## 13. Poisson set of type XIII
**Definition:** B is called a Poisson set of type XIII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊛A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.sum_operator(ASf_1, ASg_2); % ASf(A,2,1) ⊛ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASf(A, 2, 1) ⊛ ASg(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASf(A, 2, 1) ⊛ ASg(A, 2, 2)"    "240"    "12"
    
    {(36,6),(96,8),(240,12)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{0BDFEF0F-9942-4D2A-AB7B-1A817474833C}](https://github.com/user-attachments/assets/09536ed2-42ce-4e6c-b34d-f6bb8cda8515)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{4B23FDA0-837D-465E-89BE-E0050D7F8AB0}](https://github.com/user-attachments/assets/a36d1a3a-2db6-4364-99a8-417afce7f7a9)    
  - Image of `ASf(A, 2, 1) ⊛ ASg(A, 2, 2)`:

    ![{A9AD9185-AEC9-4DCC-A277-FBAF10EBBCAE}](https://github.com/user-attachments/assets/7e2eb0b0-dec0-4b6b-93de-898a5cb58a23)    
    
## 14. Poisson set of type XIV
**Definition:** B is called a Poisson set of type XIV if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊛A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.sum_operator(ASg_1, ASf_2); % ASg(A,2,1) ⊛ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASg(A, 2, 1) ⊛ ASf(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASg(A, 2, 1) ⊛ ASf(A, 2, 2)"    "12"    "240"
    
    {(6,36),(8,96),(12,240)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{A6465E01-9C8C-4902-8852-F3A0A5FFF261}](https://github.com/user-attachments/assets/162f15c9-5149-48af-925f-166ac9fbc306)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{40F5FD43-B9E8-4D56-A2F0-AE84D008F917}](https://github.com/user-attachments/assets/2aae9709-d364-4eaa-9105-23e288531e5f)  
  - Image of `ASg(A, 2, 1) ⊛ ASf(A, 2, 2)`:

    ![{EEE0C39C-7608-4A0F-9CFE-31C5CDF70CBB}](https://github.com/user-attachments/assets/b1babd2a-27f9-4c7f-9085-3a3fd4202fa0)  

## 15. Poisson set of type XV
**Definition:** B is called a Poisson set of type XV if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(J(θᴀ), R₁)⊙A⁽²⁾(J(θᴀ), R₂)`
- Example code:
```matlab
AJF_1 = ImageProcessor.AJF(A,2,1); % 2nd derivative over all columns
AJF_2 = ImageProcessor.AJF(A,2,2); % 2nd derivative over all columns with column-swapped version of A
B = ImageProcessor.product_operator(AJF_1, AJF_2); % AJF(A,2,1) ⊙ AJF(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.AJF(A,2,1):" max(AJF_1)]);
disp(["Size of ImageProcessor.AJF(A,2,2):" max(AJF_2)]);
disp(["Size of AJF(A, 2, 1) ⊙ AJF(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.AJF(A,2,1)"    "80"    "160"
    
        "Size of ImageProcessor.AJF(A,2,2)"    "160"    "80"
    
        "Size of AJF(A, 2, 1) ⊙ AJF(A, 2, 2)"    "12800"    "12800"
    
    {(288,288),(1584,1584),(6000,6000),(10560,10560),(12800,12800)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.AJF(A,2,1)`:  
 
    ![{45A9AAD4-DDED-4768-AED7-7A2839ED4BE8}](https://github.com/user-attachments/assets/cad05314-2b0b-44c6-ad7b-65f1a5afb914)  
  - Image of `ImageProcessor.AJF(A,2,2)`:
 
    ![{69B97356-9714-42AB-9B16-B576AEA2A4CF}](https://github.com/user-attachments/assets/03a7049a-64f6-4949-a203-9c3ba38ef789)  
  - The image below has very large size. For that reason, I use dilation to enhance visualization (`C = ones([64 64]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(B),C));`) instead. Image of `AJF(A, 2, 1) ⊙ AJF(A, 2, 2)` (the coordinates are symmetric, where `xᵢ=yᵢ`):

    ![{1A26E027-CE56-4D9C-8EBD-6DC70E8B3F11}](https://github.com/user-attachments/assets/bcf0b61a-1ce1-4f20-85ab-20c7b35e959c)  

## 16. Poisson set of type XVI
**Definition:** B is called a Poisson set of type XVI if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊙A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.product_operator(ASf_1, ASf_2); % ASf(A,2,1) ⊙ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASf(A, 2, 1) ⊙ ASf(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASf(A, 2, 1) ⊙ ASf(A, 2, 2)"    "384"    "1280"
    
    {(24,96),(108,360),(316,1132),(384,1280),(320,1280)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{0BDFEF0F-9942-4D2A-AB7B-1A817474833C}](https://github.com/user-attachments/assets/09536ed2-42ce-4e6c-b34d-f6bb8cda8515)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{40F5FD43-B9E8-4D56-A2F0-AE84D008F917}](https://github.com/user-attachments/assets/2aae9709-d364-4eaa-9105-23e288531e5f)  
  - I also use dilation to enhance visualization of this image (`C = ones([8 8]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(B),C));`). Image of `ASf(A, 2, 1) ⊙ ASf(A, 2, 2)`:

    ![{1806B1D8-9598-4D48-9503-B4990851B36C}](https://github.com/user-attachments/assets/6d72e762-68cf-4b86-a13a-cd286247e639)
      
## 17. Poisson set of type XVII
**Definition:** B is called a Poisson set of type XVII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊙A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.product_operator(ASg_1, ASg_2); % ASg(A,2,1) ⊙ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASg(A, 2, 1) ⊙ ASg(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASg(A, 2, 1) ⊙ ASg(A, 2, 2)"    "1280"    "384"
    
    {(96,24),(360,108),(1132,316),(1280,384),(1280,320)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{A6465E01-9C8C-4902-8852-F3A0A5FFF261}](https://github.com/user-attachments/assets/162f15c9-5149-48af-925f-166ac9fbc306)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{4B23FDA0-837D-465E-89BE-E0050D7F8AB0}](https://github.com/user-attachments/assets/a36d1a3a-2db6-4364-99a8-417afce7f7a9)    
  - Image of `ASg(A, 2, 1) ⊙ ASg(A, 2, 2)`:

    ![{69C6E8F1-ADB1-48C8-8DD8-802A66BDE7A3}](https://github.com/user-attachments/assets/7ef72aff-abe9-4291-a9c3-e4e0024c8748)    

## 20. Poisson set of type XVIII
**Definition:** B is called a Poisson set of type XVIII if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Fᴀ), R₁)⊙A⁽²⁾(S(Gᴀ), R₂)`
- Example code:
```matlab
ASf_1 = ImageProcessor.ASf(A,2,1); % 2nd derivative along column 1
ASg_2 = ImageProcessor.ASg(A,2,2); % 2nd derivative along column 2 with column-swapped of A
B = ImageProcessor.product_operator(ASf_1, ASg_2); % ASf(A,2,1) ⊙ ASg(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASf(A,2,1):" max(ASf_1)]);
disp(["Size of ImageProcessor.ASg(A,2,2):" max(ASg_2)]);
disp(["Size of ASf(A, 2, 1) ⊙ ASg(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASf(A,2,1)"    "80"    "8"
    
        "Size of ImageProcessor.ASg(A,2,2)"    "160"    "4"
    
        "Size of ASf(A, 2, 1) ⊙ ASg(A, 2, 2)"    "12800"    "47"
    
    {(288,8),(1584,22),(6000,47),(10560,44),(12800,32)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASf(A,2,1)`:  
 
    ![{0BDFEF0F-9942-4D2A-AB7B-1A817474833C}](https://github.com/user-attachments/assets/09536ed2-42ce-4e6c-b34d-f6bb8cda8515)    
  - Image of `ImageProcessor.ASg(A,2,2)`:
 
    ![{4B23FDA0-837D-465E-89BE-E0050D7F8AB0}](https://github.com/user-attachments/assets/a36d1a3a-2db6-4364-99a8-417afce7f7a9)    
  - I use `C = ones([64 64]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(B),C));` to display the image. This is needed because B has large x-coordinates, making the image too narrow to see clearly. Image of `ASf(A, 2, 1) ⊙ ASg(A, 2, 2)`:

    ![{B93B3877-39E4-4B29-86E7-BE791B3D7F60}](https://github.com/user-attachments/assets/65b32d89-6535-4980-8eb2-29dc66e3fb43)      
    
## 21. Poisson set of type XIX
**Definition:** B is called a Poisson set of type XIX if there exists a set `A ⊆ E²` such that `B = A⁽²⁾(S(Gᴀ), R₁)⊙A⁽²⁾(S(Fᴀ), R₂)`
- Example code:
```matlab
ASg_1 = ImageProcessor.ASg(A,2,1); % 2nd derivative along column 1 with column-swapped of A
ASf_2 = ImageProcessor.ASf(A,2,2); % 2nd derivative along column 2
B = ImageProcessor.product_operator(ASg_1, ASf_2); % ASg(A,2,1) ⊙ ASf(A,2,2)
disp("Size is heigh-width:");
disp(["Size of ImageProcessor.ASg(A,2,1):" max(ASg_1)]);
disp(["Size of ImageProcessor.ASf(A,2,2):" max(ASf_2)]);
disp(["Size of ASg(A, 2, 1) ⊙ ASf(A, 2, 2):" max(B)]);
txt = "{" + strjoin(compose('(%d,%d)', B), ',') + "}";
disp(txt); % display B in the set form
```
- Visual Output:
  - **Image Size Inspection:**
    ```matlab
    >> 
    Size is heigh-width:
        "Size of ImageProcessor.ASg(A,2,1)"    "8"    "80"
    
        "Size of ImageProcessor.ASf(A,2,2)"    "4"    "160"
    
        "Size of ASg(A, 2, 1) ⊙ ASf(A, 2, 2)"    "47"    "12800"
    
    {(8,288),(22,1584),(47,6000),(44,10560),(32,12800)}
    ```
  - Image of A:

    ![{D466457A-C043-4898-B22B-C7FC1DB0E7F2}](https://github.com/user-attachments/assets/03a61517-3e51-452c-8353-e97fa6054955)  
  - Image of `ImageProcessor.ASg(A,2,1)`:  
 
    ![{A6465E01-9C8C-4902-8852-F3A0A5FFF261}](https://github.com/user-attachments/assets/162f15c9-5149-48af-925f-166ac9fbc306)  
  - Image of `ImageProcessor.ASf(A,2,2)`:
 
    ![{40F5FD43-B9E8-4D56-A2F0-AE84D008F917}](https://github.com/user-attachments/assets/2aae9709-d364-4eaa-9105-23e288531e5f)  
  - I use `C = ones([64 64]);imshow(ImageProcessor.Dilation1(ImageProcessor.coordsToMatrix(B),C));` to display the image. This is needed because B has large x-coordinates, making the image too narrow to see clearly. Image of `ASg(A, 2, 1) ⊙ ASf(A, 2, 2)`:

    ![{D1E1E4E6-1B6D-483C-A024-BCA86C551DE7}](https://github.com/user-attachments/assets/e7376a2f-fda5-4f15-8c82-ca8a4f26c778)   
