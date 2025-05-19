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

- Convert `.md` files to LaTeX through web browser
- Paste any **raw GitHub Markdown URL**
- One-click **download as .tex**
- Sandbox version for adjusting mathematics translation and MD adjustment
- No installation required
- ZIP Packaging

## How to Use

1. Open the [converter](https://zedttxj.github.io//MD-To-LaTex/) in your browser.  
2. Paste a **raw GitHub Markdown URL** like:  
![{AEB978D4-279C-4E9A-8342-DD203291566D}](https://github.com/user-attachments/assets/84ebe709-bd23-47b8-8259-ebb171a2ebd5)  
3. Wait for it to convert.

## Example of Visual Testing in PDF Format
1. Open [Overleaf](https://www.overleaf.com/) and log into your account.
2. Choose a template (like this [one](https://www.overleaf.com/latex/templates/ieee-conference-template/grfzhhncsfqn)).  
![{EC2BBFC2-6BB1-4832-9EF9-B0C663C72BBB}](https://github.com/user-attachments/assets/f3f454d0-db18-4837-ad8a-9f19d1b420fc)  
3. Select `Open as Template`.
![{88794655-F556-446A-AC0E-34ADA8C2202E}](https://github.com/user-attachments/assets/2f61c11d-5b79-4284-a877-1edfb97e3cc5)
4. Choose one `\section` and paste your LaTeX code from the [converter](https://zedttxj.github.io//MD-To-LaTex/). I chose `\section{Ease of Use}` in this case.
![{16141B28-455A-40F6-BEF7-AF685DF56F5E}](https://github.com/user-attachments/assets/c83d353a-f74b-4f87-8178-efb2d1f44ea2)
5. Click `Compile` (or `Recompile`):  
![{EB372ABA-BDA8-4984-BFF6-37CEB2C83BAA}](https://github.com/user-attachments/assets/44700280-2e49-496c-b65b-88f55130f271)
