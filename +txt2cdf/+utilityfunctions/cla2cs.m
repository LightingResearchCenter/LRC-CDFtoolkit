function cs = cla2cs(cla)
% cla2cs will calculate the cs variable from CLA.
cs = .7 * (1 - (1 ./ (1 + (cla / 355.7) .^ (1.1026))));
end