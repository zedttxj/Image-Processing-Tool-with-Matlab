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

    A ⊖ B = min { A ⊖ Bᵢ | for all i, where Bᵢ is the i-th row lifted from B}  
    
which is also equivalent to this:  

    P(A ⊖ B) = min { P(A ⊖ Bᵢ) | for all i, where Bᵢ is the i-th row lifted from B}

### 2nd fact:
If:

    P(A) = [a₁, a₂, ..., aₘ]  (partition of A)
    P(Bᵢ) = [0, 0, ..., bᵢ] with (i - 1) zeros before bᵢ

Then the erosion becomes a **partition subtraction** with a +1 shift:

    P(A ⊖ Bᵢ)ⱼ₋ᵢ₊₁ = max{min { aⱼ - bᵢ + 1 }, 0}

### final fact:

Combining the **1st fact** and the **2nd fact**, the final erosion P(A ⊖ B) is then:

    P(A ⊖ B)ⱼ₋ᵢ₊₁ = max{min { aⱼ - bᵢ + 1 }, 0}

## Important Note on Matrix Shape During Erosion

Although the binary matrix A is initially structured like a **Young tableau** (i.e., each row has left-aligned 1s, forming a partition), this **shape is not preserved during the erosion operation itself**.

During the calculation:

- A is treated as a general binary matrix.
- The intermediate results of erosion (especially row-wise erosion using Bᵢ) may **not** maintain the Young tableau form.

However:

- **Before** erosion, P(A) and P(B) are valid partitions (non-increasing sequence).
- **After** erosion, P(A ⊖ B) is also a valid partition.

# Redefine PErosion

We define **PErosion** as a shifted, row-wise min-plus operation on partitions, inspired by morphological erosion.

Let:
- A and B be valid partitions (non-increasing sequences)
- aⱼ and bᵢ represent the j-th and i-th elements of A and B, respectively

We define the PErosion of A by B as a new sequence C such that:

    Cⱼ₋ᵢ₊₁ = max(min(aⱼ - bᵢ + 1), 0)

This operation is called:

    C = A PErosion B

It reflects the erosion of A by **lifting** each element of B row-wise and aligning it with corresponding elements in A, followed by a tropical-style subtraction and clamping at 0. Additionally, `|C| ≤ |A| - |B| + 1`. For that reason, we only keep the values from index 1 to index `|A| - |B| + 1`. Finally, we removes all of the 0s at the end of the partition.

---

## Behavior under Negation

If we negate B element-wise (i.e., flip the signs), we define:

    Bᵢ → -Bᵢ

Then the formula becomes:

    Cⱼ₋ᵢ₊₁ = max(min(aⱼ + bᵢ + 1), 0)

---

## Behavior under Flipping (Reverse Index)

If we reverse B while keeping its head at index 1, the index mapping changes:

- Suppose original B has indices: 3 2 1 (head on the left)
- After flipping: 1 0 -1 (head still aligned at the left)
- In general, B'[2-i] = B[i]

As a result, if we perform A PErosion B':

    Cⱼ₋ᵢ₊₁ = max(min(aⱼ - b'ᵢ + 1), 0)

which is equivalent to this (index shifts accordingly):

    Cⱼ₊ᵢ₋₁ = max(min(aⱼ - bᵢ + 1), 0)

This change of index reflects the **convolution symmetry** where flipping one operand shifts the alignment from `j - i + 1` to `j + i - 1`.

---

## Dual-Twisted PErosion as Tropical Convolution

If we apply both:
- **Negation**: B'ᵢ = -Bᵢ
- **Flipping**: reverse index so head of B aligns with tail of A

Then A PErosion B' becomes:

    Cⱼ₊ᵢ₋₁ = max(min(aⱼ + bᵢ + 1), 0)

This version resembles **tropical min-plus convolution**, often used in tropical polynomial products:

    (A ⊗ B)ₖ = min { aⱼ + bᵢ | j + i - 1 = k }

Our version has a +1 and clamping 0:

    Cⱼ₊ᵢ₋₁ = max(min(aⱼ + bᵢ + 1), 0)

We can conclude that in the realm of positive integers, `A PErosion B' = A ⊗ B - 1`

### Warning: Output Index Range

Originally, for regular PErosion (non-flipped):

    C has indices from 1 to |A| - |B| + 1

But when we calculate `A PErosion B'` where B' is the **flipped + negated** version of B, the output index range from `1 - (|B| - 1)` to `|A| - 2*(|B| - 1)`. Additionally, notice that the length of the output produced by `PErosion` is only `|A| - |B| + 1` whereas `tropical min-plus convolution` produces `|A| + |B| + 1`. For that reason, `PErosion` can only compute limited entries for `tropical min-plus convolution` whereas `tropical min-plus convolution` compute excessive entries for `PErosion`.

This range reflects the **symmetric spread** introduced by reversing and expanding support. Even though B' is no longer a valid partition (due to reversal or negation), partition A and the resulting partion still forms a valid partition — i.e., a non-increasing, positive sequence.

### Relation between PErosion and Min-Plus Convolution

There exist infinitely many ways to **twist** both A and B such that:

- Both twisted versions of A and B are **valid partitions** (i.e., non-increasing and positive),
- And the resulting **PErosion produces the same output** as a min-plus convolution.

Thus, even though PErosion might involve arbitrary sequences, we can always **transform A and B** into partition-compatible forms, preserving:

- Output shape,
- Output values,
- And the tropical interpretation.

This connection establishes **PErosion** as a partition-constrained tropical convolution that preserves algebraic structure while remaining interpretable in morphological and combinatorial terms.

#### Example: Matching PErosion to Tropical Min-Plus Convolution

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

Why?  

In the section [Dual-Twisted PErosion as Tropical Convolution](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/PErosion.md#dual-twisted-perosion-as-tropical-convolution), we conclude that `A PErosion B' = A ⊗ B - 1`. However, we can't represent `B'` as a valid partition as it has negative index and negative entries. For that reason, we will have to twist B' more (and A if necessary). To make B' no longer negative, we can consider the fact that `PErosion(A,B) = PErosion(A+scalar,B+scalar)`. After that, as we shift the indices of B to the left, indices of C also shifted accordingly to the left. That resolves the indices and both partition B' and output partition now start at 1 when we compute `PErosion`. However, the main concern is that `PErosion` can only compute limited entries for `tropical min-plus convolution` (as mentioned above).
