function im2 = homemadeImageEqualization(im)
%homemadeImageEqualization improves the contrast/appearance of an image
%
%im2 = homemadeImageEqualization(im) where im is an input image of type
%uint8, and im2 is the output image of type uint8 with an equalized
%histogram

    %extracting dimensions of input image
    [rows, cols] = size(im);

    %computing area of input image
    A0 = rows*cols;

    %creating empty container for output image
    im2 = zeros(rows, cols);

    %obtaining original histogram of input image
    h = imhist(im);

    %computing maximum gray level of input image
    Dm = length(h) - 1;

    %creating empty container for equalizing point operation 
    Db = zeros(Dm + 1, 1);

    %computing cumulative sum and tracking intermediate value in container
    runningsum = 0;
    for i = 1:(Dm + 1)
        runningsum = runningsum + h(i);
        Db(i) = runningsum;
    end

    %scaling sum by max gray level divided by input image area
    Db = (Dm/A0)*Db;

    %discretizing
    Db = round(Db);

    %replacing each input image pixel gray level value with proper Db value
    for r = 1 : rows                                                        %for every row in the input image
        for c = 1 : cols                                                    %for every column in the input image
            GL = uint16(im(r, c));                                          %extracting gray-level value of specific pixel
            im2(r, c) = Db(GL+1);                                           %filling container with proper Db value
        end
    end

    %casting to uint8 after operations 
    im2 = uint8(im2);
end