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

# GitHub Markdown to LaTeX Converter

This [tool](https://zedttxj.github.io//MD-To-LaTex/) lets you fetch any public Markdown file from GitHub (via raw URL) and convert it automatically to LaTeX using [pandoc-wasm](https://github.com/niklasmh/pandoc-wasm).

## Features

- Convert `.md` files to LaTeX on the fly
- Paste any **raw GitHub Markdown URL**
- One-click **download as `.tex`**
- All works **in your browser** — no installation required
- ZIP Packaging: Bundles the LaTeX file and all associated images into a downloadable ZIP archive using JSZip.

### Problems with Render.com's Free Tier Behavior
Render.com's free tier has specific behaviors that affect the performance of your CORS proxy:

- Idle Spin-Down: If the proxy service receives no traffic for 15 minutes, it will spin down to conserve resources.

- Cold Start Delay: Upon receiving a new request after spinning down, the service can take up to 60 seconds to spin back up and handle the request.

- This delay is due to the time required to allocate resources and start the service from an idle state.

## How to Use

1. Open the [converter](https://zedttxj.github.io//MD-To-LaTex/) in your browser.  
2. Paste a **raw GitHub Markdown URL** like:  
![{C4E717A7-5FBC-45D6-86B3-314A4A3DB10A}](https://github.com/user-attachments/assets/c3304791-0779-41ef-8ed0-894ee3818e48)  
3. Wait for it to convert.  
