function test_functions()
    fprintf('Running tests...\n');
    
    test_convertPartition2Matrix();
    test_convertMatrix2Partition();
    test_partitionDecomposition();
    test_ImageProcessor_convert2Bayer();
    test_ImageProcessor_convertBayer2RGB();
    extra_tests();
    fprintf('All tests completed.\n');
end

function extra_tests()
    try
        data = [2 4 3 2];
        tmp = ImageProcessor.partitionDecomposition(data);
        disp("partitionDecomposition passed:");
        disp(tmp);
    catch ME
        disp("partitionDecomposition failed: " + ME.message);
    end
    
    try
        data = [
            1 0 1;
            0 0 0;
            1 1 0
        ];
        disp("Original data:");
        disp(data);
        data = ImageProcessor.customSorting(data, "rc", [1 0]);
        disp("customSorting passed:");
        disp(data);
        disp("convertMatrix2Partition output:");
        disp(ImageProcessor.convertMatrix2Partition(data));
    catch ME
        disp("customSorting or convertMatrix2Partition failed: " + ME.message);
    end
    
    try
        filter = [
            1, 2;
            2, 3;
        ];
        img = ImageProcessor.readImage("test.png");
        disp("Image read successfully.");
        
        bayerImage = ImageProcessor.convert2Bayer(img, filter, true, [true true true], [4 5], 1, "rcr", [2, 1, 3]);
        disp("convert2Bayer passed for mode 1.");
        
        bayerImage = ImageProcessor.convert2Bayer(img, filter, true, [true true true], [4 5], 0, "rcr", [2, 1, 3]);
        disp("convert2Bayer passed for mode 0.");
        
        bayerImage = ImageProcessor.convert2Bayer(img, filter, true, [true true true], [4 5], 2, "rcr", [2, 1, 3]);
        disp("convert2Bayer passed for mode 2.");
        
        rgbImage = ImageProcessor.convertBayer2RGB(bayerImage, filter, true, [true true true], [4 5], 2, "rcr", [2, 1, 3]);
        disp("convertBayer2RGB passed.");
        
        ImageProcessor.showImage(rgbImage);
        imshow(rgb2gray(img));
        imshow(rgb2gray(rgbImage));
        ImageProcessor.saveImage(rgbImage, "output.png");
        disp("Image processing completed and saved successfully.");
    catch ME
        disp("Image processing failed: " + ME.message);
    end
end

function test_convertPartition2Matrix()
    fprintf('Testing convertPartition2Matrix...\n');
    
    try
        partition = [1, 2, 'a'; 4, 5, 6];
        ImageProcessor.convertPartition2Matrix(partition);
        error('Test Failed: Invalid Partition should have thrown an error');
    catch
        fprintf('Passed: Invalid Partition have thrown an error\n');
    end
    try
        partition = [];
        ImageProcessor.convertPartition2Matrix(partition);
        error('Test Failed: Invalid Partition have thrown an error');
    catch
        fprintf('Passed: Empty Matrix\n');
    end
end

function test_convertMatrix2Partition()
    fprintf('Testing convertMatrix2Partition...\n');
    
    matrix = [];
    partition = ImageProcessor.convertMatrix2Partition(matrix);
    assert(~isempty(partition), 'Test Failed: Empty Matrix');
end

function test_partitionDecomposition()
    fprintf('Testing partitionDecomposition...\n');
    partition = [1, 2, 3; 4, 5, 6];
    decomposed = ImageProcessor.partitionDecomposition(partition);
    assert(~isempty(decomposed), 'Test Failed: Valid Decomposition');
    
    try
        partition = [1, 2, 'a'; 4, 5, 6];
        ImageProcessor.partitionDecomposition(partition);
        error('Test Failed: Invalid Partition should have thrown an error');
    catch
        fprintf('Passed: Invalid Partition\n');
    end
end

function test_ImageProcessor_convert2Bayer()
    fprintf('Testing ImageProcessor.convert2Bayer...\n');
    filter = [
        1 2;
        2 3
    ];
    rgbImage = cat(3, [255, 0, 0], [0, 255, 0], [0, 0, 255]);
    bayerImage = ImageProcessor.convert2Bayer(rgbImage, filter, false);
    assert(~isempty(bayerImage), 'Test Failed: RGB to Bayer');
    
    grayscaleImage = [100, 150, 200];
    try
        bayerImage = ImageProcessor.convert2Bayer(grayscaleImage);
        error('Test Failed: Grayscale to Bayer should have thrown an error');
    catch
        fprintf('Passed: Grayscale to Bayer have thrown an error\n');
    end
end

function test_ImageProcessor_convertBayer2RGB()
    fprintf('Testing ImageProcessor.convertBayer2RGB...\n');
    filter = [
        1 2;
        2 3
    ];
    bayerImage = [255, 0, 0; 0, 255, 255];
    rgbImage = ImageProcessor.convertBayer2RGB(bayerImage, filter, false);
    assert(~isempty(rgbImage), 'Test Failed: Bayer to RGB');
    
    try
        bayerImage = [255, 'a', 0];
        ImageProcessor.convertBayer2RGB(bayerImage);
        error('Test Failed: Invalid Bayer Image should have thrown an error');
    catch
        fprintf('Passed: Invalid Bayer Image\n');
    end
end
