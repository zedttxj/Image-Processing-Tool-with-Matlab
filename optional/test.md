# PDilation and reversedPDilation

This document presents the **PDilation** operator—an index‑shifted, max–plus convolution on integer partitions—and a robust inversion algorithm, **reversedPDilation**, that exhaustively finds _all_ valid factor pairs despite non‑injectivity.

---

## 1. Definitions

- **Partition**: A non‑increasing sequence of positive integers
  We require trailing 1’s: any partition not ending in 1 can be written as
  ```math
  \oplus \(1\).
  ```

- **PDilation ($\oplus$)**: For two partitions
  \(A=(a_1,\dots,a_m)\) and \(B=(b_1,\dots,b_n)\),
  their PDilation \(C=A\oplus B\) has length \(m+n-1\) with entries
  \[
    C_k = \max_{i+j=k+1}\bigl(a_i + b_j - 1\bigr),
    \quad 1 \le k \le m+n-1.
  \]
  This is the 1D max–plus convolution shifted by \(-1\).

- **Atomic partition**: A partition \(D\) is atomic if there is **no** factorization \(D=A\oplus B\) with \(|A|>1,|B|>1\).  Atomic partitions are indivisible in reversedPDilation.

---

## 2. Convolution‑Like Operator

We can generalize PDilation as a convolution with generic operations ($\circ$,$\oplus$):
\[
  (x \circledast y)_k = \bigoplus_{i+j=k}(x_i \circ y_j),
\]
where both $\circ$ and $\oplus$ are associative and commutative.

### 2.1 1D Addition‑Max (PDilation)
```matlab
% MATLAB: PDilation of A and B
function C = PDilation(A,B)
  m = numel(A); n = numel(B);
  C = -inf(1,m+n-1);
  for i=1:m
    for j=1:n
      k = i+j-1;
      C(k) = max(C(k), A(i)+B(j)-1);
    end
  end
end
```

### 2.2 Example: A = [1 3 2], B = [4 1]
```matlab
C(1) = 1+4-1 = 4;
C(2) = max(1+1-1,3+4-1)=6;
C(3) = max(3+1-1,2+4-1)=5;
C(4) = 2+1-1=2;
% => C = [4 6 5 2]
```

### 2.3 Alternative: Multiplication‑Plus
```matlab
C(k) = sum(A(i)*B(j))  where i+j-1=k
```  classic 1D conv

---

## 3. Higher‑Dimensional Extension
By lexicographic index pairing, PDilation extends to 2D, 3D, etc.
E.g., for 2D partitions \(A[i,m],B[j,n]\):
\[
 C_{k,t} = \max_{i+j=k+1,\,m+n=t+1}\bigl(A_{i,m}+B_{j,n}-1\bigr).
\]

---

## 4. Special Cases & Observations

### 4.1 Peeling Off Trailing 1’s
If \(D_\ell=D_{\ell-1}=1\), write \(D=D'\oplus(1)\).  Recurse on \(D'\).

### 4.2 Atomic Detection (Partition Sieve)
Precompute all atomic partitions of length ≤ L by marking composite results of every nontrivial PDilation

### 4.3 Ambiguous Factorizations
Lowering one entry in each input can leave PDilation unchanged:
```matlab
A1=[4 3 2 1]; B1=[4 3 2 1]; D1=PDilation(A1,B1);
A2=[4 2 2 1]; B2=[4 3 1 1]; D2=PDilation(A2,B2);
assert(isequal(D1,D2));
```
No simple divide‑and‑conquer can distinguish these.

### 4.4 Canonical Decomposition
To enforce uniqueness, impose rules (e.g. peel leftmost 1’s first, sort factor pairs lexicographically).

---

## 5. Partition Sieve Algorithm
```text
1. S = {all partitions of length ≤ L}; mark all atomic.
2. For each (A,B) with |A|,|B|>1:
     mark D=A$\oplus$B as composite.
3. Atomic = S \ Composite.
```

---

## 6. reversedPDilation (Backtracking + Memo)
```pseudo
function leaves = reversedPDilation(D):
  if D ends in >1 ones:
    peel off one 1, recuse on D'; attach 1 to each leaf.
  elseif D is atomic:
    return { {D} }  % single‑leaf set
  else:
    leaves = []
    for each (A,B) with A$\oplus$B=D and |A|,|B|>1:
      for LA in reversedPDilation(A):
        for LB in reversedPDilation(B):
          leaves.append(LA ∪ LB)
    return unique(leaves)
```

---

## 7. Test Cases
1. **Trivial:** A=[1],B=[1] → D=[1 1] → leaves={{[1]}}  
2. **Simple:** A=[3 2 1],B=[2 1] → D=[4 3 2 1] → leaves={{[3 2 1],[2 1]}}  
3. **Ambiguous:** see §4.3  
4. **Non‑decomposable:** D=[4 2 1] only splits with unit 1.

---

## 8. Conclusion
Combining a precomputed atomic table with exhaustive backtracking ensures `reversedPDilation` finds _every_ full decomposition—guarding against non‑injectivity and non‑cancellativity in max–plus convolution.

