function cs = cla2cs(cla)
cs = .7 * (1 - (1 ./ (1 + (cla / 355.7) .^ (1.1026))));
end