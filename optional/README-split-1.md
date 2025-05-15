# FUNCTIONS-CODES.pdf

#### Matrix-Based Dilation (Efficient Form):
- Instead of iterating over sets, **matrix dilation** is efficiently computed using **convolution operations** or **max filtering**, where a **structuring element (kernel)** is applied to the binary image.
- **MatrixDecomposition as Multiple Dilations**: We can think of the **MatrixDecomposition** as a series of dilations for each element in the set, where the dilation operator ⊕ applies to each element in the set 𝐴. For each element, we consider the set that contains the coordinate [0,0] (the first coordinate) and the element itself so that ⊕ can be applied. The special function then becomes the **Riemann Dilation sum** of these dilations (like how `+` has **Riemann sum**, ⊕ has **Riemann Dilation sum**). Consider this example:
  - Example: Generating Subsets Using Dilation
  
    Consider a set  
    **A = {a, b, c}**  
    Normally, we could generate subsets by toggling bits (e.g., using binary representation), but instead, we use the **dilation operator** (⊕):
  
    - Step 1: Start with the Base Set  
      S₀ = {[0,0]}  
    This represents the empty set as a starting point.
    
    - Step 2: Apply Dilation with Each Element  
    
      - First dilation with element a:  
      S₁ = S₀ ⊕ {[0,0], a} = {[0,0], a}  
    
      - Second dilation with element b:  
      S₂ = S₁ ⊕ {[0,0], b} = {[0,0], a, b, a+b}
    
      - Third dilation with element c:  
      S₃ = S₂ ⊕ {[0,0], c} = {[0,0], a, b, c, a+b, a+c, b+c, a+b+c}
  
    - **Resulting Set:**  
    After three dilations, we have generated all possible subsets of 𝐴, mimicking how binary toggling would work.  

- Effects: This **reduces computation time** from `O(2^(|A|))` (where `|A|` is the length of set A or the number of `1`s of matrix A) in the set-based approach to `O((max(rows(𝐴)) x max(cols(𝐴)))⁴)` for the `matrixDecomposition` function that transforms the input matrices.
- Recommendation:
  - Use Matrix-Based Dilation when `|𝐴|` is large enough (ideally below 676) and `max(rows(𝐴))` or `max(cols(𝐴))` is not too big.
  - Use Set-Based Dilation (introduced in the below section) when `|𝐴|` is small enough (ideally below 36).  

- Example code:
  ```matlab
  tic;
  B = ImageProcessor.readImage('test.png');
  A = B(200:205,200:205,:) > 160;
  B = B(200:225,200:225,:) > 160;
  t = ImageProcessor.EXTRA.DILATION(B,A);
  imshow(t);
  elapsedTime = toc;
  disp(elapsedTime);
  disp("Size of input image: " + strjoin(arrayfun(@num2str, size(B), 'UniformOutput', false), ' '));
  disp("Size of output image: " + strjoin(arrayfun(@num2str, size(t), 'UniformOutput', false), ' '));
  ```
- Run the code: ![{E86B4DFF-EDAC-4652-B698-685318D7A79E}](https://github.com/user-attachments/assets/fe38f19a-ce1f-4588-90ef-1d8a075f718f)  
- Another example code:
  ```matlab
  tic;
  B = ImageProcessor.readImage('test.png');
  A = B(200:205,200:205,:) > 160;
  B = B(200:215,200:215,:) > 160;
  t = ImageProcessor.EXTRA.DILATION(B,A);
  imshow(t);
  elapsedTime = toc;
  disp(elapsedTime);
  disp("Size of input image: " + strjoin(arrayfun(@num2str, size(B), 'UniformOutput', false), ' '));
  disp("Size of output image: " + strjoin(arrayfun(@num2str, size(t), 'UniformOutput', false), ' '));
  ```
- Run the code: ![{BD9875CA-0779-4290-B6A4-7C20D8919CC0}](https://github.com/user-attachments/assets/5d52c232-d2de-45c4-9a12-3e75d0dd332a)  
- **Fun fact**: No matter how you twist your input image, if it has enough entries that have value `1`, it will turn into the oval-like form with two pointed ends.
  - Note: I used `matrixDecomposition` here for demonstration. `EXTRA.DILATION` also works with 2D binary matrices.
  - Example:  
    ![{69B45C5E-510D-4A13-B104-0F8992509B0F}](https://github.com/user-attachments/assets/c5d59428-4abd-4c9a-a3aa-ecb5f28570af)  
    As I increase the number of ones:  
    ![{74BE45FD-6BC5-4A01-A617-D92FBEF43327}](https://github.com/user-attachments/assets/1a524198-4f0f-43c1-82cc-7a9b0d87921f)  
