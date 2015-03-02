function [ipts, np]=interpolate_extremum(r, c,  t,  m,  b,  ipts, np)
D = derivative(r, c, t, m, b);
H = build_hessian(r, c, t, m, b);

%get the offsets from the interpolation
Of = - H\D;
O=[ Of(1, 1), Of(2, 1), Of(3, 1) ];

%get the step distance between filters
filterStep = fix((m.filter - b.filter));

%If point is sufficiently close to the actual extremum
if (abs(O(1)) < 0.5 && abs(O(2)) < 0.5 && abs(O(3)) < 0.5)
    np=np+1;
    ipts(np).x = double(((c + O(1))) * t.step);
    ipts(np).y = double(((r + O(2))) * t.step);
    ipts(np).scale = double(((2/15) * (m.filter + O(3) * filterStep)));
end

function H=build_hessian(r, c, t, m, b)
v = hessian(m, r, c, t);
dxx = hessian(m,r, c + 1, t) + hessian(m,r, c - 1, t) - 2 * v;
dyy = hessian(m,r + 1, c, t) + hessian(m,r - 1, c, t) - 2 * v;
dss = hessian(t,r, c) + hessian(b,r, c, t) - 2 * v;
dxy = (hessian(m,r + 1, c + 1, t) - hessian(m,r + 1, c - 1, t) - hessian(m,r - 1, c + 1, t) + hessian(m,r - 1, c - 1, t)) / 4;
dxs = (hessian(t,r, c + 1) - hessian(t,r, c - 1) - hessian(b,r, c + 1, t) + hessian(b,r, c - 1, t)) / 4;
dys = (hessian(t,r + 1, c) - hessian(t,r - 1, c) - hessian(b,r + 1, c, t) + hessian(b,r - 1, c, t)) / 4;

H = zeros(3,3);
H(1, 1) = dxx;
H(1, 2) = dxy;
H(1, 3) = dxs;
H(2, 1) = dxy;
H(2, 2) = dyy;
H(2, 3) = dys;
H(3, 1) = dxs;
H(3, 2) = dys;
H(3, 3) = dss;
