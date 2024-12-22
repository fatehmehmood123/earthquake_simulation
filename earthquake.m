% Parameters
m = 4000; % Mass (kg)
k = 60000; % Stiffness (N/m)
c = 100; % Damping coefficient (Ns/m)
time = 0:0.01:20; % Time vector (s)

% Earthquake Acceleration (simulated or real data)
% Use a pre-recorded earthquake data or simulate
earthquake_acc = 0.2 * sin(2 * pi * 1.5 * time); % m/s^2

% Initial conditions
x0 = 0; % Initial displacement (m)
v0 = 0; % Initial velocity (m/s)

% Define the state-space representation
A = [0 1; -k/m -c/m];
B = [0; 1];
C = [1 0];
D = 0;

% Solve using ode45
ode_fun = @(t, y) [y(2); (-c*y(2) - k*y(1) + m*interp1(time, earthquake_acc, t, 'linear', 0))/m];
[t, y] = ode45(ode_fun, time, [x0 v0]);

%
omega_n = sqrt(k/m);
zeta = c/(2*sqrt(m*k));
omega_d = omega_n*sqrt(1-zeta^2);
f = 1.5;
omega = 2*pi*f;
%t = 0:0.01:20;
a_0 = 0.2;
Y = a_0/sqrt((((omega_n^2)-(omega^2))^2)+((2*zeta*omega*omega_n)^2));
phi = atan((2*zeta*omega*omega_n)/((omega_n^2)-(omega^2)));
y_p = Y*sin(omega.*t - phi);
A = Y*sin(phi);
B = (Y/omega_d)*(omega*cos(phi)-omega_n*sin(phi));
y_h = exp(-zeta*omega_n.*t).*(A*cos(omega_d.*t)+B*sin(omega_d.*t));
y_a = y_h+y_p;
%


% Plot results
figure;
%subplot(2,1,1);
plot(t, y(:,1),"b");
hold on;
plot(t,y_a,"r")
xlabel('Time (s)');
ylabel('Displacement (m)');
title('Displacement of Single-Story Building');
hold off;
legend("State Space", "From Hand Calculations")

% subplot(2,1,2);
% plot(time, earthquake_acc);
% xlabel('Time (s)');
% ylabel('Acceleration (m/s^2)');
% title('Earthquake Acceleration');



