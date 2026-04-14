a=0.1; %Threshold
b=0.1; %Stoping the blocking from growing too much
c=0.1; %Growth Rate

% In this example, we use three different input currents to demonstrate the variation in oscillatory strength / amplitude that you get when adding different input currents. 
Input_current_1 = 1; % Input Current of 1, for the first System (should have high oscillatory strength / amplitude). 
Input_current_2 = 0.7; % Input Current of 0.7, for the second System (should have a relatively high oscillatory strength / amplitude).
Input_current_3 = 0.4; % Input Current of 0.4, for the third System (should have low oscillatory strength / amplitude).

Tmax=250; % The time over which the system will be solved.

options=odeset('RelTol',1e-8,'AbsTol',1e-10);

sys1= @(t1,x1) [x1(1) * (x1(1)-a) * (1-x1(1)) - x1(2) + Input_current_1; c*(x1(1)-b*x1(2))]; % Introduction of the first system, involving an input current of 1. 
[t1,xs1]=ode45(sys1,[0 Tmax],[0.5 1.474],options); % Solving the first system - No additional functions are required to produce the functions being solved since there is no oscillator couplings. 

sys2=@(t2,x2) [x2(1) * (x2(1)-a) * (1-x2(1)) - x2(2) + Input_current_2; c*(x2(1)-b*x2(2))]; % Introduction of the second system, involving an input current of 0.7. 
[t2,xs2]=ode45(sys2,[0 Tmax],[0.5 1.474],options); % Solving the second system - No additional functions are required to produce the functions being solved since there is no oscillator couplings.

sys3=@(t3,x3) [x3(1) * (x3(1)-a) * (1-x3(1)) - x3(2) + Input_current_3; c*(x3(1)-b*x3(2))]; % Introduction of the third system, involving an input current of 0.4. 
[t3,xs3]=ode45(sys3,[0 Tmax],[0.5 1.474],options); % Solving the third system - No additional functions are required to produce the functions being solved since there is no oscillator couplings.

% Displaying the results graphically. 
figure(name = 'FitzHugh-Nagumo Threshold Oscillators');
t = tiledlayout('flow');
t.Padding = 'compact';
t.TileSpacing = 'compact';

nexttile(1,[2 2]); % This tile will simply display the phase portrait of each of the three systems. 
plot(xs1(:,1), xs1(:,2), Color = 'blue', LineWidth = 1.5); % Plotting v(t) vs w(t) for the first system.
hold on;
plot(xs2(:,1), xs2(:,2), Color = 'red', LineWidth = 1.5); % Plotting v(t) vs w(t) for the second system.
hold on;
plot(xs3(:,1), xs3(:,2), Color = 'magenta', LineWidth = 1.5); % Plotting v(t) vs w(t) for the third system.
xlabel('$v(t)$', FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$w(t)$',FontSize=15, Interpreter='latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.
title('Phase Portraits of the FitzHugh-Nagumo Models', FontSize = 16, Interpreter='latex'); %  Giving a title to the graph.
legend('Input Current = 1', 'Input Current = 0.7','Input Current = 0.4', fontsize = 12, Interpreter='latex'); % Giving a legend to the graph.

nexttile(2,[1 2]); % This tile will display the time series of the fast variable for each of the three systems. 
plot(t1,xs1(:,1), Color = 'blue', LineWidth = 1.5); % Plotting the time series of the fast variable of the first system. 
hold on; 
plot(t2, xs2(:,1), Color = 'red', LineWidth = 1.5);  % Plotting the time series of the fast variable of the second system.  
hold on; 
plot(t3, xs3(:,1), Color = 'magenta', LineWidth = 1.5);  % Plotting the time series of the fast variable of the second system.  
xlabel('$t$', FontSize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$v(t)$', FontSize = 15, Interpreter='latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.
title('Time Series of the FitzHugh-Nagumo Fast Variable / Membrane Potential, $v(t)$', FontSize=16, Interpreter='latex');
legend('Input Current = 1', 'Input Current = 0.7','Input Current = 0.4', fontsize = 12, Interpreter='latex');

nexttile(3,[1 2]); % This tile will display the time series of the slow variable for each of the three systems. 
plot(t1,xs1(:,2), Color = 'blue', LineWidth = 1.5);  % Plotting the time series of the slow variable of the first system. 
hold on; 
plot(t2, xs2(:,2), Color = 'red', LineWidth = 1.5);  % Plotting the time series of the slow variable of the second system. 
hold on; 
plot(t3, xs3(:,2), Color = 'magenta',  LineWidth = 1.5);  % Plotting the time series of the slow variable of the third system. 
xlabel('$t$', FontSize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$w(t)$', FontSize = 15, Interpreter='latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.
title('Time Series of the FitzHugh-Nagumo Slow Variable / Blocking Mechanism, $w(t)$', FontSize=16, Interpreter='latex'); % Giving a title to the plot. 
legend('Input Current = 1', 'Input Current = 0.7','Input Current = 0.4', fontsize = 12, Interpreter='latex'); %  Giving a legend to the graph. 

sgt = sgtitle('\textbf{Plots of FitzHugh-Nagumo Threshold Oscillators}', fontsize = 18, Interpreter = 'latex'); % Giving a title to the figure.