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
        function bayerImage = convert2Bayer(rgbImage, filter, show, rgb, filtersize, ord)
            cls = class(rgbImage(:,:,1));
            [ri, ci, t] = size(rgbImage);
            if nargin < 6
                ord = 0;
            end
            if nargin > 4
                [rf, cf] = size(filter);
                filter = repmat(filter,ceil(filtersize(1)/rf),ceil(filtersize(2)/cf));
                filter = filter(1:filtersize(1),1:filtersize(2));
                if ord == 1
                    filter = sort(sort(filter,2));
                end
            end
            [rf, cf] = size(filter);
            if ord == 2
                rgbImage = imresize(rgbImage, [ri+rf-mod(ri,rf), ci+cf-mod(ci,cf)]);
                ri = ri+rf-mod(ri,rf);
                ci = ci+cf-mod(ci,cf);
                [cols, rows] = meshgrid(1:cf, 1:rf);
                cols = cols - 1;
                rows = rows - 1;
                filter = filter*(rf*cf) + rows*cf + cols;
                filter = sort(sort(filter,2));
                cols = mod(filter, cf) + 1;
                rows = floor(mod(filter,rf*cf)/cf) + 1;
                filter = floor(filter/(rf*cf));
                tmp = cast(zeros(rf,cf,3), cls);
                for i = 1:rf:ri
                    for j = 1:cf:ci
                        i_end = min(i + rf - 1, ri);
                        j_end = min(j + cf - 1, ci);
                        for ii = 1:rf
                            for jj = 1:cf
                                tmp(ii,jj,:) = rgbImage(i+rows(ii,jj)-1, j+cols(ii,jj)-1,:);
                            end
                        end
                        rgbImage(i:i_end, j:j_end, :) = tmp;
                    end
                end
            end
            bayerImage = cast(zeros(ri, ci), cls);
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
                            bayerImage(i:i_end, j:j_end) = bayerImage(i:i_end, j:j_end) + rgbImage(i:i_end, j:j_end, k) .* mask(1:(i_end-i+1), 1:(j_end-j+1));
                        end
                    end
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
                    disp("Swapping matrix:");
                    disp(rows + ", " + cols);
                end
            end
        end
        function showImage(img)
            imshow(img, [])
        end
        function dimension(img)
            disp("Dimention: ")
            disp(size(img))
        end
    end
end

