function d=get_direction(ip,img)

gauss25 = [0.0235069396927 0.0184912136907 0.0123950312124 0.0070801541752 0.0034462810173 0.0014294584748 0.0005052487906;
           0.0216996402838 0.0170695416224 0.0114420559261 0.0065358060540 0.0031813183413 0.0013195564846 0.0004664034175;
           0.0170695416224 0.0134273770158 0.0090006399793 0.0051412471366 0.0025025136422 0.0010379998950 0.0003668859227;
           0.0114420559261 0.0090006399793 0.0060333094053 0.0034462810173 0.0016774850598 0.0006957921374 0.0002459309886;
           0.0065358060540 0.0051412471366 0.0034462810173 0.0019685469536 0.0009581946706 0.0003974427754 0.0001404780098;
           0.0031813183413 0.0025025136422 0.0016774850598 0.0009581946706 0.0004664034175 0.0001934561675 0.0000683779881;
           0.0013195564846 0.0010379998950 0.0006957921374 0.0003974427754 0.0001934561675 0.0000802423124 0.0000283620210];
gauss25=gauss25(:);

% Get rounded InterestPoint data
X = round(ip.x);
Y = round(ip.y);
S = round(ip.scale);

% calculate haar responses for points within radius of 6*scale
[j,i]=ndgrid(-6:6,-6:6);
j=j(:); i=i(:); check=(i.^2 + j.^2 < 36); j=j(check); i=i(check);

% Get gaussian filter (by mirroring gauss25)
id = [ 6, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 6 ];
gauss = gauss25(id(i + 6 + 1) + id(j + 6 + 1) *7+1);

resX = gauss .* haarx(Y + j * S, X + i * S, 4 * S, img);
resY = gauss .* haary(Y + j * S, X + i * S, 4 * S, img);
Ang =  mod(atan2(resY, resX),2*pi);

% loop slides pi/3 window around feature point
ang1 = 0:0.15:(2 * pi);
ang2 = mod(ang1+pi/3,2*pi);

cx=length(Ang); cy=length(ang1);
ang1=repmat(ang1,[cx 1]);
ang2=repmat(ang2,[cx 1]);
Ang =repmat(Ang,[1 cy]);
resX =repmat(resX,[1 cy]);
resY =repmat(resY,[1 cy]);

% determine whether the point is within the window
check1= (ang1 < ang2) & (ang1 < Ang) & (Ang < ang2);
check2= (ang2 < ang1) & ( ((Ang > 0) & (Ang < ang2)) | ((Ang > ang1) & (Ang < pi)) );
check=check1|check2;

sumX =  sum(resX.*check,1);
sumY =  sum(resY.*check,1);

% Find the most dominant direction
R=sumX.^2+ sumY.^2;
[t,ind]=max(R);
d =  mod(atan2(sumY(ind), sumX(ind)),2*pi);