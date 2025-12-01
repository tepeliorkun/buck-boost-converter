function D = calc_duty_cycle(Vin,Vout,eta)

D = zeros(size(Vin));

boost_indices = (Vin<Vout);
D(boost_indices)= 1- (Vin(boost_indices).* eta(boost_indices)/Vout);

buck_indices = (Vin>= Vout);
D(buck_indices) = Vout./(Vin(buck_indices).*eta(buck_indices));

end