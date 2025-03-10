filter = [
    3, 1;
    2, 3;
];
img = ImageProcessor.readImage('test.png', false);
ImageProcessor.dimension(img)

disp(img(1:8,1:8, 1:3));

bayerImage = ImageProcessor.test(img, filter, true, [true true true], [2 2], 2);
ImageProcessor.saveImage(bayerImage, 'output.png');
disp(bayerImage(1:8,1:8))
