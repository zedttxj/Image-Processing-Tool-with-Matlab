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

A⊕B={ (a,b) + (c,d) | (a,b) ∈ A, (c,d) ∈ B }  

For every point `(a,b)` in `A`, we add all points `(c,d)` from `B` to generate the dilated result.  
