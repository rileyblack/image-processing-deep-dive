function thres = homemadeImageThreshold(im)
%homemadeImageThreshold computes threshold to binarize an image
%
%thres = homemadeImageThreshold(im) where im is an image of type uint8, and
%thresh is the output normalized scalar threshold value between 0.0 and 1.0

    %computing input image histogram 
    h = imhist(im);

    %computing input image average gray level for intial threshold guess
    thres = round(mean2(im));

    %defining previous threshold as arbitrary value
    thres_prev = thres + 1;

    %while the threshold value is still changing
    while thres ~= thres_prev
        thres_prev = thres;                                                 %storing current threshold for next iteration
        D1 = 0:thres_prev;                                                  %defining gray levels below current threshold
        meanLow = (D1 * (h(1:thres_prev + 1)) / sum(h(1:thres_prev + 1)));  %computing mean gray level of pixels that are below current threshold
        D2 = thres_prev+1 : (length(h)-1);                                  %defining gray levels above current threshold
        meanHigh = (D2 * (h(thres_prev+2:length(h)))...                     %computing mean gray level of pixels that are above current threshold
            / sum(h(thres_prev+2:length(h))));
        thres = round((meanLow + meanHigh) / 2);                            %re-estimating threshold half way between upper and lower means
    end
    
    %normalizing threshold once found
    thres = ((thres)/(length(h)-1));
end