# Original Image
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
# Poisson Image
- MATLAB code:
  ```matlab
  img = imread('test.png');
  img = rgb2gray(img);
  decorated = ImageProcessor.transform(img, 'no', 1 / (size(img,1) * size(img,2)), 0);
  
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
# Poisson Image with Cosine
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
# Poisson Image with Sigmoid
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
# Poisson Image with Log
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
