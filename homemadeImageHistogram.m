function y = homemadeImageHistogram(im, v)
%homemadeImageHistogram counts the number of image pixels that fall within
%various gray level ranges
%
%y = homemadeImageHistogram(im, v) where im is an image of type uint8, v is
%a row vector of strictly increasing gray-level values, and y is a row
%vector populated such that y(i) is the total number of pixels in im that
%satisfy v(i) <= im < v(i+1)

    %extracting length of input row vector of gray-level values
    N = length(v);

    %creating row vector to populate with counts
    y = zeros(1,N-1);    

    %extracting number of rows and columns from image
    [rows, cols] = size(im);                                                    

    %filling histogram bins
    for r = 1 : rows                                                        %for every row in the image
        for c = 1 : cols                                                    %for every column in the image
            GL = im(r, c);                                                  %extracting gray-level value of specific pixel
            for i = 1 : N-1                                                 %for every gray-level value range of interest
                if ((GL >= v(i))&&(GL < v(i+1)))                            %checking if current pixel GL falls within range
                    y(i) = y(i) + 1;                                        %incrementing count if within range
                    break                                                   %proceeding to next pixel if current pixel accounted for
                end
            end
        end
    end
end