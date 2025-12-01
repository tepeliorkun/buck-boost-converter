function Icin_rms = calc_cin_cap(Iout, D)
    Icin_rms = Iout .* sqrt(D .* (1 - D));
end
