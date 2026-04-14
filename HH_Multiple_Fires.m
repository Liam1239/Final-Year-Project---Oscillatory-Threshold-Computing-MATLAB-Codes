I = @(t) 5*heaviside(t-50) - 5*heaviside(t-120) + 6.5*heaviside(t-140) - 6.5*heaviside(t-210) + 10*heaviside(t-230) - 10*heaviside(t-300) ...
    + 15*heaviside(t-320) - 15*heaviside(t-390) + 20*heaviside(t-410) - 20*heaviside(t-480) ...
    + 25*heaviside(t-500) - 25*heaviside(t-570); % Setting up a function I, so we can vary the level of input current applied to the system throughout the simulation. 


Gna = 120; %Conductance of the sodium channel 
Gk = 36; %Conductance of the potassium Channel
Gl = 0.3; %Conductance of the leakage Channel

Vna = 50; % Sodium channel Equilibrium Voltage
Vk = -77; % Potassium channel Equilibrium Voltage
Vl = -54.402; % Leakage channel Equilibrium Voltage

C = 1; % Membrane capacitance (which is a constant - physical properties of the membrane which allow it to store charge). 

y = zeros(1,4); % These values will represent the functions for the probabilities of gates being open / closed. 
% y(1) = const (doesnt change, for the leaking gate).
% y(2) = m
% y(3) = h
% y(4) = n



% ============================================================================================================================
% ============================================================================================================================

% DEFINE THE HH System Of Differential Equations. 

Hodgkin_Huxley_System = @(t,y) [(I(t) - Gna * y(2)^3 * y(3) * (y(1) - Vna) - Gk * y(4)^ 4 * (y(1) - Vk) - Gl *( y(1) - Vl)) / C; % dV/dt Equation

                              0.1 * (y(1) + 40) / (1 - exp(-0.1 * (y(1) + 40))) * (1 - y(2)) - 4 * exp(-0.0556 * (y(1) + 65)) * y(2); % dm/dt Equation

                              0.07 * exp(-0.05 * (y(1) + 65)) * (1 - y(3)) - 1 / (1 + exp(-0.1 * (y(1) + 35))) * y(3); % dh/dt Equation

                              0.01 * (y(1) + 55)/(1 - exp(-0.1 * (y(1) + 55))) * (1 - y(4))- 0.125 * exp(-0.0125 * (y(1) + 65)) * y(4)]; % dn/dt Equation


% ============================================================================================================================
% ============================================================================================================================


[t,ya]=ode45(Hodgkin_Huxley_System,[0 600],[15,0.01,0.5,0.4]); % Solve the HH System over 0 - 600, when the initial values for each of the variables is 15 (V), 0.01 (m), 0.5 (h), 0.4 (n), and store the timestamps in t and the corresponding results in ya. 
% t should just be a 1D array of values and ya should be 4D (Since the system is also 4D). 
 
% Displaying the results graphically. 
figure(Name = 'Multiple Hodgkin-Huxley Neuron Fires'); % Naming the Figure.
set(gca,'FontSize',15);
k = tiledlayout(5,1); % We need 10 tiles for the figure
k.Padding = 'compact';
k.TileSpacing = 'compact';

nexttile(1, [1 1]); 
plot(t,ya(:,1), 'green'); % This is plotting the Voltage
title('Membrane Potential (mV) vs Time (ms)', FontSize=15, Interpreter='latex');
axis([0 600 -80 40]); % Axis should be 0 - 600 (time) on x & -80 - 40 (voltage) in the y. 
set(gca,'XTick',0:50:600); % Again just setting plot up
set(gca,'YTick',-80:40:40); % Again just setting plot up
xlabel('Time (ms)', FontSize=15, Interpreter='latex'); % Naming axis
ylabel('$V$ (mV)', FontSize=15, Interpreter='latex'); % Naming axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.


nexttile(2, [1 1]);
plot(t,ya(:,2),'blue'); % Plotting m(V)
title('Potassium Activating Gate ($m(V)$) vs Time (ms)', FontSize=15, Interpreter='latex')
set(gca,'XTick',0:50:600); % Just Plotting for time.
set(gca,'YTick',0:1); % Obviously is a number between 0 - 1. (probability that a gate is open in the channel)
xlabel('Time (ms)', FontSize=15, Interpreter='latex'); % Naming axis
ylabel('$m(V)$', FontSize=15, Interpreter='latex'); % Naming axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.


nexttile(3, [1 1]);
plot(t,ya(:,3),'red');  % Plotting h(V)
title('Potassium Inactivating Gate ($h(V)$) vs Time (ms)', FontSize=15, Interpreter='latex');
axis([0 600 0 1]); % x-axis: 0-600, y-axis: 0-1
set(gca,'XTick',0:50:600); % Just Plotting for time.
set(gca,'YTick',0:1); % Obviously is a number between 0 - 1. (probability that a gate is open in the channel)
xlabel('Time (ms)', FontSize=15, Interpreter='latex'); % Naming axis
ylabel('$h(V)$', FontSize=15, Interpreter='latex'); % Naming axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.


nexttile(4, [1 1]);
plot(t,ya(:,4),'color','cyan'); % Plotting n(V)
title('Sodium Gating Channel ($n(V)$) vs Time (ms)', FontSize=15, Interpreter='latex');
axis([0 600 0 1]); % x-axis: 0-600, y-axis: 0-1
set(gca,'XTick',0:50:600); % Just Plotting for time.
set(gca,'YTick',0:1); % Obviously is a number between 0 - 1. (probability that a gate is open in the channel)
xlabel('Time (ms)', FontSize=15, Interpreter='latex'); % Naming axis
ylabel('$n(V)$', FontSize=15, Interpreter='latex'); % Naming axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.


nexttile(5, [1 1]);
plot(t,I(t),'color','magenta'); % Plotting input current
title('Input Current (mA) vs Time (ms)', FontSize=15, Interpreter='latex');
axis([0 600 0 30]); % x-axis: 0-600, y-axis: 0-30
set(gca,'XTick',0:50:600); % Just Plotting for time.
set(gca,'YTick',0:10:30); % Just plotting Milliamp input. (extra current input to make spikes). 
xlabel('Time (ms)', FontSize=15, Interpreter='latex'); % Naming axis
ylabel('$I$ (mA)', FontSize=15, Interpreter='latex'); % Naming axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

sgt = sgtitle('\textbf{Hodgkin-Huxley Model - Impact on Oscillatory Frequency as the Applied Input Current Rises}', fontsize = 18, Interpreter = 'latex'); % Title of the graph.