function[L_buck, L_boost, L] = calc_L(Vin_min, Vin_max, Vout, Iout, fsw)
L_buck = ((Vin_max-Vout).*Vout)./(0.4.*Iout.*fsw.*Vin_max);
L_boost = (Vin_min.^2 .* (Vout - Vin_min)) ./ (0.3 .* Iout .* fsw .* (Vout.^2));
L = max(L_buck, L_boost);
end