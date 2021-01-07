function [im2, a] = homemadeImageBackgroundRemoval(fname)
%homemadeImageBackgroundRemoval removes the background of an image
%
%function [im2, a] = homemadeImageBackgroundRemoval(fname) where 'fname' is
%a string representing the filename of the file containing the image, 'im2'
%is the background removed image, and 'a' is a vector of 6 coefficients of
%the least-squares estimated background function
    
    %reading in image from file
    im = imread(fname);

    %extracting image size
    [rows, cols] = size(im);


    %----------------------------------------------------------------------
    %determining background points
    %----------------------------------------------------------------------

    %defining proximity of background points
    blockrows = 16;
    blockcols = 16;

    %calculating number background points
    rowwise = rows/blockrows;
    columnwise = cols/blockcols;

    %creating empty containers to hold point coordinates
    xs = zeros(1, rowwise*columnwise);
    ys = zeros(1, rowwise*columnwise);
    
    %creating empty container to hold gray level values of points
    Is = zeros(1, rowwise*columnwise);

    %creating index to track container population
    containerindex = 1;

    %selecting points
    for i = 1:rowwise                                                       %for each row-wise block
        rowstartindex = 1 + (blockrows*(i-1));                              %calculating current row-wise block start index                                           
        rowendindex = (blockrows*(i));                                      %calculating current row-wise block end index
        
        for j = 1:columnwise                                                %for each column-wise block
            colstartindex = 1 + (blockcols*(j-1));                          %calculating current column-wise block start index
            colendindex = (blockcols*(j));                                  %calculating current column-wise block end index

            %extracting current block from image
            block = im(rowstartindex:rowendindex, colstartindex:colendindex);

            %finding minimum gray level within current block
            minimum = min(min(block));

            %finding (local block) indicies of minimum gray level
            [blockrowindex, blockcolindex] = find(block == minimum, 1);

            %adding (global image) coordinates to container
            xs(containerindex) = blockcolindex + colstartindex - 1;
            ys(containerindex) = blockrowindex + rowstartindex - 1;

            %adding gray level value to gray level value container
            Is(containerindex) = minimum;

            %updating container index for next point
            containerindex = containerindex + 1;
        end
    end


    %----------------------------------------------------------------------
    %displaying unlevelled image with superimposed points
    %----------------------------------------------------------------------

    %displaying unlevelled image
    imshow(im);
    hold on;

    %superimposing points onto image
    plot(xs, ys, 'y+');
    hold off


    %----------------------------------------------------------------------
    %fitting background points to least-squares background function
    %----------------------------------------------------------------------

    %calculating least-squares [C] matrix elements
    columnwise = length(xs);
    Sx = sum(xs);
    Sy = sum(ys);
    Sxx = sum(xs.*xs);
    Syy = sum(ys.*ys);
    Sxy = sum(xs.*ys);
    Sxxx = sum(xs.^3);
    Sxxy = sum(xs.*xs.*ys);
    Sxyy = sum(xs.*ys.*ys);
    Syyy = sum(ys.^3);
    Sxxxx = sum(xs.^4);
    Sxxxy = sum(ys.*xs.^3);
    Sxxyy = sum(xs.*xs.*ys.*ys);
    Sxyyy = sum(xs.*ys.^3);
    Syyyy = sum(ys.^4);

    %constructing least-squares [C] matrix
    C = [columnwise    Sx  Sy   Sxx   Syy   Sxy;
        Sx   Sxx Sxy  Sxxx  Sxyy  Sxxy;
        Sy   Sxy Syy  Sxxy  Syyy  Sxyy;
        Sxx Sxxx Sxxy Sxxxx Sxxyy Sxxxy;
        Syy Sxyy Syyy Sxxyy Syyyy Sxyyy;
        Sxy Sxxy Sxyy Sxxxy Sxyyy Sxxyy];

    %calculating least-squares {k} vector elements 
    SI = sum(Is);
    SxI = sum(xs.*Is);
    SyI = sum(ys.*Is);
    SxxI = sum(xs.*xs.*Is);
    SyyI = sum(ys.*ys.*Is);
    SxyI = sum(xs.*ys.*Is);

    %constructing least-squares {k} vector 
    k = [SI SxI SyI SxxI SyyI SxyI]';

    %solving least-squares problem [C]{a} = {k} for coefficient vector {a}
    a = C\k;


    %----------------------------------------------------------------------
    %removing background
    %----------------------------------------------------------------------

    %creating background pixel coordinates
    [x, y] = meshgrid(1:cols, 1:rows);

    %evaluating background function at pixel coordinates
    background = a(1) + a(2)*x + a(3)*y + a(4)*x.*x + a(5)*y.*y +a(6)*x.*y;

    %removing background from original image
    im2 = double(im) - background;


    %----------------------------------------------------------------------
    %formatting return
    %----------------------------------------------------------------------

    %converting result from matrix back to image
    im2 = mat2gray(im2);

    %converting result from double image to uint8 image
    im2 = im2uint8(im2);
end