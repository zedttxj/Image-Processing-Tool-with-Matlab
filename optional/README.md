# FUNCTIONS-CODES.pdf

## BP(A)
- Input:
  - Binary matrix: 2D
- Output:
  - Partition (contains the original size of the binary matrix): 1D
- Explanation: The function BP(A) processes a binary matrix by sorting each row and each column, then counting the number of ones in each row and storing this count in a partition vector. The partition vector represents the number of ones in each row. An alternative approach is to count the number of ones in each row first, and then sort them in descending order. Both approaches produce the same result.
- Example code:
  ```
  data = [
    1 1 1 0;
    0 1 0 1;
    0 1 0 0
  ];
  disp(ImageProcessor.BP(data));
  ```
- Run the code:
  ```
  >> 
     3     4     3     2     1
  ```
- To visualize the sorting process:
  Here, the first value (`3`) stands for the height of the original matrix and the second value (`4`) stands for the width of the original matrix. Followed by that is the partition `[3 2 1]`. You can check the sorted `data` matrix with `disp(ImageProcessor.customSorting(data,"rc",[1 0]));` though the actual code of this function is different.
  - Sorted Matrix Output:
    ```
    >> 
       1     1     1     0
       1     1     0     0
       1     0     0     0
    ```

## PC(lambda, G, order)

- **Explanation:**  
Think of this function as a derivative of `BP(A)`. The parameters `lambda` and `order` are used to construct the `data` matrix (whose structure is unknown initially). Then, we extract the colors from `data` based on the provided `G`. Finally, we apply the sorting and counting procedure, similar to `BP(A)`.

- **Input:**
  - `lambda` (1D): Contains the lengths of each row of the matrix to be constructed.
  - `G` (string or charArray): Specifies the colors to extract (e.g., `"RB"` means extracting only red and blue colors from the matrix).
  - `order` (2D): A matrix that will be replicated to match the sizes indicated by `lambda`.

- **Output:**  
  Colored partitions (after extracting and counting the specified colors).

- **Example Code:**
    ```matlab
    lambda = [4 2 1];
    order = [
        3 2;
        2 1;
    ];
    disp(ImageProcessor.PC(lambda, "RB", order));
    ```

- **Explanation of Example:**

  - In this example, `3` stands for blue, `2` stands for green, and `1` stands for red.
  - The `order` matrix will be replicated according to `lambda` to match the row sizes. Here’s how `order` looks after replication:
  
    ```
    3 2 3 2 3 2 3 2...
    2 1 2 1 2 1 ...
    3 2 3 2 ...
    2 1 2 1 2 1 ...
    ...
    ```

  - Now, we cut the rows according to `lambda` to get the following structure:
    ```
    3 2 3 2
    2 1
    3
    ```

  - We then extract the red and blue colors since `G = "RB"`. The extracted values are:
    ```
    1 0 1 0
    0 1
    1
    ```

  - Finally, we apply the `BP(A)` function to get the `coloredPartition`, which is the output without the size of the constructed matrix.

- **Run the Code:**
  ```
  >> script
    Warning: lambda shouldn't contain the sizes of the matrix
         2     1     1
  ```
  To disable the warning, put 'false' in the 4th parameter (after `order`).

## IC2(A, G, order)
- Input:
  - A (2D): 2D matrix
  - G (string or charArray): similar to `G` in `PC` function
  - order (2D): similar to `order` in `PC` function
- Output: Filtered Matrices (sorted based on GBR, BGR, etc, and the corresponding entries sorted at the same time).
- Example code + explanation:
  ```
  A = [
      1 2 3 4;
      5 6 7 8;
      9 10 11 12;
      13 14 15 16;
  ];
  order = [
      3 2;
      2 1;
  ];
  disp(ImageProcessor.IC2(A, "RB", order));
  ```
  In this example, `3` stands for blue (B), `2` stands for green (G), and `1` stands for red (R).
  `order` will be sorted based on the order `R < B < G`. Although `G` wasn't explicitly written, the program automatically fill in the order. Another example of order is "BR" where `B < R < G`.
  When sorts the `order`, the program will keep track of the indices that corresponding to the values being swapped. You can track the indices by using `customSorting` like this where "rc" stands for sorting by rows first then by columns and `[1 3 2]` stands for sorting in order of `R < B < G`:
  ```
  [data, rows, cols] = ImageProcessor.customSorting(order,"rc",[1 3 2]);
  disp(cols + "," + rows);
  ```
  And the output after running the above code is like this:
  ```
  >> script
    "2,2"    "1,2"
    "1,1"    "2,1"
  
  Sorted order:
       1     2
       3     2
  ```
  The function `IC2` tracks the indices when swapping (like `"2,1"` stands for second row and first column) so that later it can apply on the `A` matrix.
- Run the code (output of `disp(ImageProcessor.IC2(A, "RB", order));`):
  ```
     6     2     8     4
     1     5     3     7
    14    10    16    12
     9    13    11    15
  ```
