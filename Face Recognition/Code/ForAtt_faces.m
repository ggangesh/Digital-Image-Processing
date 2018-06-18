function ForAtt_faces(n1, n2, n3, row, col)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    k=[1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
    x = zeros((row*col), (n1*n2));
    for i = 1:n1
        for j = 1:n2
            img1 = imread(['..\..\..\att_faces', '\s', num2str(i), '\', num2str(j), '.pgm']);
            for i1 = 1:row
                for j1 = 1:col
                    x((((i1-1)*col)+j1), (((i-1)*n2)+j)) = img1(i1, j1);
                end;
            end;
        end;
    end;
    x_bar = mean(x, 2);
    X = x - diag(x_bar)*ones(size(x));
    L = (X')*X;
    [W, E] = eig(L);
    V =X*W;
    V = normc(V);
    sizeofk = size(k, 2);
    RegRateWhole = zeros((n1*n3), sizeofk);
    for i = 1:sizeofk
        RegRateWhole(:, i) = FindEigenFaces(k(i), row, col, V, n1, n2, n3, x_bar, X);
    end;
end

