function IL_peak = calc_ILpeak(IL_max, Vin_min, Vout, L, fsw)
IL_peak = IL_max+ (Vin_min.*(Vout-Vin_min))./(2 .* L .* fsw .* Vout);
end