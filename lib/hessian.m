function re = hessian(a, x, y, b)
if(nargin<4)
    scale=1;
else
    scale=fix(a.width/b.width);
end
re=a.responses(fix(scale*x) * a.width + fix(scale*y)+1);