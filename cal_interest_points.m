function ipts=cal_interest_points(I, max_scales, thresh)

filter_map = [0,1,2,3;
    1,3,4,5;
    3,5,6,7;
    5,7,8,9;
    7,9,10,11]+1;

np=0; ipts=struct;

% Build the response map
response_map=build_response_map(I);

% Find the maxima acrros scale and space
for s = 1:max_scales
    for i = 1:2
        b = response_map{filter_map(s,i)};
        m = response_map{filter_map(s,i+1)};
        t = response_map{filter_map(s,i+2)};

        % loop over middle response layer at density of the most
        % sparse layer (always top), to find maxima across scale and space
        [c,r]=ndgrid(0:t.width-1,0:t.height-1);
        r=r(:); c=c(:);

        p=find(extreme(r, c, t, m, b, thresh));
        for j=1:length(p);
            ind=p(j);
            [ipts,np]=interpolate_extremum(r(ind), c(ind), t, m, b, ipts,np);
        end
    end
end
