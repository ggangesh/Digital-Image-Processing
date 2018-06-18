%% MyMainScript

%%Following demos are done after shrinking the image size by factor of 3
%% Demo of PatchBased Filtering for sigma = 0.9
tic;
myPatchBasedFiltering(0.9, 0.9);
toc;
%% Demo of PatchBased Filtering for sigma = 1.1
tic;
myPatchBasedFiltering(1.1, 1.1);
toc;
