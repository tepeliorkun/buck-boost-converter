function Cin = calc_min_in_cap(D,Iout,Vin_pp,fsw)
  Cin = (D .* (1 - D) .* Iout) ./ (Vin_pp * fsw);
end