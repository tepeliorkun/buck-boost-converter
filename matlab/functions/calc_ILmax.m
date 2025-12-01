function IL_max = calc_ILmax(Vout, Iout, Vin_min,eff)
IL_max = (Vout.*Iout)./(eff.*Vin_min);
end