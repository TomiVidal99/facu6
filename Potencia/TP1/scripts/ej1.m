R=10;
L=20e-3;
f0=50;
w=2*pi*f0;
T=[0:1e-4:6/50];
Vip=sqrt(2)*220;

Vin = Vip*sin(w*T);

Z=sqrt(R^2+(w*L)^2);
phi=acos(R/Z);

I_libre = @(t) -(Vip*sin(phi)/Z)*exp(-R*t/L);
I_permanente = @(t) (Vip/Z)*sin(w*t - phi);

I = I_libre(T) + I_permanente(T);

% for i=1:length(Vin)
%
% end

I_002 = I_libre(0.01) + I_permanente(0.01)

Vl1= Vin - R*I;
Vl2= (Vip/Z)*sin(phi)*R*exp(-R*T/L) + (Vip*w*L/Z)*cos(w*T-phi);

figure();
hold on; grid on;

plot(T, (Vip/Z)*sin(w*T-32*pi/180), 'r', 'LineWidth', 3);
plot(T, (Vip/Z)*sin(pi/5)*exp(-R*T/L), 'b', 'LineWidth', 3);

% plot(T, Vin, 'r', 'LineWidth', 3);
% plot(T, I, 'b', 'LineWidth', 3);
% plot(T, Vl1, 'k', 'LineWidth', 3);
% plot(T, Vl2, 'm', 'LineWidth', 3);

legend('Vin', 'I', 'Vin-RI', 'VL');
