function D=derivative(r,c,t,m,b)

dx = (hessian(m,r, c + 1, t) - hessian(m,r, c - 1, t)) / 2;
dy = (hessian(m,r + 1, c, t) - hessian(m,r - 1, c, t)) / 2;
ds = (hessian(t,r, c) - hessian(b,r, c, t)) / 2;

D = [dx;dy;ds];
