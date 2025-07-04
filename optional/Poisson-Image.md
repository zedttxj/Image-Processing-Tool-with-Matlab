# Derivatives
## Original Image
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = double(img);
  imshow(img);
  
  I_min = min(decorated(:));
  I_max = max(decorated(:));
  decorated = (decorated - I_min) / (I_max - I_min);
  
  % Compute FFT
  F = fftshift(fft2(decorated));
  magnitude = abs(F);
  
  % Show spectrum
  figure;
  imshow(log(1 + magnitude), []);
  title('Log Magnitude Spectrum of Decorated Image');
  ```
- Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/grayscale.png)
- DCT Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/grayscale_fft.png)
## Poisson Image
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = ImageProcessor.transform(img, 'no');
  
  I_min = min(decorated(:));
  I_max = max(decorated(:));
  decorated = (decorated - I_min) / (I_max - I_min);
  
  % Compute FFT
  F = fftshift(fft2(decorated));
  magnitude = abs(F);
  
  % Show spectrum
  figure;
  imshow(log(1 + magnitude), []);
  title('Log Magnitude Spectrum of Decorated Image');
  ```
- Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/poisson.png)
- DCT Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/poisson_fft.png)
## Poisson Image with Cosine
We apply this function on the Poisson image: `abs(cos(<intensity>))`  
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = ImageProcessor.transform(img, 'cos');
  
  I_min = min(decorated(:));
  I_max = max(decorated(:));
  decorated = (decorated - I_min) / (I_max - I_min);
  
  % Compute FFT
  F = fftshift(fft2(decorated));
  magnitude = abs(F);
  
  % Show spectrum
  figure;
  imshow(log(1 + magnitude), []);
  title('Log Magnitude Spectrum of Decorated Image');
  ```
- Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/cos.png)
- DCT Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/cos_fft.png)
## Poisson Image with Cosine v2
We apply this function on the Poisson image: `(cos(<intensity>) + 1) / 2`  
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = ImageProcessor.transform(img, 'cos2');
  
  I_min = min(decorated(:));
  I_max = max(decorated(:));
  decorated = (decorated - I_min) / (I_max - I_min);
  
  % Compute FFT
  F = fftshift(fft2(decorated));
  magnitude = abs(F);
  
  % Show spectrum
  figure;
  imshow(log(1 + magnitude), []);
  title('Log Magnitude Spectrum of Decorated Image');
  ```
- Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/cos2.png)
- DCT Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/cos2_fft.png)
## Poisson Image with Cosine v3
We apply this function on the Poisson image: `cos(pi / (2 * scale * val))`  
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = ImageProcessor.transform(img, 'cos3', 1 / (size(img,1) * size(img,2)));
  
  I_min = min(decorated(:));
  I_max = max(decorated(:));
  decorated = (decorated - I_min) / (I_max - I_min);
  
  % Compute FFT
  F = fftshift(fft2(decorated));
  magnitude = abs(F);
  
  % Show spectrum
  figure;
  imshow(log(1 + magnitude), []);
  title('Log Magnitude Spectrum of Decorated Image');
  ```
- Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/cos3.png)
- DCT Image: full of NaN (could be due to sharp increases in pixels leading to very large frequencies values).
## Poisson Image with Sigmoid
We apply this function on the Poisson image: `1 / (1 + exp(-scale * (<intensity> - threshold)))`  
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = ImageProcessor.transform(img, 'sigmoid', 1 / (size(img,1) * size(img,2)), 0);
  
  I_min = min(decorated(:));
  I_max = max(decorated(:));
  decorated = (decorated - I_min) / (I_max - I_min);
  
  % Compute FFT
  F = fftshift(fft2(decorated));
  magnitude = abs(F);
  
  % Show spectrum
  figure;
  imshow(log(1 + magnitude), []);
  title('Log Magnitude Spectrum of Decorated Image');
  ```
- Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/sigmoid.png)
- DCT Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/sigmoid_fft.png)
## Poisson Image with Log
We apply this function on the Poisson image: `log(1 + scale * (<intensity> - threshold))`  
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = ImageProcessor.transform(img, 'log', 1 / (size(img,1) * size(img,2)), 0);
  
  I_min = min(decorated(:));
  I_max = max(decorated(:));
  decorated = (decorated - I_min) / (I_max - I_min);
  
  % Compute FFT
  F = fftshift(fft2(decorated));
  magnitude = abs(F);
  
  % Show spectrum
  figure;
  imshow(log(1 + magnitude), []);
  title('Log Magnitude Spectrum of Decorated Image');
  ```
- Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/log.png)
- DCT Image: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/log_fft.png)
# Multinomial Log-PMF for Grayscale Images
Explores how a multinomial probability model can be used to transform a grayscale image into a new representation that combines position and intensity as pseudo-counts
## Model Idea
Each pixel is treated as a “sample” described by:
- x → horizontal coordinate (range: 0 to 400)
- y → vertical coordinate (range: 0 to 600)
- t → grayscale intensity (range: 0 to 255)
- The sum: S=x+y+t
## Multinomial Log-PMF
We interpret this triplet as pseudo-counts in a multinomial distribution:
`lnP(x,y,t)=ln(S!)−ln(x!)−ln(y!)−ln(t!)+xln(x/S)+yln(y/S)+tln(t/S)`
## How it works
- For each pixel, compute its ((x,y,t) and the log-PMF
- Store the result as the decorated image
- Optional: To recover the actual multinomial probability: `P(x, y, t) = exp(<ln P>)`. This gives the true probability. In practice, it’s usually extremely tiny —  so the **log-space version** is what you visualize.

---

**Below:**  
These example outputs show why the log version is useful and how the PMF behaves:

- **Decorated (Raw Multinomial PMF)**  
  ![Multinomial PMF](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/multinomial.png)

- **FFT Spectrum of the PMF**  
  ![Multinomial FFT](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/multinomial_fft.png)

- **Histogram + CDF of the PMF**  
  ![Multinomial Histogram](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/multinomial_histo.png)

The PMF itself is nearly zero for most pixels — only the log-PMF reveals the structure clearly.
## Example Output
Below:
- The decorated image (log-PMF): ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/multinomialLog.png)
- The FFT spectrum (frequency content of the transform): ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/multinomialLog_fft.png)
- The histogram + CDF of the log-PMF values: ![Gray scale image](https://github.com/zedttxj/Image-Processing-Tool-with-Matlab/blob/main/optional/multinomialLog_cdf.png)
