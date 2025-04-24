# PDilation is non-injective
Like how Dilation is non-injective, PDilation is also non-injective. Hence, finding all `(A, B)` pairs that lead to a known result `Cs` is a set-inversion problem.
It's a nonlinear algebraic structure like(A, B) ↦ A ⊕ B  (where ⊕ is PDilation).
# Redefine PDilation
Assume that A ⊕ B = Cs. We can define PDilation as follow:
Cs(k) = max( A(i) + B(j) ) for all possible i + j = k - 1
This is exactly max-plus convolution, which is:
- Nonlinear
- Non-injective (i.e., multiple inputs can map to the same output)
- Associative
- Commonly used in morphological image processing and tropical algebra.
From here, we can infer that Cs(1) is always equal to A(1) + B(1) as it's the only value used to calculate Cs(1). The same thing with Cs(end) where A(end) + B(end) is the only value being used to calculate Cs(end).
# divide-and-conquer method may not be applicable in the case of reversedPDilation
The original problem is this:
Given D, find all (A, B) such that A ⊕ B = D.  
Whis is exactly like convolution inversion but under max-plus algebra. Because PDilation is non-injective (considering some special cases below), the normal divide-and-conquer method may not be applicable. However, considering the associative and commutative properties, we may be able to apply this method.
# Some special cases:
For testing, I will use `reversedPDilationv2` for faster testing process. However, `reversedPDilationv2` is still under testing and may not work as intended.
## Case 1: A ⊕ B = A ⊕ C where B ≠ C
- Example code:
  ```matlab
  disp(ImageProcessor.reversedPDilationv2([11    10     9     8     4     2]));
  ```
- Run the code:
  ```matlab
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
  ```
Here, A = `[2 1]`, B = `[9 7 7 3 1]`, and C = `[9 8 7 3 1]`. However, Cs = A ⊕ B = A ⊕ C = `[11    10     9     8     4     2]`.
**1st fact:** You should notice that the length of B (or C) is always larger than 2. The reason is that Cs(1) is always equal to B(1) + C(1) as it's the only value used to calculate Cs(1). The same thing with Cs(end) where C(end) + B(end) is the only value being used to calculate Cs(end). If one of these (B(1), C(1), B(end), and C(end)) changes, the original Cs will be change as well without changing A.
## Case 2: A = D where (A ⊕ B) ⊕ C = D ⊕ (B ⊕ C) and B and C are constant partitions
- Example code:
  ```matlab
  disp(ImageProcessor.reversedPDilationv2([17    16    12     10     8     7     3]));
  ```
- Run the code:
  ```matlab
    {[                1]}    {[17 16 12 10 8 7 3]}
    {[                2]}    {[ 16 15 11 9 7 6 2]}
    {[                3]}    {[ 15 14 10 8 6 5 1]}
    {[              2 1]}    {[   16 12 10 7 7 3]}
    {[              2 1]}    {[   16 12 10 8 7 3]}
    {[              3 2]}    {[    15 11 9 6 6 2]}
    {[              3 2]}    {[    15 11 9 7 6 2]}
    {[              4 3]}    {[    14 10 8 5 5 1]}
    {[              4 3]}    {[    14 10 8 6 5 1]}
    {[              5 1]}    {[    13 12 6 6 4 3]}
    {[              5 1]}    {[    13 12 7 6 4 3]}
    {[              5 1]}    {[    13 12 8 6 4 3]}
    {[              6 2]}    {[    12 11 5 5 3 2]}
    {[              6 2]}    {[    12 11 6 5 3 2]}
    {[              6 2]}    {[    12 11 7 5 3 2]}
    {[              7 3]}    {[    11 10 4 4 2 1]}
    {[              7 3]}    {[    11 10 5 4 2 1]}
    {[              7 3]}    {[    11 10 6 4 2 1]}
    {[            6 5 1]}    {[       12 6 6 3 3]}
    {[            6 5 1]}    {[       12 6 6 4 3]}
    {[            6 5 1]}    {[       12 7 6 3 3]}
    {[            6 5 1]}    {[       12 7 6 4 3]}
    {[            6 5 1]}    {[       12 8 6 3 3]}
    {[            6 5 1]}    {[       12 8 6 4 3]}
    {[            7 6 2]}    {[       11 5 5 2 2]}
    {[            7 6 2]}    {[       11 5 5 3 2]}
    {[            7 6 2]}    {[       11 6 5 2 2]}
    {[            7 6 2]}    {[       11 6 5 3 2]}
    {[            7 6 2]}    {[       11 7 5 2 2]}
    {[            7 6 2]}    {[       11 7 5 3 2]}
    {[            8 7 3]}    {[       10 4 4 1 1]}
    {[            8 7 3]}    {[       10 4 4 2 1]}
    {[            8 7 3]}    {[       10 5 4 1 1]}
    {[            8 7 3]}    {[       10 5 4 2 1]}
    {[            8 7 3]}    {[       10 6 4 1 1]}
    {[            8 7 3]}    {[       10 6 4 2 1]}
    {[       10 4 4 1 1]}    {[            8 7 3]}
    {[       10 4 4 2 1]}    {[            8 7 3]}
    {[       10 5 4 1 1]}    {[            8 7 3]}
    {[       10 5 4 2 1]}    {[            8 7 3]}
    {[       10 6 4 1 1]}    {[            8 7 3]}
    {[       10 6 4 2 1]}    {[            8 7 3]}
    {[       11 5 5 2 2]}    {[            7 6 2]}
    {[       11 5 5 3 2]}    {[            7 6 2]}
    {[       11 6 5 2 2]}    {[            7 6 2]}
    {[       11 6 5 3 2]}    {[            7 6 2]}
    {[       11 7 5 2 2]}    {[            7 6 2]}
    {[       11 7 5 3 2]}    {[            7 6 2]}
    {[       12 6 6 3 3]}    {[            6 5 1]}
    {[       12 6 6 4 3]}    {[            6 5 1]}
    {[       12 7 6 3 3]}    {[            6 5 1]}
    {[       12 7 6 4 3]}    {[            6 5 1]}
    {[       12 8 6 3 3]}    {[            6 5 1]}
    {[       12 8 6 4 3]}    {[            6 5 1]}
    {[    11 10 4 4 2 1]}    {[              7 3]}
    {[    11 10 5 4 2 1]}    {[              7 3]}
    {[    11 10 6 4 2 1]}    {[              7 3]}
    {[    12 11 5 5 3 2]}    {[              6 2]}
    {[    12 11 6 5 3 2]}    {[              6 2]}
    {[    12 11 7 5 3 2]}    {[              6 2]}
    {[    13 12 6 6 4 3]}    {[              5 1]}
    {[    13 12 7 6 4 3]}    {[              5 1]}
    {[    13 12 8 6 4 3]}    {[              5 1]}
    {[    14 10 8 5 5 1]}    {[              4 3]}
    {[    14 10 8 6 5 1]}    {[              4 3]}
    {[    15 11 9 6 6 2]}    {[              3 2]}
    {[    15 11 9 7 6 2]}    {[              3 2]}
    {[   16 12 10 7 7 3]}    {[              2 1]}
    {[   16 12 10 8 7 3]}    {[              2 1]}
    {[ 15 14 10 8 6 5 1]}    {[                3]}
    {[ 16 15 11 9 7 6 2]}    {[                2]}
    {[17 16 12 10 8 7 3]}    {[                1]}
  ```
In this case, let C = `[2 1]` and B = `[5 1]`.
B ⊕ C = `[6 5 1]`. As we see below, B ⊕ C is in the right side, giving all possible Ds in the left side:
```matlab
    {[       12 6 6 3 3]}    {[            6 5 1]}
    {[       12 6 6 4 3]}    {[            6 5 1]}
    {[       12 7 6 3 3]}    {[            6 5 1]}
    {[       12 7 6 4 3]}    {[            6 5 1]}
    {[       12 8 6 3 3]}    {[            6 5 1]}
    {[       12 8 6 4 3]}    {[            6 5 1]}
```
Let's pick the pair `{[   16 12 10 8 7 3]}    {[              2 1]}` (there's two pairs that satisfy this). Here, C is in the right side. In the left side, A ⊕ B = `[16 12 10 8 7 3]`. Let's decompose this into pairs of partitions using `reversedPDilation`:
```matlab
    {[             1]}    {[16 12 10 8 7 3]}
    {[             2]}    {[ 15 11 9 7 6 2]}
    {[             3]}    {[ 14 10 8 6 5 1]}
    {[           5 1]}    {[    12 6 6 4 3]}
    {[           5 1]}    {[    12 7 6 4 3]}
    {[           5 1]}    {[    12 8 6 4 3]}
    {[           6 2]}    {[    11 5 5 3 2]}
    {[           6 2]}    {[    11 6 5 3 2]}
    {[           6 2]}    {[    11 7 5 3 2]}
    {[           7 3]}    {[    10 4 4 2 1]}
    {[           7 3]}    {[    10 5 4 2 1]}
    {[           7 3]}    {[    10 6 4 2 1]}
    {[    10 4 4 2 1]}    {[           7 3]}
    {[    10 5 4 2 1]}    {[           7 3]}
    {[    10 6 4 2 1]}    {[           7 3]}
    {[    11 5 5 3 2]}    {[           6 2]}
    {[    11 6 5 3 2]}    {[           6 2]}
    {[    11 7 5 3 2]}    {[           6 2]}
    {[    12 6 6 4 3]}    {[           5 1]}
    {[    12 7 6 4 3]}    {[           5 1]}
    {[    12 8 6 4 3]}    {[           5 1]}
    {[ 14 10 8 6 5 1]}    {[             3]}
    {[ 15 11 9 7 6 2]}    {[             2]}
    {[16 12 10 8 7 3]}    {[             1]}
```
As we see below, B is in the right side, giving all possible As in the left side:
```matlab
    {[    12 6 6 4 3]}    {[           5 1]}
    {[    12 7 6 4 3]}    {[           5 1]}
    {[    12 8 6 4 3]}    {[           5 1]}
```
Let's pick the pair `{[   16 12 10 7 7 3]}    {[              2 1]}`, the only pair left to be tested, instead of `{[   16 12 10 8 7 3]}    {[              2 1]}`:
```matlab
    {[             1]}    {[16 12 10 7 7 3]}
    {[             2]}    {[ 15 11 9 6 6 2]}
    {[             3]}    {[ 14 10 8 5 5 1]}
    {[           5 1]}    {[    12 6 6 3 3]}
    {[           5 1]}    {[    12 7 6 3 3]}
    {[           5 1]}    {[    12 8 6 3 3]}
    {[           6 2]}    {[    11 5 5 2 2]}
    {[           6 2]}    {[    11 6 5 2 2]}
    {[           6 2]}    {[    11 7 5 2 2]}
    {[           7 3]}    {[    10 4 4 1 1]}
    {[           7 3]}    {[    10 5 4 1 1]}
    {[           7 3]}    {[    10 6 4 1 1]}
    {[    10 4 4 1 1]}    {[           7 3]}
    {[    10 5 4 1 1]}    {[           7 3]}
    {[    10 6 4 1 1]}    {[           7 3]}
    {[    11 5 5 2 2]}    {[           6 2]}
    {[    11 6 5 2 2]}    {[           6 2]}
    {[    11 7 5 2 2]}    {[           6 2]}
    {[    12 6 6 3 3]}    {[           5 1]}
    {[    12 7 6 3 3]}    {[           5 1]}
    {[    12 8 6 3 3]}    {[           5 1]}
    {[ 14 10 8 5 5 1]}    {[             3]}
    {[ 15 11 9 6 6 2]}    {[             2]}
    {[16 12 10 7 7 3]}    {[             1]}
```
As we see below, B is in the right side, giving all possible As in the left side (which is the same as the case where A ⊕ B = `[16 12 10 7 7 3]`):
```matlab
    {[    12 6 6 3 3]}    {[           5 1]}
    {[    12 7 6 3 3]}    {[           5 1]}
    {[    12 8 6 3 3]}    {[           5 1]}
```
**2nd fact:** We can clearly see that A = D. Combining with the 1st fact, this may suggest that divide-and-conquer is applicable. Potentially, a tree-based modeling may be used to:
- Backtracking search for all valid decompositions.
- Memoization to avoid redundant recomputation.
- Potential pruning strategies based on boundary constraints (e.g., Cs(1) = A(1) + B(1))
## Case 3: A can't be decomposed if |A| < 3 where A is a partition
If a partition C is able to be decomposed, there must exist a pair A & B (A ⊕ B = C) where |A| > 1 and |B| > 1.
- Example code:
  ```matlab
  disp(ImageProcessor.reversedPDilationv2([4 2 1]));
  ```
- Run the code:
  ```matlab
  >>
    {[    1]}    {[4 2 1]}
    {[4 2 1]}    {[    1]}
  ```
In this case, `[4 2 1]` can't be decomposed any further. Nevertheless, instead of trial-and-error, how can we know if it's decomposable using mathematics principle?
