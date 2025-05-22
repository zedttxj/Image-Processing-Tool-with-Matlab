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

The final erosion P(A ⊖ B) is then:

    P(A ⊖ B)ⱼ₋ᵢ₊₁ = max{min { aⱼ - bᵢ + 1 }, 0}

## Important Note on Matrix Shape During Erosion

Although the binary matrix A is initially structured like a **Young tableau** (i.e., each row has left-aligned 1s, forming a partition), this **shape is not preserved during the erosion operation itself**.

During the calculation:

- A is treated as a general binary matrix.
- The intermediate results of erosion (especially row-wise erosion using Bᵢ) may **not** maintain the Young tableau form.

However:

- **Before** erosion, P(A) and P(B) are valid partitions (non-increasing sequence).
- **After** erosion, P(A ⊖ B) is also a valid partition.

That means:

- The erosion operation *temporarily breaks* the Young tableau layout.
- But when we extract the partition from the result using P(·), the output is again a valid partition.

This justifies using partition arithmetic and min-plus convolution, while allowing us to work flexibly with binary matrices during processing.
