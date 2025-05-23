# Define PErosion

## Connection to Minkowski Subtraction

### For Union

Let B = B₁ ∪ B₂, where B₁ and B₂ are sets (e.g., lines, shapes, structuring elements). Then:

    A ⊖ B = min{A ⊖ B₁, A ⊖ B₂}

This reflects the distributive property of erosion over union: the erosion of A by a union of sets is the **pointwise minimum** of erosions by the individual sets.

### For Intersection

Let B = B₁ ∩ B₂, where B₁ and B₂ are sets (e.g., lines, shapes, structuring elements). Then:

    A ⊖ B = max{A ⊖ B₁, A ⊖ B₂}

This makes sense because erosion is anti-extensive and order-reversing: the smaller the structuring element, the larger the eroded result.

---

## Row-wise Erosion

For a 2D structuring element B, define each Bᵢ as the matrix that contains only the i-th row of B (all other rows are zero), lifted into 2D space. Then:

    A ⊖ B = max{min { A ⊖ Bᵢ | Bᵢ ⊆ B}, 0}

This models erosion as a **row-wise operation**, where each row independently contributes to the final result through a minimum operation. `max(...,0)` appears as non-positive coordinates don't exist.

---

## Matrix-to-Partition Mapping

Let A be a binary matrix (values 0 or 1), such that:

- Each row has all 1s aligned to the left (no 0 appears before a 1 in any row).

We define the partition P(A) as:

    P(A) = [a₁, a₂, ..., aₘ]

where aᵢ is the **number of 1s in the i-th row** of A.

This abstraction allows morphological operations like erosion to be translated into operations on partitions, such as **min-plus convolution** in tropical algebra.


## Scalar Case of Partition-Based Erosion

In the simplest case, suppose both A and B are single-row binary arrays with left-aligned 1s.

Let:

    P(A) = scalarA   (number of 1s in A)
    P(B) = scalarB   (number of 1s in B)

Then the erosion becomes:

    P(A ⊖ B) = max(scalarA - scalarB + 1, 0)

This aligns with the intuition that:
- You can slide B within A from left to right.
- The number of valid positions is (scalarA - scalarB + 1).

### Example:

    A = [1, 1, 1, 1, 1]    → scalarA = 5
    B = [1, 1, 1]          → scalarB = 3

Then:

    P(A ⊖ B) = 5 - 3 + 1 = 3

There are 3 valid positions where B can "fit" into A during erosion.

## Partition Arithmetic under Row-wise Erosion

### 1st fact:
From the row-wise erosion:

    `A ⊖ B = min { A ⊖ Bᵢ | for all i, where Bᵢ is the i-th row lifted from B}`  
    
which is also equivalent to this:  

    `P(A ⊖ B) = min { P(A ⊖ Bᵢ) | for all i, where Bᵢ is the i-th row lifted from B}`

### 2nd fact:
If:

    `P(A) = [a₁, a₂, ..., aₘ]`  (partition of A)
    `P(Bᵢ) = [0, 0, ..., bᵢ]` with (i - 1) zeros before `bᵢ`

Then the erosion becomes a **partition subtraction** with a `+1` shift:

    `P(A ⊖ Bᵢ)ⱼ₋ᵢ₊₁ = max{min { aⱼ - bᵢ + 1 }, 0}`

### final fact:

Combining the **1st fact** and the **2nd fact**, the final erosion `P(A ⊖ B)` is then:

    `P(A ⊖ B)ⱼ₋ᵢ₊₁ = max{min { aⱼ - bᵢ + 1 }, 0}`

## Important Note on Matrix Shape During Erosion

Although the binary matrix A is initially structured like a **Young tableau** (i.e., each row has left-aligned 1s, forming a partition), this **shape is not preserved during the erosion operation itself**.

During the calculation:

- A is treated as a general binary matrix.
- The intermediate results of erosion (especially row-wise erosion using `Bᵢ`) may **not** maintain the Young tableau form.

However:

- **Before** erosion, P(A) and P(B) are valid partitions (non-increasing sequence).
- **After** erosion, `P(A ⊖ B)` is also a valid partition.

# Redefine PErosion

We define **PErosion** as a shifted, row-wise min-plus operation on partitions, inspired by morphological erosion.

Let:
- A and B be valid partitions (non-increasing sequences)
- aⱼ and bᵢ represent the j-th and i-th elements of A and B, respectively

We define the PErosion of A by B as a new sequence C such that:

    `Cⱼ₋ᵢ₊₁ = max(min(aⱼ - bᵢ + 1), 0)`

This operation is called:

    `C = A PErosion B`

It reflects the erosion of A by **lifting** each element of B row-wise and aligning it with corresponding elements in A, followed by a tropical-style subtraction and clamping at 0. Additionally, `|C| ≤ |A| - |B| + 1`. For that reason, we only keep the values from index 1 to index `|A| - |B| + 1`. Finally, we removes all of the 0s at the end of the partition.

---

## Behavior under Negation

If we negate B element-wise (i.e., flip the signs), we define:

    `B'ᵢ = -Bᵢ`

Then the formula (`A PErosion B'`) becomes:

    `Cⱼ₋ᵢ₊₁ = max(min(aⱼ + bᵢ + 1), 0)`

---

## Behavior under Flipping (Reverse Index)

If we flip B, the index mapping changes:

- Suppose original B has indices: 3 2 1 (head on the left)
- After flipping: 1 2 3 (head still aligned at the left)
- In general, `B'[1-i+|B|] = B[i] ⟺ B'[i] = B[1-i+|B|]`

As a result, if we perform `A PErosion B'`:

`C[j-i+1] = max(min(a[j] - b'[i] + 1), 0)`

which is equivalent to this (index shifts accordingly):

`C[j-(1-i+|B|)+1] = max(min(a[j] - b[i] + 1), 0)`

Then:  

`C[j+i-|B|] = max(min(a[j] - b[i] + 1), 0)`

This change of index reflects the **convolution symmetry** where flipping one operand shifts the alignment from `j - i + 1` to `j + i - 1`.

---

## Dual-Twisted PErosion as Tropical Convolution

If we apply both:
- **Negation**: `B'ᵢ = -Bᵢ`
- **Flipping**: reverse index so head of B aligns with tail of B'. Same thing otherwise.

Then `A PErosion B'` becomes:

`C[j+i-|B|] = max(min(a[j] + b[i] + 1), 0)`

This version resembles **tropical min-plus convolution**, often used in tropical polynomial products:

`(A ⊗ B)ₖ = min { aⱼ + bᵢ | j + i - 1 = k }`

Our version has a +1 and clamping 0:

`C[j+i-|B|] = max(min(a[j] + b[i] + 1), 0)`

However, we cannot directly conclude that `A PErosion B' = A ⊗ B - 1` in the realm of positive integer partitions, for the following reasons:  

### 1. B' has negative entries  
    
To make `B'`'s entries no longer negative, we can consider the fact that `PErosion(A,B) = PErosion(A+scalar,B+scalar)`.  
    
### 2. Output length of PErosion and tropical min-plus convolution don't match  
    
Notice that the length of the output produced by `PErosion` is only `|A| - |B| + 1` whereas `tropical min-plus convolution` produces `|A| + |B| + 1`. Hence, PErosion only computes a subset of the entries from the full convolution. To match the full convolution support, we must pad A appropriately (not `B'`), ensuring A is long enough to allow convolution-style overlap. Additionally, if the padding values are too small, they can incorrectly reduce the minimum values in the result.
> Padding B' instead would cause more entries to be clipped, due to further narrowing the overlapping window.

### 3. Solution:

We have `A = a₁, a₂, ..., aₘ` and `B = b₁, b₂, ..., bₙ`.
Let `B'` becomes the **flipped + negated** version of B. B' is already non-increasing, and A is already a valid partition.

1. `PErosion(A + bₙ, B' + bₙ)ⱼ₋ᵢ₊₁ = max(min((aⱼ + bₙ) - (b'ᵢ + bₙ) + 1), 0) = max(min(aⱼ - b'ᵢ + 1), 0) = PErosion(A,B')ⱼ₋ᵢ₊₁`. We can choose `bₙ` (the last value of B) so that both `A + bₙ` and `B' + bₙ` are positive partitions. Now our `PErosion(A,B')` becomes `PErosion(A', B'')` where `A' = A + bₙ and B'' = B' + bₙ`
2. Currently, we have `PErosion(A', B'') = PErosion(A, B')[j+i-|B|] = max(min(a[j] + b[i] + 1), 0)`. For this reason, we need to pad `A'` `|B|-1` times after `A[end]` (called `A''` from now on) so that `PErosion(A', B'')[j+i-|B|] = PErosion(A'', B'')[j+i-1]`. Now we have `PErosion(A'', B'')[j+i-1] = max(min(a[j] + b[i] + 1), 0)`. Importantly, we have to pad `|B|-1` more before `A[1]` to match the length of `A ⊗ B`.  
> Cautious: The padding values must be large enough to avoid corrupting the min() results in PErosion. Padding with values that are too small may lower the output incorrectly.

There exist infinitely many ways to **twist** both A and B such that:

- Both twisted versions of A and B are **valid partitions** (i.e., non-increasing and positive),
- And the resulting **PErosion produces the same output** as a min-plus convolution.

### Example: Matching PErosion to Tropical Min-Plus Convolution

One of the simplest ways to twist A and B into valid partitions that simulate min-plus convolution is shown below:

```matlab
function erodedPartition = tropical_min_multiplication(A, B)
    % Twists A and B into valid partitions such that PErosion(A, B) ≡ tropical convolution.
    % Given original sequences A and B, we construct:

    A_twisted = [B(1:end-1) - B(end) + A(1), A, B(2:end) - B(1) + A(end)] + B(1);
    B_twisted = -flip(B - 1) + B(1);

    disp(compose("1st partition: [%s]", num2str(A_twisted)));
    disp(compose("2nd partition: [%s]", num2str(B_twisted)));

    % Both A_twisted and B_twisted are valid partitions. Then:
    erodedPartition = ImageProcessor.PErosion(A_twisted, B_twisted);
end
```

In this example, we can conclude that in the realm of positive integers, `A_twisted PErosion B_twisted = A ⊗ B - 1`
