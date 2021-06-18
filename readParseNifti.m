function [Vol, volInfo] = readParseNifti(inputname)
% READ AND PARSE NIFTI FILES. 
% 

inputImageInfo = niftiinfo(inputname);
Vol = niftiread(inputImageInfo);

if nargout > 1
    volInfo = inputImageInfo;
end