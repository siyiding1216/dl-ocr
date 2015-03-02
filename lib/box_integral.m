function an = box_integral(x, y, xs, ys, img)

% coordinates to integer
x=fix(x); y=fix(y); xs=fix(xs);ys=fix(ys);

% corner coordinates
r1 = min(x, size(img,1)); c1 = min(y, size(img,2));
r2 = min(x + xs, size(img,1)); c2 = min(y + ys, size(img,2));

% values at the corners
sx=size(img,1);
A = img(max(r1+(c1-1)*sx,1)); B = img(max(r1+(c2-1)*sx,1));
C = img(max(r2+(c1-1)*sx,1)); D = img(max(r2+(c2-1)*sx,1));

% safty check
A((r1<1)|(c1<1))=0; B((r1<1)|(c2<1))=0;
C((r2<1)|(c1<1))=0; D((r2<1)|(c2<1))=0;

an=max(0, A - B - C + D);

end

