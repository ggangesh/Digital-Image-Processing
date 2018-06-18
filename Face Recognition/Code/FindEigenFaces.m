
function RegRate = FindEigenFaces(k, row, col, V, n1, n2, n3, x_bar, X)
    TopK = V(:, (((n1*n2)+1)-k):(n1*n2));
    eigenfaces = zeros(k, row, col);
    %h = figure(1);
    %colormap('gray');
    for i = 1:k
        for i1= 1:row
            for j1 = 1:col
                eigenfaces(i,i1,j1) = TopK((((i1-1)*col)+j1), i);
                %eigenface(i1, j1) = TopK((((i1-1)*col)+j1), i);
            end;
        end;
        %eigenface;
        %eigenface1 = mat2gray(eigenface);
        %z = floor(sqrt(k));
        %subplot(z, ceil(k/z), i);
        %imagesc(eigenface);
    end;
    %savefig(h, ['eigenfaces\fig', num2str(k), '.fig']);
    %close(h);
    
    % size of alphaP is [k (32*6)]
    alphaI = (TopK')*X;
    
    %read probe images
    xp = zeros((row*col), (n1*n3));
    % size of x is [(112*92) (32*4)]
    for i = 1:n1
            for j = (n2+1):(n2+n3)
                img1 = imread(['..\..\..\att_faces', '\s', num2str(i), '\', num2str(j), '.pgm']);
                for i1 = 1:row
                    for j1 = 1:col
                        xp((((i1-1)*col)+j1), (((i-1)*n3)+(j-n2))) = img1(i1, j1);
                    end;
                end;
            end;
    end;
    Xp = xp - diag(x_bar)*ones(size(xp));
    % size of alphaP is [k (35*4)]
    alphaP = (TopK')*Xp; 
    % For different images
    
    RegRate = realmax('single')*ones(n1*n3, 1);
    RegIndex = zeros(n1*n3, 1);
    %{
    %%%%%%%%%testing
    p = 92;
    %%%%%%%%%
    %}
    for i = 1:(n1*n3)
        for j = 1:(n1*n2)
            z = sum( (alphaP(:,i) - alphaI(:,j)).^2 );
            if(z<RegRate(i))
                RegRate(i) = z;
                RegIndex(i) = j;
            end;
        end;
    end;
    %{
    %%%%%%%%%%%%%TEsting
    
    original = zeros(row, col);
    recognised = zeros(row, col);
    for i1 = 1:row
                    for j1 = 1:col
                        original(i1, j1) = xp((((i1-1)*col)+j1), p);
                    end;
    end;
    for i1 = 1:row
                    for j1 = 1:col
                        recognised(i1, j1) = X((((i1-1)*col)+j1), RegIndex(p))+ x_bar((((i1-1)*col)+j1));
                    end;
    end;
    h = figure(1);
    colormap('gray');
    subplot(1, 2, 1);
    imagesc(original);
    subplot(1, 2, 2);
    imagesc(recognised);
    
    for i = 1:(n1*n3)
        disp([num2str(i), ' - ', num2str(RegRate(i)), ' * ', num2str(RegIndex(i)*(2/3))]);
    end;
    
    %%%%%%%%%%%%%%%%%%%
    %}
end
