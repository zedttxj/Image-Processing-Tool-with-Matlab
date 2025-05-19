# Tropical Polynomial Dilation (Symbolic Formatter)

This MATLAB utility builds symbolic string representations of **tropical polynomial dilation**, using max-plus algebra–style notation with customizable symbols. It’s intended for use in tropical geometry, symbolic algebra, and educational contexts.

---

## Example Input

```matlab
A = [7 4 3 2];
B = [5 3 1];
```

These arrays represent coefficients (or partitions) in tropical polynomial form.

---

## Usage

```matlab
ImageProcessor.PDilation2str(A, B, 'μ', '𝜈', '⨂', {'⊕', '()'}, true)
ImageProcessor.PDilation2str1(A, B)
ImageProcessor.PDilation2str2(A, B)
```

### Parameter Description

| Parameter           | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `'μ'`, `'𝜈'`        | Symbols for indexing entries of A and B (`μ₁`, `𝜈₂`, etc.)                  |
| `'⨂'`               | Operator between symbols (`μᵢ⨂𝜈ⱼ`)                                         |
| `{'⊕', '()'}`       | Formatting: join terms with `'⊕'`, wrap with `'(' ')'`                      |
| `true`              | Use **Unicode superscript** (e.g., `x⁰`) instead of plain `0x`              |

---

## Output Examples

### `ImageProcessor.PDilation2str1(A, B)`

Uses:
```matlab
ImageProcessor.PDilation2str1(A, B)
```

Defined as:
```matlab
PDilation2str(A, B, 'μ', '𝜈', '⨂', {'⊕', '()'}, true)
```

Output:
```
(μ₁⨂𝜈₁)⨂x⁰⊕(μ₂⨂𝜈₁⊕μ₁⨂𝜈₂)⨂x¹⊕(μ₃⨂𝜈₁⊕μ₂⨂𝜈₂⊕μ₁⨂𝜈₃)⨂x²⊕(μ₄⨂𝜈₁⊕μ₃⨂𝜈₂⊕μ₂⨂𝜈₃)⨂x³⊕(μ₄⨂𝜈₂⊕μ₃⨂𝜈₃)⨂x⁴⊕(μ₄⨂𝜈₃)⨂x⁵
```

---

### `ImageProcessor.PDilation2str2(A, B)`

Uses:
```matlab
ImageProcessor.PDilation2str2(A, B)
```

Defined as:
```matlab
PDilation2str(A, B, 'μ', '𝜈', '+', {',', 'max()'}, false)
```

Output:
```
max(max(μ₁+𝜈₁)+0x, max(μ₂+𝜈₁,μ₁+𝜈₂)+1x, max(μ₃+𝜈₁,μ₂+𝜈₂,μ₁+𝜈₃)+2x, max(μ₄+𝜈₁,μ₃+𝜈₂,μ₂+𝜈₃)+3x, max(μ₄+𝜈₂,μ₃+𝜈₃)+4x, max(μ₄+𝜈₃)+5x)
```

---

## Utility Functions (not directly related)

`A` is a 1D array of integers. These functions convert `A` into symbolic subscript notation, attaching each entry with `c`:
- `arr2maxstr(A, c, op)` → Cell array like `{ 'μ₁', 'μ₂', ... }`
- `arr2maxstr1(A, c)` → String like `'μ₁⊕μ₂⊕μ₃'`
- `arr2maxstr2(A, c)` → String like `'max(μ₁,μ₂,μ₃)'`

---

## Tip

To switch to LaTeX-style formatting (e.g., `\mu_{i}` instead of `μᵢ`), extend the formatter logic to return LaTeX strings and wrap with `$...$`. I made a website that automatically do this: [Tropical Presentation](https://zedttxj.github.io/Tropical-Geometry-Converter/)  
Example:  
![{84F9B1F8-D5EE-47C7-ACFC-7DF8ED4E8F49}](https://github.com/user-attachments/assets/dbef457f-ae9b-4996-8b2b-ea63b5512daf)

# Symbolic Coordinate Combination Representation

This script demonstrates symbolic summation of 2D integer vectors.  

- Example code:
```matlab
A = [
  3 5;
  5 4;
  1 1;
  4 0
];
result = ImageProcessor.Ainotation(length(A), "symbol");
disp(result);
disp(size(result));
```

- Run the code:
```matlab
>> 
    "{1}"          "{(0,0),(r₁,s₁)}"                                     
    "{2}"          "{(0,0),(r₂,s₂)}"                                     
    "{3}"          "{(0,0),(r₃,s₃)}"                                     
    "{4}"          "{(0,0),(r₄,s₄)}"                                     
    "{1,2}"        "{(0,0),(r₁,s₁),(r₂,s₂),(r₁,s₁)+(r₂,s₂)}"             
    "{1,3}"        "{(0,0),(r₁,s₁),(r₃,s₃),(r₁,s₁)+(r₃,s₃)}"             
    "{1,4}"        "{(0,0),(r₁,s₁),(r₄,s₄),(r₁,s₁)+(r₄,s₄)}"             
    "{2,3}"        "{(0,0),(r₂,s₂),(r₃,s₃),(r₂,s₂)+(r₃,s₃)}"             
    "{2,4}"        "{(0,0),(r₂,s₂),(r₄,s₄),(r₂,s₂)+(r₄,s₄)}"             
    "{3,4}"        "{(0,0),(r₃,s₃),(r₄,s₄),(r₃,s₃)+(r₄,s₄)}"             
    "{1,2,3}"      "{(0,0),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₁,s₁)+(r₂,s₂),(r₁…"
    "{1,2,4}"      "{(0,0),(r₁,s₁),(r₂,s₂),(r₄,s₄),(r₁,s₁)+(r₂,s₂),(r₁…"
    "{1,3,4}"      "{(0,0),(r₁,s₁),(r₃,s₃),(r₄,s₄),(r₁,s₁)+(r₃,s₃),(r₁…"
    "{2,3,4}"      "{(0,0),(r₂,s₂),(r₃,s₃),(r₄,s₄),(r₂,s₂)+(r₃,s₃),(r₂…"
    "{1,2,3,4}"    "{(0,0),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₄,s₄),(r₁,s₁)+(r₂…"

    15     2
```

- Another example code:  
```matlab
A = [
  3 5;
  5 4;
  1 1;
  4 0
];
result = ImageProcessor.Ainotation(length(A), "symbol");
for i = 1:size(result,1)
    I = result(i,1)
    A_I = result(i,2)
end
```
- Run the code:
```matlab
>> 

I = 

    "{1}"


A_I = 

    "{(0,0),(r₁,s₁)}"


I = 

    "{2}"


A_I = 

    "{(0,0),(r₂,s₂)}"


I = 

    "{3}"


A_I = 

    "{(0,0),(r₃,s₃)}"


I = 

    "{4}"


A_I = 

    "{(0,0),(r₄,s₄)}"


I = 

    "{1,2}"


A_I = 

    "{(0,0),(r₁,s₁),(r₂,s₂),(r₁,s₁)+(r₂,s₂)}"


I = 

    "{1,3}"


A_I = 

    "{(0,0),(r₁,s₁),(r₃,s₃),(r₁,s₁)+(r₃,s₃)}"


I = 

    "{1,4}"


A_I = 

    "{(0,0),(r₁,s₁),(r₄,s₄),(r₁,s₁)+(r₄,s₄)}"


I = 

    "{2,3}"


A_I = 

    "{(0,0),(r₂,s₂),(r₃,s₃),(r₂,s₂)+(r₃,s₃)}"


I = 

    "{2,4}"


A_I = 

    "{(0,0),(r₂,s₂),(r₄,s₄),(r₂,s₂)+(r₄,s₄)}"


I = 

    "{3,4}"


A_I = 

    "{(0,0),(r₃,s₃),(r₄,s₄),(r₃,s₃)+(r₄,s₄)}"


I = 

    "{1,2,3}"


A_I = 

    "{(0,0),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₁,s₁)+(r₂,s₂),(r₁,s₁)+(r₃,s₃),(r₂,s₂)+(r₃,s₃),(r₁,s₁)+(r₂,s₂)+(r₃,s₃)}"


I = 

    "{1,2,4}"


A_I = 

    "{(0,0),(r₁,s₁),(r₂,s₂),(r₄,s₄),(r₁,s₁)+(r₂,s₂),(r₁,s₁)+(r₄,s₄),(r₂,s₂)+(r₄,s₄),(r₁,s₁)+(r₂,s₂)+(r₄,s₄)}"


I = 

    "{1,3,4}"


A_I = 

    "{(0,0),(r₁,s₁),(r₃,s₃),(r₄,s₄),(r₁,s₁)+(r₃,s₃),(r₁,s₁)+(r₄,s₄),(r₃,s₃)+(r₄,s₄),(r₁,s₁)+(r₃,s₃)+(r₄,s₄)}"


I = 

    "{2,3,4}"


A_I = 

    "{(0,0),(r₂,s₂),(r₃,s₃),(r₄,s₄),(r₂,s₂)+(r₃,s₃),(r₂,s₂)+(r₄,s₄),(r₃,s₃)+(r₄,s₄),(r₂,s₂)+(r₃,s₃)+(r₄,s₄)}"


I = 

    "{1,2,3,4}"


A_I = 

    "{(0,0),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₄,s₄),(r₁,s₁)+(r₂,s₂),(r₁,s₁)+(r₃,s₃),(r₁,s₁)+(r₄,s₄),(r₂,s₂)+(r₃,s₃),(r₂,s₂)+(r₄,s₄),(r₃,s₃)+(r₄,s₄),(r₁,s₁)+(r₂,s₂)+(r₃,s₃),(r₁,s₁)+(r₂,s₂)+(r₄,s₄),(r₁,s₁)+(r₃,s₃)+(r₄,s₄),(r₂,s₂)+(r₃,s₃)+(r₄,s₄),(r₁,s₁)+(r₂,s₂)+(r₃,s₃)+(r₄,s₄)}"
```

#  Vector Path Summation (Numeric Output)
This works similarly to `ImageProcessor.Ainotation(length(A), "number")`. However, it actually computes the coordinates from the set A.  
- Example code:
```matlab
A = [
  3 5;
  5 4;
  1 1;
  4 0
];
result = ImageProcessor.Ainotation(A, "number");
disp(result);
disp(size(result));
```

- Run the code:
```matlab
>> 
    "{1}"          "{(0,0),(1,1)}"                                       
    "{2}"          "{(0,0),(3,5)}"                                       
    "{3}"          "{(0,0),(4,0)}"                                       
    "{4}"          "{(0,0),(5,4)}"                                       
    "{1,2}"        "{(0,0),(1,1),(3,5),(4,6)}"                           
    "{1,3}"        "{(0,0),(1,1),(4,0),(5,1)}"                           
    "{1,4}"        "{(0,0),(1,1),(5,4),(6,5)}"                           
    "{2,3}"        "{(0,0),(3,5),(4,0),(7,5)}"                           
    "{2,4}"        "{(0,0),(3,5),(5,4),(8,9)}"                           
    "{3,4}"        "{(0,0),(4,0),(5,4),(9,4)}"                           
    "{1,2,3}"      "{(0,0),(1,1),(3,5),(4,0),(4,6),(5,1),(7,5),(8,6)}"   
    "{1,2,4}"      "{(0,0),(1,1),(3,5),(4,6),(5,4),(6,5),(8,9),(9,10)}"  
    "{1,3,4}"      "{(0,0),(1,1),(4,0),(5,1),(5,4),(6,5),(9,4),(10,5)}"  
    "{2,3,4}"      "{(0,0),(3,5),(4,0),(5,4),(7,5),(8,9),(9,4),(12,9)}"  
    "{1,2,3,4}"    "{(0,0),(1,1),(3,5),(4,0),(4,6),(5,1),(5,4),(6,5),(…"

    15     2
```

## Additional: Exporting Vector Paths as Tables (Markdown & LaTeX)

After generating the set of coordinates like above, you can export the `result` into formatted tables:  
- **Markdown format** for GitHub and web documentation  
- **LaTeX format** for academic papers and reports  

You can combine with your MATLAB script to create the table in MD format like this:  

| Index Set | Path Sum Sequence |
|-----------|-------------------|
| `{1}` | `{(0,0),(1,1)}` |
| `{2}` | `{(0,0),(3,5)}` |
| `{3}` | `{(0,0),(4,0)}` |
| `{4}` | `{(0,0),(5,4)}` |
| `{1,2}` | `{(0,0),(1,1),(3,5),(4,6)}` |
| `{1,3}` | `{(0,0),(1,1),(4,0),(5,1)}` |
| `{1,4}` | `{(0,0),(1,1),(5,4),(6,5)}` |
| `{2,3}` | `{(0,0),(3,5),(4,0),(7,5)}` |
| `{2,4}` | `{(0,0),(3,5),(5,4),(8,9)}` |
| `{3,4}` | `{(0,0),(4,0),(5,4),(9,4)}` |
| `{1,2,3}` | `{(0,0),(1,1),(3,5),(4,0),(4,6),(5,1),(7,5),(8,6)}` |
| `{1,2,4}` | `{(0,0),(1,1),(3,5),(4,6),(5,4),(6,5),(8,9),(9,10)}` |
| `{1,3,4}` | `{(0,0),(1,1),(4,0),(5,1),(5,4),(6,5),(9,4),(10,5)}` |
| `{2,3,4}` | `{(0,0),(3,5),(4,0),(5,4),(7,5),(8,9),(9,4),(12,9)}` |
| `{1,2,3,4}` | `{(0,0),(1,1),(3,5),(4,0),(4,6),(5,1),(5,4),(6,5),(7,5),(8,6),(8,9),(9,4),(9,10),(10,5),(12,9),(13,10)}` |

### Exporting to LaTeX Table Format

You can find the table in the file `vector_path_table.tex`:
```matlab
A = [
  3 5;
  5 4;
  1 1;
  4 0
];
result = ImageProcessor.Ainotation(A, "number");
ImageProcessor.table_format_latex("vector_path_table.tex", result, "I", "A of I");
```
- Run the code and open the table from `vector_path_table.tex`:  
![{FFF9DEF0-4410-4B5A-9A22-6B10B1E5C566}](https://github.com/user-attachments/assets/04b5df6f-09ec-4ffe-b88d-bee073627948)  
![{FE80C2ED-9BF0-4B60-A617-115D9B0D0B2A}](https://github.com/user-attachments/assets/4e882d69-c1f7-4606-a07c-4d9c29e33f97)

- Another example code:
```matlab
A = [
  3 5;
  5 4;
  1 1;
  4 0
];
result = ImageProcessor.Ainotation(length(A), "symbol");
ImageProcessor.table_format_latex("vector_path_table.tex", result, "I", "A of I");
```
- Run the code and open the table from `vector_path_table.tex`:  
![{58524ADF-58F1-4D55-BD3D-0FA17F720A64}](https://github.com/user-attachments/assets/59cf68f3-666a-4a41-8e79-bd3a93acb57d)  
![{DC0018BA-A3D1-4ED5-AD18-7869249FE061}](https://github.com/user-attachments/assets/15506e72-c899-4276-a572-40801bd39933)  

### Exporting to MD Table Format

You can find the table in the file `vector_path_table.md`:
```matlab
fid = fopen("vector_path_table.md", "w");

fprintf(fid, "| Index Set | Path Sum Sequence |\n");
fprintf(fid, "|-----------|-------------------|\n");

for i = 1:size(result, 1)
    fprintf(fid, "| `%s` | `%s` |\n", result{i,1}, result{i,2});
end
```
- Run the code and open the table from `vector_path_table.md`:  
![{826EC57D-1150-4D5E-B0B6-2816E1AACA5C}](https://github.com/user-attachments/assets/0c2c1766-f7e9-4414-8d4e-d58d27ce021b)  

**Optional:** You can go to [MD-To-Latex converter (Sandbox version)](https://zedttxj.github.io/MD-To-LaTex-Sandbox/) to convert it into LaTeX form:  
- ![{6FDDF9D8-2D43-4C0B-80E2-793542AF0DE7}](https://github.com/user-attachments/assets/e912aefe-06ba-4c7b-8496-45f28e387306)  
- Import **required** packages used for `longtable`:
  ```latex
  \usepackage{longtable}
  \usepackage{array}
  \usepackage{booktabs}
  \usepackage[margin=1in]{geometry}
  \usepackage{courier}
  ```
- Export it into `.pdf` to test:  
  ![{0FFF1C3F-E279-4B91-874E-EC1938D7E7B2}](https://github.com/user-attachments/assets/9e4617c3-e59c-4522-bc12-84beab7017d6)
