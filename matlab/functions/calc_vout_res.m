function [Rfb2,ratio] = calc_vout_res(Vout, Rfb1)
Vref = 0.8;
ratio = (Vout-Vref) ./ Vref;
Rfb2 = ratio .*Rfb1;
end