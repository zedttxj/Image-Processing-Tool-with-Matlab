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
result = ImageProcessor.Ainotation(4, "symbol");
disp(result);
disp(size(result));
```

- Output:
```matlab
>> 
    "{1}"             "{(0,0),(r₀,s₀)}"                                     
    "{2}"             "{(0,0),(r₁,s₁)}"                                     
    "{3}"             "{(0,0),(r₂,s₂)}"                                     
    "{4}"             "{(0,0),(r₃,s₃)}"                                     
    "{1  2}"          "{(0,0),(r₀,s₀),(r₁,s₁),(r₀,s₀)+(r₁,s₁)}"             
    "{1  3}"          "{(0,0),(r₀,s₀),(r₂,s₂),(r₀,s₀)+(r₂,s₂)}"             
    "{1  4}"          "{(0,0),(r₀,s₀),(r₃,s₃),(r₀,s₀)+(r₃,s₃)}"             
    "{2  3}"          "{(0,0),(r₁,s₁),(r₂,s₂),(r₁,s₁)+(r₂,s₂)}"             
    "{2  4}"          "{(0,0),(r₁,s₁),(r₃,s₃),(r₁,s₁)+(r₃,s₃)}"             
    "{3  4}"          "{(0,0),(r₂,s₂),(r₃,s₃),(r₂,s₂)+(r₃,s₃)}"             
    "{1  2  3}"       "{(0,0),(r₀,s₀),(r₁,s₁),(r₂,s₂),(r₀,s₀)+(r₁,s₁),(r₀…"
    "{1  2  4}"       "{(0,0),(r₀,s₀),(r₁,s₁),(r₃,s₃),(r₀,s₀)+(r₁,s₁),(r₀…"
    "{1  3  4}"       "{(0,0),(r₀,s₀),(r₂,s₂),(r₃,s₃),(r₀,s₀)+(r₂,s₂),(r₀…"
    "{2  3  4}"       "{(0,0),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₁,s₁)+(r₂,s₂),(r₁…"
    "{1  2  3  4}"    "{(0,0),(r₀,s₀),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₀,s₀)+(r₁…"

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
result = ImageProcessor.Ainotation(4, "symbol");
for i = 1:size(result,1)
    I = result(i,1)
    A_I = result(i,2))
end
```
- Output:
```matlab
>> 

I = 

    "{1}"


A_I = 

    "{(0,0),(r₀,s₀)}"


I = 

    "{2}"


A_I = 

    "{(0,0),(r₁,s₁)}"


I = 

    "{3}"


A_I = 

    "{(0,0),(r₂,s₂)}"


I = 

    "{4}"


A_I = 

    "{(0,0),(r₃,s₃)}"


I = 

    "{1  2}"


A_I = 

    "{(0,0),(r₀,s₀),(r₁,s₁),(r₀,s₀)+(r₁,s₁)}"


I = 

    "{1  3}"


A_I = 

    "{(0,0),(r₀,s₀),(r₂,s₂),(r₀,s₀)+(r₂,s₂)}"


I = 

    "{1  4}"


A_I = 

    "{(0,0),(r₀,s₀),(r₃,s₃),(r₀,s₀)+(r₃,s₃)}"


I = 

    "{2  3}"


A_I = 

    "{(0,0),(r₁,s₁),(r₂,s₂),(r₁,s₁)+(r₂,s₂)}"


I = 

    "{2  4}"


A_I = 

    "{(0,0),(r₁,s₁),(r₃,s₃),(r₁,s₁)+(r₃,s₃)}"


I = 

    "{3  4}"


A_I = 

    "{(0,0),(r₂,s₂),(r₃,s₃),(r₂,s₂)+(r₃,s₃)}"


I = 

    "{1  2  3}"


A_I = 

    "{(0,0),(r₀,s₀),(r₁,s₁),(r₂,s₂),(r₀,s₀)+(r₁,s₁),(r₀,s₀)+(r₂,s₂),(r₁,s₁)+(r₂,s₂),(r₀,s₀)+(r₁,s₁)+(r₂,s₂)}"


I = 

    "{1  2  4}"


A_I = 

    "{(0,0),(r₀,s₀),(r₁,s₁),(r₃,s₃),(r₀,s₀)+(r₁,s₁),(r₀,s₀)+(r₃,s₃),(r₁,s₁)+(r₃,s₃),(r₀,s₀)+(r₁,s₁)+(r₃,s₃)}"


I = 

    "{1  3  4}"


A_I = 

    "{(0,0),(r₀,s₀),(r₂,s₂),(r₃,s₃),(r₀,s₀)+(r₂,s₂),(r₀,s₀)+(r₃,s₃),(r₂,s₂)+(r₃,s₃),(r₀,s₀)+(r₂,s₂)+(r₃,s₃)}"


I = 

    "{2  3  4}"


A_I = 

    "{(0,0),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₁,s₁)+(r₂,s₂),(r₁,s₁)+(r₃,s₃),(r₂,s₂)+(r₃,s₃),(r₁,s₁)+(r₂,s₂)+(r₃,s₃)}"


I = 

    "{1  2  3  4}"


A_I = 

    "{(0,0),(r₀,s₀),(r₁,s₁),(r₂,s₂),(r₃,s₃),(r₀,s₀)+(r₁,s₁),(r₀,s₀)+(r₂,s₂),(r₀,s₀)+(r₃,s₃),(r₁,s₁)+(r₂,s₂),(r₁,s₁)+(r₃,s₃),(r₂,s₂)+(r₃,s₃),(r₀,s₀)+(r₁,s₁)+(r₂,s₂),(r₀,s₀)+(r₁,s₁)+(r₃,s₃),(r₀,s₀)+(r₂,s₂)+(r₃,s₃),(r₁,s₁)+(r₂,s₂)+(r₃,s₃),(r₀,s₀)+(r₁,s₁)+(r₂,s₂)+(r₃,s₃)}"
```
