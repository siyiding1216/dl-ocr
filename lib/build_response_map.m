function response_map=build_response_map(I)

% Parameters to compute response at initial scale 1.
w = size(I,2)/2;
h = size(I,1)/2;
s = 2;

% filter values for all scale up to 5
filter_map = {[9,15,21,27], [39,51], [75,99], [147,195], [291,387]};

% compute response at all locations and all scales
max_scale = 5;
i = 1;
for scale = 1:max_scale
    for j = 1:length(filter_map{scale})
        br = base_response(...
            w/2^(scale-1), h/2^(scale-1), s*2^(scale-1), filter_map{scale}(j));
        response_map{i}=extend_response(br,I);
        i = i+1;
    end
end

% Fill basic info about a response entry.
function response = base_response(width, height, step, filter)
response.width = floor(width);
response.height = floor(height);
response.step = floor(step);
response.filter = floor(filter);

% Extend the response with determinant
function response = extend_response(response, img)
step = fix(response.step);
b = fix((response.filter - 1) / 2 + 1);
l = fix(response.filter / 3);
w = fix(response.filter);

% normalisation factor
inverse_area = 1 / double(w * w);

[ac,ar]=ndgrid(0:response.width-1,0:response.height-1);
ar=ar(:); ac=ac(:);

% get the image coordinates
r = int32(ar * step);
c = int32(ac * step);

% compute response components
Dxx =   box_integral(r - l + 1, c - b, 2 * l - 1, w,img) - box_integral(r - l + 1, c - fix(l / 2), 2 * l - 1, l, img) * 3;
Dyy =   box_integral(r - b, c - l + 1, w, 2 * l - 1,img) - box_integral(r - fix(l / 2), c - l + 1, l, 2 * l - 1,img) * 3;
Dxy = + box_integral(r - l, c + 1, l, l,img) + box_integral(r + 1, c - l, l, l,img) ...
      - box_integral(r - l, c - l, l, l,img) - box_integral(r + 1, c + 1, l, l,img);

% normalise the filter responses
Dxx = Dxx*inverse_area;
Dyy = Dyy*inverse_area;
Dxy = Dxy*inverse_area;

% determinant of hessian response
response.responses = (Dxx .* Dyy - 0.81 * Dxy .* Dxy);
