function [Pout, Pin,Iin] = calc_source_efficiency(Vin, Vout, Iout, eta)
    Pout = Vout.* Iout;
    Pin = Pout./ eta;
    Iin = Pin ./ Vin;
end