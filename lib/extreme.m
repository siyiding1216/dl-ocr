function an = extreme(r, c,  t,  m,  b, thresh)

% bounds check
layerBorder = fix((t.filter + 1) / (2 * t.step));
bound_check_fail=(r <= layerBorder | r >= t.height - layerBorder | c <= layerBorder | c >= t.width - layerBorder);

% check the candidate point in the middle layer is above thresh
candidate = hessian(m,r,c,t);
treshold_fail=candidate < thresh;

an=(~bound_check_fail)&(~treshold_fail);
for rr = -1:1
    for  cc = -1:1
          %  if any response in 3x3x3 is greater then the candidate is not a maximum
          check1=hessian(t,r + rr, c + cc, t) >= candidate;
          check2=hessian(m,r + rr, c + cc, t) >= candidate;
          check3=hessian(b,r + rr, c + cc, t) >= candidate;
          check4=(rr ~= 0 || cc ~= 0);
          an3 = ~(check1 | (check4 & check2) | check3);
          an=an&an3;
    end
end

function an=hessian(a,row, column,b)
scale=fix(a.width/b.width);
index=fix(scale*row) * a.width + fix(scale*column)+1;
index(index<1)=1; index(index>length(a.responses))=length(a.responses);
an=a.responses(index);
