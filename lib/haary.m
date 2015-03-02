function re = haary(x, y, size, img)
re = box_integral(x, y - size / 2, size / 2, size , img)...
    - box_integral(x - size / 2, y - size / 2, size / 2, size , img);
end