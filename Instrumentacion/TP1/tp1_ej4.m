% Se calibra el sensor con una regresión lineal
format long

X=0:10:100
Y=[0.005 0.098 0.224 0.300 0.405 0.520 0.602 0.715 0.799 0.902 0.999]

N=length(X)

% Regresión lineal
a_numerator=0;
for i=1:N
  a_numerator=a_numerator+N*X(i)*Y(i);
end
a_numerator=a_numerator-sum(X)*sum(Y);

a_denominator=0;
for i=1:N
  a_denominator=a_denominator+X(i)*X(i);
end
a_denominator=N*a_denominator-(sum(X))^2;

a = a_numerator / a_denominator

b = (sum(Y) - a * sum(X)) / N

T=[0:1e-3:max(X)];
y=a*T+b;

% Errores relativos
disp("\n\nDATO | APROX | ERROR RELATIVO [%] | ERROR ABSOLUTO");
err_real=zeros(1, N);
for i=1:N
  yi = a*X(i)+b;
  err_real(i) = abs((Y(i) - yi) * 100 / Y(i));
  err_abs(i) = abs(Y(i) - yi);
  fprintf("(%d, %d) | (%d, %d) | %d | %d \n", X(i), Y(i), X(i), yi, err_real(i), err_abs(i));
end

h = figure();
hold on; grid on;
title("Regresion Lineal");
plot(X, Y, 'k+', 'LineWidth', 5);
plot(T, y, 'b', 'LineWidth', 3); 
plot(X, err_abs, '--r', 'LineWidth', 3); 
legend('Datos', 'Regresión', 'Error absoluto');
% waitfor(h);

h2 = figure();
hold on; grid on;
title("Error relativo");
plot(X, err_real, 'r', 'LineWidth', 3); 
ylim([0 100])
waitfor(h2);

% Fondo de escala
RANGO=max(Y)-min(Y)
FS=max(RANGO)
ERROR_FS=err_abs * 100 / FS
PRECISION=max(ERROR_FS)
