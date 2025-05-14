
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
- `f₍₇,₄,₃,₂₎⊙f₍₅,₃,₁₎=f₍₁₂,₁₁,₁₀,₉,₅,₃₎`

We can conclude that `ƒ_{λ}⊙ƒ_{λ′}=ƒ_{PD(λ, λ′)+1}`
