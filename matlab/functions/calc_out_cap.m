function Icout_rms = calc_out_cap(Iout, Vout, Vin)
idx = Vin<Vout;
Icout_rms = zeros(size(Vin));
Icout_rms(idx) = Iout .*sqrt((Vout./Vin(idx))-1);
end