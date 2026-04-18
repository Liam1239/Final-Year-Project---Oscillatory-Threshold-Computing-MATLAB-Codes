tmax=500;
tspan=[0 tmax]; % Timespan for solving the system. 

e1 = 0.7; % Synaptic weights applied to the outputs of I_1, I_2 & I_3 to O_1. 
e2 = 0.4; % Synaptic weights applied to the outputs of I_1, I_2 & I_3 to O_2. 
i1 = -1.1; % Inhibitory synaptic coupling from O_2 to O_1. 


% In this case, the oscillators have the same threshold.
% Alternatively, one could fix the weights and use different thresholds.

% This is the matrix holding each of the synaptic weights, defined above, to be applied to the outputs to each oscillator. 
% The easiest way to think about it is that the ith row describes the synaptic weights that are being applied to it from I_1 - I_3 and then from O_1 - O_2.
mat = [0 0 0 e1 e2
       0 0 0 e1 e2
       0 0 0 e1 e2
       0 0 0 0 0
       0 0 0 i1 0];

% Additional Input currents applied to each of the oscillators.
% In this version, like the half adder, we show all possible permutations. 
I = [0 0 0 0 0 
    1 0 0 0 0 
    0 1 0 0 0
    0 0 1 0 0
    1 1 0 0 0
    1 0 1 0 0
    0 1 1 0 0
    1 1 1 0 0];

m = -100; % Used in Activation Function.
p = 60; % Used in Activation Function. 
yinit = zeros(size(mat,1)*2,1); % Both fast and slow variables for all oscillators will initially be set to zero. 
a = 0.1; % alpha (in FHN)
b = 0.1; % gamma (in FHN)
c = 0.1;  % epsilon (in FHN)

nodes = size(I,2);
ylong = [];tlong = []; %Where outputs will be stored. 
for loop1=1:size(I,1) % Loops through 4 times - This represents our 4 sets of inputs. (0,0),(0,1),(1,0) & (1,1). 
    [t,y]=ode45(@FN,tspan,yinit,[],[a b c],I(loop1,:)',mat, m,p); 
    % tspan is just simply the set of time that you are going to be solving over. 
    % yinit is your initial values to solve for. 
    % [] 
    % [a b c]. a = Threshold voltage for spiking / b = oscillatory frequency (ensures that blocking mechanism doesn't just continuously grow. If we have that b is high then the oscillatory frequency is high.  c = critical point location / growth rate of blocking mech. 
    % I(loop1,:) will be a vector [0 0 0 0], [0 1 0 0], [1 0 0 0], [1 1 0 0]. 
    % mat holds the weights that you are going to apply. 
   
    yinit=y(end,:)'; % This is taking the voltage from the last set of inputs and using them as the starting voltage for the next set of inputs - for continuity. 

    tlong=[tlong ; t + (loop1 - 1) * tmax]; % These take on the outputs for the x axis. The times that has been solved for. 
    ylong=[ylong ; y]; % These hold the values for the y axis. 
end

% Graphically displaying outputs. 

figure(Name = 'Oscillatory Threshold Computing Full-Adder'); % Naming the Figure.
t = tiledlayout(5,5);
t.Padding = 'compact';
t.TileSpacing = 'compact';

nexttile(1, [1 3]); % I_1
plot(tlong,ylong(:,1),'green');  % Plotting the Timeseries for I_1.
xlim([tlong(1) tlong(end)]); % Setting X-Axis Limits. 
ylim([-0.5 1]); % Setting Y-Axis Limits. 
xlabel('Time',FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_1$: $v(t)$',FontSize=15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 1 ($I_1$) - Fast Variable ($v$) Time Series Plot',FontSize=15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(6, [1 3]); % I_2
plot(tlong,ylong(:,3),'blue');  % Plotting the Timeseries for I_2.
xlim([tlong(1) tlong(end)]); % Setting X-Axis Limits. 
ylim([-0.5 1]); % Setting Y-Axis Limits. 
xlabel('Time',FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_2$: $v(t)$',FontSize=15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 2 ($I_2$) - Fast Variable ($v$) Time Series Plot',FontSize=15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0) % Making the y-axis label horizontal.

nexttile(11, [1 3]); % I_3
plot(tlong,ylong(:,5),'cyan');  % Plotting the Timeseries for I_3. 
xlim([tlong(1) tlong(end)]); % Setting X-Axis Limits. 
ylim([-0.5 1]); % Setting Y-Axis Limits. 
xlabel('Time',FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_3$: $v(t)$',FontSize=15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 3 ($I_3$) - Fast Variable ($v$) Time Series Plot',FontSize=15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(16,[1 3]); % O_1
plot(tlong,ylong(:,7),'red');  % Plotting the Timeseries for O_1.
xlim([tlong(1) tlong(end)]); % Setting X-Axis Limits. 
ylim([-0.5 1]); % Setting Y-Axis Limits. 
xlabel('Time',FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_1$: $v(t)$',FontSize=15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 1 ($O_1$) - Fast Variable ($v$) Time Series Plot',FontSize=15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0) % Making the y-axis label horizontal.

nexttile(21,[1 3]); % O_2
plot(tlong,ylong(:,9),'magenta');  % Plotting the Timeseries for O_2.
xlim([tlong(1) tlong(end)]); % Setting X-Axis Limits. 
ylim([-0.5 1]); % Setting Y-Axis Limits. 
xlabel('Time',FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$',FontSize=15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 2 ($O_2$) - Fast Variable ($v$) Time Series Plot',FontSize=15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.


nexttile(4, [5, 2]); % Plotting the phase portraits.
plot(ylong(:,1),ylong(:,2), Color='green', LineWidth=1.5);  % Plotting the Phase Portrait for I_1.
hold on;
plot(ylong(:,3),ylong(:,4), Color='blue', LineWidth=1.5);  % Plotting the Phase Portrait for I_2.
hold on;
plot(ylong(:,5),ylong(:,6), Color='cyan', LineWidth=1.5);  % Plotting the Phase Portrait for I_3.
hold on;
plot(ylong(:,7),ylong(:,8), Color='red', LineWidth=1.5);  % Plotting the Phase Portrait for O_1.
hold on;
plot(ylong(:,9),ylong(:,10), Color='magenta', LineWidth=1.5); % Plotting the Phase Portrait for O_2.
xlabel('$v(t)$',FontSize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$w(t)$',FontSize = 15, Interpreter='latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.
legend('Input Oscillator 1 ($I_1$)','Input Oscillator 2 ($I_2$)','Input Oscillator 3 ($I_3$)','Output Oscillator 1 ($O_1$)', 'Output Oscillator 2 ($O_2$)', fontsize = 8 , Interpreter='latex'); % Giving a legend to the graph. 
title('Logical Full-Adder - Phase Portrait',FontSize=15, Interpreter='latex'); % Title for the phase portrait. 

sgt = sgtitle('\textbf{Oscillatory Threshold Computing - Full-Adder Plots}', fontsize = 18, Interpreter='latex'); % Giving a title to the figure.




function cols = FN(~,y,pars,I,mat, m,p) %cols is the output. 
% cols is a column vector with 8 rows.  
% row1 = value for v' for the first oscillator (fast variable/voltage/ap)
% row2 = value for u' for the first oscillator (slow / blocking mechanism)

% row3 = value for v' for the second oscillator (fast variable/voltage/ap)
% row4 = value for u' for the second oscillator (slow / blocking mechanism)

% row5 = value for v' for the third oscillator (fast variable/voltage/ap)
% row6 = value for u' for the third oscillator (slow / blocking mechanism)

% row7 = value for v' for the fourth oscillator (fast variable/voltage/ap)
% row8 = value for u' for the fourth oscillator (slow / blocking mechanism)


Activation_Function = @(v,m,p) 1 ./ (1 + exp(m * v + p)); % The activation function we use to decipher if an oscillator impacts other oscillators (their coupling) - carried out through the slow variable. 
a=pars(1); b=pars(2); c=pars(3); % These are our constant values. 
mat = mat'; % Transpose our input weights matrix.
nodes = floor(length(y)/2); % Number of oscillators.
cols = zeros(nodes*2,1); % We need cols (the output), to have 8 rows and 1 column. The 8 rows represent the same 
u = y(1:2:end); % Will hold the set of values for the fast variable. 
v = y(2:2:end); % will hold the set of values for the slow variable. 
cols(1:2:end)= -u .* (u - a) .* (u - 1) - v + I; % Fast variable part of the differential equation. 

% Based on our Knowlegde of the FN model we can tel from this that the rate of change / neuron will spike when the value for 
% voltage gets to 0.1. Once it reaches that value it will gro=w, anything below that value and it will stay low (i.e. threshold value = 0.1)
% We also know that the value for voltage will only continue to rise until it reaches the value 1, as a limit. 

cols(2:2:end) = c * (u - b * v); % Second variable part of the differential equation.

cols(1:2:end)= cols(1:2:end) + mat * Activation_Function(v,m,p); %Clearly here the coupling between oscillators is being done.
end
