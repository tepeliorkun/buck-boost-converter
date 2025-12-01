function Css = calc_soft_start(Tss, Vref, Iss);
Css = (Tss.*Iss)./Vref;
end