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
            partition = [size(data, 1), size(data, 2) sum(data == 1, 2) .'];
        end
        function combinations = partitionDecomposition(partition)
            matrices = arrayfun(@(i) setDecomposition(partition(2), i), partition(3:end), 'UniformOutput', false);
            numMatrices = numel(matrices);
            ranges = arrayfun(@(i) 1:size(matrices{i}, 1), 1:numMatrices, 'UniformOutput', false);
            [grids{1:numMatrices}] = ndgrid(ranges{:});
            indices = cellfun(@(g) g(:), grids, 'UniformOutput', false);
            combinations = [];
            for i = 1:numel(indices{1})
                rowCombination = cell(1, numMatrices);
                for j = 1:numMatrices
                    rowCombination{j} = matrices{j}(indices{j}(i), :);
                end
                combinations = cat(3, combinations, cell2mat(rowCombination'));
            end
            function tmp = setDecomposition(numColumns, numOnes)
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
            % Show the Bayer-filtered image
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
            if ord > 0
                rgbImage = imresize(rgbImage, [ri+rf-mod(ri,rf), ci+cf-mod(ci,cf)]);
                ri = ri+rf-mod(ri,rf);
                ci = ci+cf-mod(ci,cf);
                if nargin == 8
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, sortorder, custom_order);
                elseif nargin == 7
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, sortorder);
                else
                    [filter, rows, cols] = ImageProcessor.customSorting(filter, "rc");
                end
                if ord == 1
                    rows = repmat(1:cf,rf, 1);
                    cols = repmat((1:rf) .',1,cf);
                end
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
    end
end

