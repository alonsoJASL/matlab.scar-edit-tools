function pVeinsCroppedEdit(pveinscroppedPath, t, outname) 
% PVeinsCropped.nii EDIT function 
% Reduce the clipper sizes depending on a cube of <t> voxels per side.
% Ideal sizes of t range between 2 and 5.
% 
% USAGE:
% - pVeinsCroppedEdit(pveinscroppedPath, t) % rewrites fname
% - pVeinsCroppedEdit(pveinscroppedPath, t, outname) % changes file name to outname, but saves on same folder
%
% Example:
% pveinspath = 'PVeinsCroppedImage.nii';
% t=3;
% pVeinsCroppedEdit(pveinspath, t, 'NEW_pveinsCroppedImage'); % no extension needed
%

[p2f, fname, exts] = fileparts(pveinscroppedPath);

if isempty(fname)
    cemrg_info('INFO: Assuming name: PVeinsCroppedImage.nii');
    fname = 'PVeinsCroppedImage';
    exts = '.nii';
    inputpath = fullfile(p2f, [fname exts]);
else
    inputpath = pveinscroppedPath;
end

if nargin < 3
    outpath = inputpath;
else
    
    outpath = fullfile(p2f, [outname exts]);
end

se_size = [t t t];

[V, vinfo] = readParseNifti(inputpath);

body=V==1;
clippers=V==3;

dilatedbody=imdilate(body, ones(se_size));
shavings=(dilatedbody+clippers)==2;
newclippers = clippers-shavings;

if ~isempty(find(newclippers(:)<0, 1))
   cemrg_info(sprintf('ERROR: Size of structural element t=%d, too large, aborting', t));
   return;
end

newclippers = imclose(newclippers, ones(2,2,2));

[~,b] = bwlabeln(newclippers);
[~,b0] = bwlabeln(clippers);
if b < b0
   cemrg_info(sprintf('ERROR: Size of structural element t=%d, too large, aborting', t));
   return;
end

Vout = V;
Vout(V>0) = 1;
Vout(newclippers>0) = 3;

niftiwrite(Vout, outpath, vinfo);
