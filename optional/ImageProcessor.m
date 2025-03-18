classdef ImageProcessor
    methods(Static)
        function img = readImage(filename, log)
            if nargin < 2
                log = false;
            end
            if ~log
                warning('off', 'all')
                disp('Log is disable!')
            else
                warning('on', 'all')
                disp('Log is enable!')
            end
            img = imread(filename);
        end
        function grayImg = toGray(img)
            grayImg = rgb2gray(img);
        end
        function saveImage(img, filename)
            imwrite(img, filename);
            disp("Image is saved at: " + pwd);
        end
        function matrix = convertPartition2Matrix(data)
            matrix = zeros(data(1),data(2));
            for i = 3:length(data);
                matrix(i-2,1:data(i)) = 1;
            end
        end
        function partition = convertMatrix2Partition(data)
            partition = [size(data, 1), size(data, 2) sum(data > 0, 2) .'];
        end
        function combinations = partitionDecomposition(partition, binary)
            if nargin < 2
                binary = false;
            end
            rend = min(3+partition(1)-1, length(partition));
            if binary
                matrices = arrayfun(@(i) setDecompositionBinary(partition(2), i), partition(3:rend), 'UniformOutput', false);
            else
                matrices = arrayfun(@(i) setDecompositionNumeric(partition(2), i), partition(3:rend), 'UniformOutput', false);
            end
            rend = rend-2;
            ranges = arrayfun(@(i) 1:size(matrices{i}, 1), 1:rend, 'UniformOutput', false);
            [grids{1:rend}] = ndgrid(ranges{:});
            indices = cellfun(@(g) g(:), grids, 'UniformOutput', false);
            if binary
                combinations = false(partition(1), partition(2), numel(indices{1}));
            else
                combinations = zeros(partition(1), partition(2), numel(indices{1}));
            end
            for i = 1:numel(indices{1})
                for j = 1:rend
                    combinations(j, :, i) = matrices{j}(indices{j}(i), :);
                end
            end
            function tmp = setDecompositionBinary(numColumns, numOnes)
                tmp = false(1, numColumns);
                decomposition = nchoosek(1:numColumns, numOnes);
                for j = 1:size(decomposition, 1)
                    tmp(j, decomposition(j,:)) = true;
                end
            end
            function tmp = setDecompositionNumeric(numColumns, numOnes)
                tmp = zeros(1, numColumns);
                decomposition = nchoosek(1:numColumns, numOnes);
                for j = 1:size(decomposition, 1)
                    tmp(j, decomposition(j,:)) = 1;
                end
            end
        end
        % This function is for analyzing the algorithmic purposes
        function [sorted_matrix, rows, cols] = customSorting(data, ord, custom_order)
            ord = char(ord);
            if nargin < 3
                custom_order = 1:max(max(data));
            end
            tmpr = repmat(1:size(data,2),size(data,1), 1);
            rows = tmpr;
            tmpc = repmat((1:size(data,1)) .',1,size(data,2));
            cols = tmpc;
            tmp = tmpr;
            for i = 1:length(ord)
                if ord(i) == 'r'
                    [sorted_matrix, tmp] = arrayfun(@(r) sortRow(data(r, :), custom_order), (1:size(data, 1)), 'UniformOutput', false);
                    data = vertcat(sorted_matrix{:});
                    tmp = vertcat(tmp{:});
                    rows = rows(sub2ind(size(cols), tmpc, tmp));
                    cols = cols(sub2ind(size(cols), tmpc, tmp));
                elseif ord(i) == 'c'
                    [sorted_matrix, tmp] = arrayfun(@(c) sortColumn(data(:, c), custom_order), 1:size(data, 2), 'UniformOutput', false);
                    data = horzcat(sorted_matrix{:});
                    tmp = horzcat(tmp{:});
                    cols = cols(sub2ind(size(cols), tmp, tmpr));
                    rows = rows(sub2ind(size(rows), tmp, tmpr));
                end
            end
            sorted_matrix = data;
            function [sorted_col, idx] = sortColumn(column, custom_order)
                [~, new_order] = ismember(column, custom_order);
                [~, idx] = sort(new_order);
                sorted_col = column(idx);
            end
            function [sorted_row, idx] = sortRow(row, custom_order)
                [~, new_order] = ismember(row, custom_order);
                [~, idx] = sort(new_order);
                sorted_row = row(idx);
            end
        end
        function rgbImage = convertBayer2RGB(bayerImage, filter, show, rgb, filtersize, ord, sortorder, custom_order)
            cls = class(bayerImage(:,:));
            [ri, ci] = size(bayerImage);
            if nargin < 6
                ord = 0;
            end
            if nargin > 4
                [rf, cf] = size(filter);
                filter = repmat(filter,ceil(filtersize(1)/rf),ceil(filtersize(2)/cf));
                filter = filter(1:filtersize(1),1:filtersize(2));
            end
            [rf, cf] = size(filter);
            if ord > 0
                if nargin == 8
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, sortorder, custom_order);
                elseif nargin == 7
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, sortorder);
                else
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, "rc");
                end
            end
            rgbImage = cast(zeros(ri, ci, 3), cls);
            if nargin < 4
                rgb = [true true true];
            end
            for k = 1:3
                if rgb(k)
                    mask = cast(filter == k, cls);
                    for i = 1:rf:ri
                        for j = 1:cf:ci
                            i_end = min(i + rf - 1, ri);
                            j_end = min(j + cf - 1, ci);
                            rgbImage(i:i_end, j:j_end,k) = bayerImage(i:i_end, j:j_end) .* mask(1:(i_end-i+1), 1:(j_end-j+1));
                        end
                    end
                end
            end
            if nargin < 3
                show = true;
            end
            % Show the rgb Bayer-filtered image
            if show
                imshow(rgbImage, []);
                disp("Filter maxtrix:");
                disp(filter);
            end
        end
        function bayerImage = convert2Bayer(rgbImage, filter, show, rgb, filtersize, ord, sortorder, custom_order)
            cls = class(rgbImage(:,:,1));
            [ri, ci, t] = size(rgbImage);
            if nargin < 6
                ord = 0;
            end
            if nargin > 4
                [rf, cf] = size(filter);
                filter = repmat(filter,ceil(filtersize(1)/rf),ceil(filtersize(2)/cf));
                filter = filter(1:filtersize(1),1:filtersize(2));
            end
            [rf, cf] = size(filter);
            rgbImage = imresize(rgbImage, [ri+rf-mod(ri,rf), ci+cf-mod(ci,cf)]);
            ri = ri+rf-mod(ri,rf);
            ci = ci+cf-mod(ci,cf);
            if ord > 0
                if nargin == 8
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, sortorder, custom_order);
                elseif nargin == 7
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, sortorder);
                else
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, "rc");
                end
            end
            if ord < 2
                rows = repmat(1:cf,rf, 1);
                cols = repmat((1:rf) .',1,cf);
            end
            bayerImage = cast(zeros(ri, ci), cls);
            if nargin < 4
                rgb = [true true true];
            end
            rgb = cast(reshape(rgb,1,1,[]), cls);
            rgbImage = rgbImage .* rgb;
            for i = 1:rf:ri
                for j = 1:cf:ci
                    i_end = min(i + rf - 1, ri);
                    j_end = min(j + cf - 1, ci);
                    tmp = rgbImage(i:i_end, j:j_end,:);
                    bayerImage(i:i_end, j:j_end) = tmp(sub2ind(size(tmp), cols, rows, filter));
                end
            end
            if nargin < 3
                show = true;
            end
            % Show the Bayer-filtered image
            if show
                imshow(bayerImage, []);
                disp("Filter maxtrix:");
                disp(filter);
                if ord == 2
                    disp("Swapping matrix (row index, column index):");
                    disp(cols + ", " + rows);
                end
            end
        end
        function showImage(img)
            imshow(img, [])
        end
        function dimension(img)
            disp("Dimension: ")
            disp(size(img))
        end
        function partitions = BP(binarymatrices)
            partitions = ImageProcessor.convertMatrix2Partition(binarymatrices);
            partitions(3:end) = sort(partitions(3:end), 'descend');
        end
        function coloredPartitions = PC(lambda, G, order, warn)
            if nargin < 4
                warn = true;
            end
            if warn
                disp("Warning: lambda shouldn't contain the sizes of the matrix");
            end
            G = char(G);
            charMap = 'RGB';
            [~, idx] = ismember(G, charMap);
            order(~ismember(order, idx)) = 4;
            [sz, sz2] = size(order);
            lb = length(lambda);
            mat = repmat(order(mod((0:lb-1)', sz) + 1, :), 1, ceil(max(lambda)/sz2));
            mask = (1:size(mat,2)) > lambda(:);
            mat(mask) = 4;
            mat = ImageProcessor.customSorting(mat,"rc");
            coloredPartitions = [size(mat, 1), size(mat, 2) sum(mat < 4, 2) .'];
            coloredPartitions = coloredPartitions(3:end);
        end
        function filteredMatrix = IC1(A, G, order, print)
            [rf, cf] = size(order);
            [ri, ci] = size(A);
            A = imresize(A, [ri+rf-mod(ri+rf-1,rf)-1, ci+cf-mod(ci+cf-1,cf)-1]);
            [ri, ci] = size(A);
            rows = repmat(1:cf,rf, 1);
            cols = repmat((1:rf) .',1,cf);
            G = char(G);
            charMap = 'RGB';
            [~, idx] = ismember(G, charMap);
            custom_order = 1:3;
            custom_order = [custom_order(idx), custom_order(~ismember(charMap, G))];
            [order, rows, cols] = ImageProcessor.customSorting(order, "rc", custom_order);
            tmp = zeros(rf,cf);
            ind = sub2ind([rf cf],cols,rows);
            filteredMatrix = zeros(ri,ci);
            i_end = 0;
            j_end = 0;
            for i = 1:rf:ri
                for j = 1:cf:ci
                    i_end = i+rf-1;
                    j_end = j+cf-1;
                    tmp = A(i:i_end, j:j_end);
                    filteredMatrix(i:i_end, j:j_end) = tmp(ind);
                end
            end
            if nargin < 4
                print = true;
            end
            if print
                disp("Sorted order:");
                disp(order);
            end
        end
        function filteredImage = IC2(image, G, order, print)
            [rf, cf] = size(order);
            [ri, ci, chl] = size(image);
            image = imresize(image, [ri+rf-mod(ri+rf-1,rf)-1, ci+cf-mod(ci+cf-1,cf)-1]);
            [ri, ci, chl] = size(image);
            rows = repmat(1:cf,rf, 1);
            cols = repmat((1:rf) .',1,cf);
            G = char(G);
            charMap = 'RGB';
            [~, idx] = ismember(G, charMap);
            custom_order = 1:3;
            custom_order = [custom_order(idx), custom_order(~ismember(charMap, G))];
            [order, rows, cols] = ImageProcessor.customSorting(order, "rc", custom_order);
            tmp = zeros(rf,cf);
            ind = sub2ind([rf cf],cols,rows);
            filteredImage = cast(zeros(ri,ci,3), class(image(:,:,:)));
            i_end = 0;
            j_end = 0;
            for i = 1:rf:ri
                for j = 1:cf:ci
                    i_end = i+rf-1;
                    j_end = j+cf-1;
                    tmp = image(i:i_end, j:j_end,1);
                    filteredImage(i:i_end, j:j_end,1) = tmp(ind);
                    tmp = image(i:i_end, j:j_end,2);
                    filteredImage(i:i_end, j:j_end,2) = tmp(ind);
                    tmp = image(i:i_end, j:j_end,3);
                    filteredImage(i:i_end, j:j_end,3) = tmp(ind);
                end
            end
            if nargin < 4
                print = true;
            end
            if print
                disp("Sorted order:");
                disp(order);
            end
        end
        function filteredImage = Bayer1(image,G,order,show)
            if nargin < 4
                show = false
            end
            G = char(G);
            charMap = 'RGB';
            [~, idx] = ismember(G, charMap);
            custom_order = 1:3;
            custom_order = [custom_order(idx), custom_order(~ismember(charMap, G))];
            filteredImage = ImageProcessor.convert2Bayer(image, order, show, [true true true], size(order), 2, "rc", custom_order);
        end
        function filteredImage = Bayer2(image,G,order,show)
            if nargin < 4
                show = false
            end
            G = char(G);
            charMap = 'RGB';
            [~, idx] = ismember(G, charMap);
            custom_order = 1:3;
            custom_order = [custom_order(idx), custom_order(~ismember(charMap, G))];
            image = ImageProcessor.convert2Bayer(image, order, show, [true true true], size(order), 2, "rc", custom_order);
            filteredImage = ImageProcessor.convertBayer2RGB(image, order, show, [true true true], size(order), 2, "rc", custom_order);
        end
        function erodedImage = erosionWithConv2(A, B)
            B = double(B); 
            convResult = conv2(double(A), B, 'full');
            threshold = sum(B(:));
            erodedImage = (convResult == threshold);
        end
        function dilatedImage = dilationWithCon2(A, B)
            dilatedImage = conv2(A, B, 'full') > 0;
        end
        function dilatedImage = subdilation(A, B, mode)
            [ri ci] = size(B);
            tmp = cast(zeros(size(A)+([ri ci]-1)*2),class(A(:,:)));
            if mode == 2
                A = A/16;
                B = B/16;
            end
            dilatedImage = cast(zeros(size(A)+([ri ci]-1)),class(A(:,:)));
            tmp(ri:end-ri+1,ci:end-ci+1) = A;
            for i = 1:size(dilatedImage,1)
                for j = 1:size(dilatedImage,2)
                    dilatedImage(i,j) = max(max(tmp(i:i+ri-1,j:j+ci-1) .* B));
                end
            end
        end
        function erodedImage = suberosion(A, B, mode)
            [ri ci] = size(B);
            tmp = cast(zeros(size(A)+([ri ci]-1)*2),class(A(:,:)));
            if mode == 2
                A = A/16;
                B = B/16;
            end
            erodedImage = cast(zeros(size(A)+([ri ci]-1)),class(A(:,:)));
            tmp(ri:end-ri+1,ci:end-ci+1) = A;
            for i = 1:size(erodedImage,1)
                for j = 1:size(erodedImage,2)
                    erodedImage(i,j) = min(min(tmp(i:i+ri-1,j:j+ci-1) .* B));
                end
            end
        end
        function dilatedImage = Dilation2(A, B)
            dilatedImage = [];
            [ri ci chn] = size(A);
            for i = 1:chn
                dilatedImage = cat(3,dilatedImage,ImageProcessor.subdilation(A(:,:,i),B(:,:,i), 2));
            end
        end
        function erodedImage = Erosion2(A, B)
            erodedImage = [];
            [ri ci chn] = size(A);
            for i = 1:chn
                erodedImage = cat(3,erodedImage,ImageProcessor.suberosion(A(:,:,i),B(:,:,i), 2));
            end
        end
        function dilatedImage = Dilation1(A, B)
            dilatedImage = [];
            [ri ci chn] = size(A);
            for i = 1:chn
                dilatedImage = cat(3,dilatedImage,ImageProcessor.dilationWithCon2(A(:,:,i),B(:,:,i)));
            end
        end
        function erodedImage = CommutativeErosion(A, B)
            erodedImage = [];
            [ri ci chn] = size(A);
            for i = 1:chn
                erodedImage = cat(3,erodedImage,ImageProcessor.erosionWithConv2(A(:,:,i),B(:,:,i)));
            end
        end
        function erodedImage = Erosion1(A, B)
            erodedImage = [];
            [ri ci chn] = size(A);
            for i = 1:chn
                erodedImage = cat(3,erodedImage,ImageProcessor.suberosion(A(:,:,i),B(:,:,i), 1));
            end
        end
        function binaryMatrix = Opening1(binaryMatrix1, binaryMatrix2)
            binaryMatrix = ImageProcessor.Dilation1(ImageProcessor.Erosion1(binaryMatrix1, binaryMatrix2), binaryMatrix2);
        end
        function binaryMatrix = Opening2(binaryMatrix1, binaryMatrix2)
            
            binaryMatrix = ImageProcessor.Dilation2(ImageProcessor.Erosion2(binaryMatrix1, binaryMatrix2), binaryMatrix2);
        end
        function binaryMatrix = Closing1(binaryMatrix1, binaryMatrix2)
            binaryMatrix = ImageProcessor.Erosion1(ImageProcessor.Dilation1(binaryMatrix1, binaryMatrix2), binaryMatrix2);
        end
        function binaryMatrix = Closing2(binaryMatrix1, binaryMatrix2)
            
            binaryMatrix = ImageProcessor.Erosion2(ImageProcessor.Dilation2(binaryMatrix1, binaryMatrix2), binaryMatrix2);
        end
        function polynomialProduct = PPP1(partition1, partition2)
            polynomialProduct = conv(partition1, partition2);
        end
    end
end
