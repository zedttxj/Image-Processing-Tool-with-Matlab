# FUNCTIONS-CODES.PDF
## BP(A)
- Input: binary matrices
- Output: partitions (contains the original size of the binary matrix).
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
