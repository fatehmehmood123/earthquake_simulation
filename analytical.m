m = 3000;
k = 60000;
c = 80;
omega_n = sqrt(k/m);
zeta = c/(2*sqrt(m*k));
omega_d = omega_n*sqrt(1-zeta^2);
f = 1.5;
omega = 2*pi*f;
t = 0:0.01:20;
a_0 = 0.2;
Y = a_0/sqrt((((omega_n^2)-(omega^2))^2)+((2*zeta*omega*omega_n)^2));
phi = atan((2*zeta*omega*omega_n)/((omega_n^2)-(omega^2)));
y_p = Y*sin(omega.*t - phi);
A = Y*sin(phi);
B = (Y/omega_d)*(omega*cos(phi)-omega_n*sin(phi));
y_h = exp(-zeta*omega_n.*t).*(A*cos(omega_d.*t)+B*sin(omega_d.*t));
y = y_h+y_p;


plot(t,y,"g");
xlabel("Time (s)");
ylabel("Displacement (m)");
title("Response from Analytic Solution")
grid on;

