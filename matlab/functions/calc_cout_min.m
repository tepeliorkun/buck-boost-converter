function Cmin = calc_cout_min(Iout, Vout, Vin_min,fsw,Vripple_pp)
Dboost = 1 - Vin_min / Vout;
Cmin = (Iout * Dboost) / (Vripple_pp * fsw);
end