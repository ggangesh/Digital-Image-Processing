function myPatchBasedFiltering( sigmaSpacial, sigmaIntensity )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%%%%%% WE refered to the algorithm from the link http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6738179&tag=1
windowsize = 25;
pathsize = 9;
p = (pathsize - 1) /2;
inpImg = 'data\barbara.mat';
f1 = load(inpImg,'-mat');
f2 = f1.imageOrig;
original = mat2gray(f2);
original = original(1:3:end , 1:3:end); 
in_rows = size(original,1);
in_cols = size(original,2);
corrupted =  original + 0.05*randn(size(original));
iMin=0;
iMax=0;
jMin=0;
jMax=0;
w = (windowsize-1) /2; % half windowsize
w = round(w);
num = zeros(in_rows,in_cols);
den = zeros(in_rows,in_cols);
spacialDiff = zeros(windowsize, windowsize);
expPatchDiff = zeros(windowsize, windowsize);
window = zeros(windowsize, windowsize);
rangeDifference = zeros(windowsize, windowsize);
count = 0;
for i = 1:in_rows
    
    if ((i - p)>1)
        ipMin = i-p;
    else
        ipMin = 1;
    end;
    if ((i + p)< in_rows)
        ipMax = i+p;
    else
        ipMax = in_rows;
    end;
    
    if ((i - w)>1)
        iMin = i-w;
    else
        iMin = 1;
    end;
    if ((i + w)< in_rows)
        iMax = i+w;
    else
        iMax = in_rows;
    end;
    for j = 1:in_cols 
        count = count + 1;
        %disp(count);
        if ((j - p)>1)
            jpMin = j-p;
        else
            jpMin = 1;
        end;
        if ((j + p)< in_cols)
            jpMax = j+p;
        else
            jpMax = in_cols;
        end;
        
        if ((j - w)>1)
            jMin = j-w;
        else
            jMin = 1;
        end;
        if ((j + w)< in_cols)
            jMax = j+w;
        else
            jMax = in_cols;
        end;
        
        for ip2 = ipMin:ipMax
                    for jp2 = jpMin:jpMax
                        patch2((ip2 - ipMin + 1),(jp2 - jpMin + 1)) = corrupted(ip2, jp2);
                    end;
        end;
        for i1 = iMin:iMax
            if ((i1 - p)>1)
                i1Min = i1-p;
            else
                i1Min = 1;
            end;
            if ((i1 + p)< in_rows)
                i1Max = i1+p;
            else
                i1Max = in_rows;
            end;
            for j1 = jMin:jMax
                window((i1 - iMin + 1),(j1-jMin+1)) = corrupted(i1, j1);
                spacialDiff((i1-iMin + 1), (j1 - jMin + 1)) = (i - i1)*(i - i1) +(j - j1)*(j-j1);
                if ((j1 - p)>1)
                    j1Min = j1-p;
                else
                    j1Min = 1;
                end;
                if ((j1 + p)< in_cols)
                    j1Max = j1+p;
                else
                    j1Max = in_cols;
                end;
                
                if((i1 - i1Min)<(i - ipMin)) xMin= (i1 - i1Min); else xMin = (i - ipMin); end;
                if((j1 - j1Min)<(j - jpMin)) yMin= (j1 - j1Min); else yMin = (j - jpMin); end;
                if((i1Max - i1)<(ipMax - i)) xMax= (i1Max - i1); else xMax = (ipMax - i); end;
                if((j1Max - j1)<(jpMax - j)) yMax= (j1Max - j1); else yMax = (jpMax - j); end;
                
                patch1 = zeros((i1Max - i1Min + 1),(j1Max - j1Min + 1));
                for ip = i1Min:i1Max
                    for jp = j1Min:j1Max
                        patch1((ip - i1Min + 1),(jp - j1Min + 1)) = corrupted(ip, jp);
                    end;
                end;
                patchDiff = 0;
                for x = 1:(xMin+xMax+1)
                    for y = 1:(yMin+yMax+1)
                        patchDiff =patchDiff + (((patch1(x,y) - patch2(x,y))*(patch1(x,y) - patch2(x,y)))/(sigmaIntensity*sigmaIntensity));
                    end;
                end;
                expPatchDiff((i1 - iMin + 1),(j1 - jMin + 1)) = exp(patchDiff*(-1));
            end;
        end;
        % p pixel is at location i,j
        
        gsSpacial = exp((spacialDiff*(-0.5))/(sigmaSpacial*sigmaSpacial)); %Cg matrix
        % expPatchDiff is Cs matrix
        t = gsSpacial.*expPatchDiff;
        num(i,j) = sum(sum(window.*t));
        den(i,j) = sum(sum(t));
    end;
end;
filtered = num./den;
rmsd = sqrt((1/(in_rows*in_cols))*(sum(sum((original-filtered)*(original-filtered)))));
disp(rmsd);

figure(1);
subplot(1,3,1);
imagesc ((original)); % phantom is a popular test image
colormap('Gray');
title('Original');
daspect ([1 1 1]);
axis tight;
subplot(1,3,2);
imagesc ((corrupted)); % phantom is a popular test image
colormap('Gray');
title('Corrupted');
daspect ([1 1 1]);
axis tight;
subplot(1,3,3);
imagesc ((filtered)); % phantom is a popular test image
colormap('Gray');
title('Filtered');
daspect ([1 1 1]);
axis tight;
set(gcf,'Position',get(0,'ScreenSize'));%maximize figure

figure(2);
imagesc ((den)); % phantom is a popular test image
colormap('Gray');
title('Spacial Mask');
daspect ([1 1 1]);
axis tight;

imwrite(corrupted,'images\barbaraCorrupted.png');
imwrite(filtered,'images\barbaraPatchBasedFiltered.png');
end

