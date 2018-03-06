function Iout = fun_preprocessImage(filename)
% Load the image
I = imread(filename);
% Some images may be grayscale. Replicate the image 3 times to
% create an RGB image.
if ismatrix(I)
    I = cat(3,I,I,I);
end
% Resize the image as required for the CNN.
Iout = imresize(I, [227 227]);
% Typecast into single [0,1]
Iout = single(mat2gray(Iout));
end