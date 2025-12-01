
Vin = [9, 16.5, 24];          
Vout = 12;              
Iout = 2;               
eta  = [0.94, 0.962, 0.967];           
Ruv2 = linspace(100e3,300e3,30);
Vin_uv = 8.7;
Ven_op = [1.17, 1.22, 1.29];
Ien_stby = [1e-6, 2e-6, 3e-6];
Delta_Ihys_op = [2.15e-6, 3.15e-6, 4.25e-6];
Tss = linspace(10e-3, 20e-3, 30);
Iss = [3.75e-6, 5e-6, 6.35e-6];
Vref = [0.788, 0.8, 0.812];
Rfb1 = 20e3;
fsw = 284e3;
Vin_min = Vin(1);
Vin_typ = Vin(2);
Vin_max = Vin(end);
Vin_boost = linspace(Vin_min, Vout-0.01,30);
Vripple_pp = 30e-3;
Cripple_single = 5;  % A_RMS
Cripple_total  = 2 * Cripple_single;%datasheetx2

[Pout, Pin, Iin] = calc_source_efficiency(Vin, Vout, Iout, eta);
D = calc_duty_cycle(Vin, Vout,eta);


for i = 1:length(Vin)
    fprintf('Vin = %1.f V | Pin = %.2f W | Iin = %.2f A | Duty = %.2f %%\n', ...
             Vin(i), Pin(i), Iin(i), D(i)*100);
end

Ruv1 = zeros(length(Ruv2), 3);
Vhys = zeros(length(Ruv2),3);
%senaryo = {'Min', 'Tipik', 'Max'}

for k = 1:3
    [Ruv1(:,k),Vhys(:,k)] = calc_uvlo_res(Vin_uv, Ruv2, Ven_op(k), Ien_stby(k), Delta_Ihys_op(k));
end

Css = zeros(length(Tss), 3);
 for k = 1:3
     Css(:,k) = calc_soft_start(Tss, Vref(k), Iss(k));

 end
[Rfb2, ratio] = calc_vout_res(Vout, Rfb1);
[Lbuck, Lboost, L] = calc_L(Vin_min, Vin_max, Vout, Iout, fsw);

Vin_sweep = linspace(Vout, Vin_max, 200);
Delta_IL = ((Vin_sweep - Vout).*Vout) ./ (L * fsw .* Vin_sweep);
IL_max = calc_ILmax(Vout, Iout, Vin_min, eta(1)); 
IL_peak = calc_ILpeak(IL_max, Vin_min, Vout, L, fsw);
Icout_rms = calc_out_cap(Iout, Vout, Vin_boost);
Cmin = calc_cout_min(Iout, Vout, Vin_min, fsw, Vripple_pp);





fprintf('\n--- VOUT Feedback Design ---\n');
fprintf('Rfb1 = %.0f ohm\n', Rfb1);
fprintf('Rfb2 = %.0f ohm\n', Rfb2);
fprintf('Ratio = Rfb2/Rfb1 = %.2f\n', ratio);

fprintf("\n--- Inductor Selection ---\n");
fprintf("Lbuck  = %.2f uH\n", Lbuck*1e6);
fprintf("Lboost = %.2f uH\n", Lboost*1e6);
fprintf("Lfinal = %.2f uH\n", L*1e6);

fprintf("\n--- Inductor Current Limits ---\n");
fprintf("IL_max  = %.2f A\n", IL_max);
fprintf("IL_peak = %.2f A\n", IL_peak);


fprintf("\n--- Output Capacitor RMS Analysis ---\n");
fprintf("Worst-case I_COUT(RMS) at Vin_min = %.2f A\n", Icout_rms(1));
fprintf("2x capacitor limit = %.2f A\n", Cripple_total);
fprintf("Safety margin = %.2fx\n", Cripple_total / Icout_rms(1));

fprintf("\n--- Boost Output Capacitor Minimum C Calculation ---\n");
fprintf("Target Ripple = %.1f mV p-p\n", Vripple_pp*1e3);
fprintf("Required Cmin  = %.2f uF\n", Cmin*1e6);


figure('Name','Buck-Boost + UVLO Analizleri','Color','w');

subplot(2,2,1);
plot(Vin, Iin, 'b-o', 'LineWidth', 1.5);
xlabel('Vin (V)');
ylabel('Iin (A)');
title('Giriş Akımı');
grid on;

subplot(2,2,2);
plot(Vin, D*100, 'r-s', 'LineWidth', 1.5);
xlabel('Vin (V)');
ylabel('Duty (%)');
title('Duty Cycle');
grid on;

subplot(2,2,3);
hold on;
plot(Ruv2/1e3, Ruv1(:,1)/1e3, 'b--');
plot(Ruv2/1e3, Ruv1(:,2)/1e3, 'b-', 'LineWidth',2);
plot(Ruv2/1e3, Ruv1(:,3)/1e3, 'b-.');
hold off;

xlabel('Ruv2 (k\Omega)');
ylabel('Ruv1 (k\Omega)');
title('UVLO Alt Direnç vs Üst Direnç');
legend('Min','Tipik','Max');
grid on;

subplot(2,2,4);
hold on;
plot(Ruv2/1e3, Vhys(:,1), 'r--');
plot(Ruv2/1e3, Vhys(:,2), 'r-', 'LineWidth',2);
plot(Ruv2/1e3, Vhys(:,3), 'r-.');
hold off;

xlabel('Ruv2 (k\Omega)');
ylabel('Histerezis (V)');
title('UVLO Histerezis Analizi');
legend('Min','Tipik','Max');
figure('Name','Soft-Start Analizi','Color','w');

hold on;
plot(Tss*1e3, Css(:,1)*1e6, 'r--', 'LineWidth', 1.5);
plot(Tss*1e3, Css(:,2)*1e6, 'r-',  'LineWidth', 2);
plot(Tss*1e3, Css(:,3)*1e6, 'r-.', 'LineWidth', 1.5);
hold off;

xlabel('Soft-Start Süresi T_{ss} (ms)');
ylabel('C_{SS} (µF)');
title('Soft-Start Kapasitör Değeri vs Tss (Min / Typ / Max)');
legend('Min Senaryo','Tipik','Max','Location','best');
grid on;

figure('Name','Bobin Ripple Akımı Analizi vs Giriş Gerilimi ','Color','w');
plot(Vin_sweep, Delta_IL, 'LineWidth', 2);
xlabel('Vin (V)');
ylabel('\Delta I_L (A)');
title('Inductor Current Ripple vs Input Voltage');
grid on;

figure('Name','Output Caps RMS Current', 'Color','w');
plot(Vin_boost, Icout_rms, 'b', 'LineWidth', 2); hold on;

yline(Cripple_single, '--r', 'Single Cap Limit');
yline(Cripple_total, 'r-.', 'Dual Cap Limit');

xlabel('Vin (V)');
ylabel('I_{COUT,RMS} (A)');
title('Output Capacitor RMS Current vs Input Voltage');
grid on;