data = [2 4 3 2];
tmp = ImageProcessor.partitionDecomposition(data);
disp(tmp);
return;
data = [
    1 0 1;
    0 0 0;
    1 1 0
];
disp(data);
data = ImageProcessor.customSorting(data, "rc", [1 0]);
disp(data);
disp(ImageProcessor.convertMatrix2Partition(data));
return;
filter = [
    1, 2;
    2, 3;
];
img = ImageProcessor.readImage("test.png");
bayerImage = ImageProcessor.convert2Bayer(img, filter, true, [true true true], [4 5], 2, "rcr", [2, 1, 3]);
rgbImage = ImageProcessor.convertBayer2RGB(bayerImage, filter, true, [true true true], [4 5], 2, "rcr", [2, 1, 3]);
ImageProcessor.showImage(rgbImage);
imshow(rgb2gray(img));
imshow(rgb2gray(rgbImage));
ImageProcessor.saveImage(rgbImage, "output.png");
