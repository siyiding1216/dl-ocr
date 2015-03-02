function re = haarx(x, y, size, img)
re = box_integral(x - size / 2, y, size, size / 2, img)...
    - box_integral(x - size / 2, y - size / 2, size, size / 2, img);
end