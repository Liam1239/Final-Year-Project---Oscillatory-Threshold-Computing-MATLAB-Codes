tmax=1000;
tspan=[0 tmax]; % Timespan for solving the system. 

e1 = 0.7; % Synaptic weights being applied from I_1 - I_7 to O_1.
e2 = 0.375; % Synaptic weights being applied from I_1 - I_7 to O_2.
e3 = 0.22; % Synaptic weights being applied from I_1 - I_7 to O_3.

i1 = -1.25; % Inhibitory Synaptic weight from O_2 to O_1.
i2 = -1.4; % Inhibitory Synaptic weight from O_3 to O_2.
i3 = -2.65; % Inhibitory Synaptic weight from O_3 to O_1.
 

% This is the matrix holding each of the synaptic weights, defined above, to be applied to the outputs to each oscillator. 
% The easiest way to think about it is that the ith row describes the synaptic weights that are being applied to it from I_1 - I_7 and then from O_1 - O_3.
mat = [0 0 0 0 0 0 0 0 0 0 % Weights applied to I_1
    0 0 0 0 0 0 0 0 0 0 % Weights applied to I_2
    0 0 0 0 0 0 0 0 0 0 % Weights applied to I_3
    0 0 0 0 0 0 0 0 0 0 % Weights applied to I_4
    0 0 0 0 0 0 0 0 0 0 % Weights applied to I_5
    0 0 0 0 0 0 0 0 0 0 % Weights applied to I_6
    0 0 0 0 0 0 0 0 0 0 % Weights applied to I_7
    e1 e1 e1 e1 e1 e1 e1 0 i1 i3 % Weights applied to O_1
    e2 e2 e2 e2 e2 e2 e2 0 0 i2 % Weights applied to O_2
    e3 e3 e3 e3 e3 e3 e3 0 0 0]'; % Weights applied to O_3

% Additional Input currents applied to each of the oscillators.
% Sequentially add one more input, until we reach the addition of 7-bits - we do not show all permutations as that would be significantly too many permutations to show.  
I = [0 0 0 0 0 0 0 0 0 0 % 0 active inputs.
    1 0 0 0 0 0 0 0 0 0 % 1 active inputs.
    1 1 0 0 0 0 0 0 0 0 % 2 active inputs.
    1 1 1 0 0 0 0 0 0 0 % 3 active inputs.
    1 1 1 1 0 0 0 0 0 0 % 4 active inputs.
    1 1 1 1 1 0 0 0 0 0 % 5 active inputs.
    1 1 1 1 1 1 0 0 0 0 % 6 active inputs.
    1 1 1 1 1 1 1 0 0 0]; % 7 active inputs.


m = -100; % Used in Activation Function.

p = [60 60 60 60 60 60 60 60 60 75]'; % Used in the activation function, but altered for this implementation of OTC. 
yinit = zeros(size(mat,1)*2,1); % Both fast and slow variables for all oscillators will initially be set to zero. 
a = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.15]'; %  % alpha (in FHN), altered for the last oscillator, to increase the oscillatory threshold.
b = 0.1; % gamma (in FHN)
c = 0.1;  % epsilon (in FHN)

nodes = size(I,2);
ylong = [];tlong = []; %Where outputs will be stored. 

for loop1=1:size(I,1) % Loops through 4 times - This represents our 4 sets of inputs. (0,0),(0,1),(1,0) & (1,1). 
    [t,y]=ode45(@FN,tspan,yinit,[],[b c],I(loop1,:)',mat, m,p,a); 
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
figure(Name = 'Seven-Input Bit Counter'); % Naming the Figure. 
k = tiledlayout(10,1); % We need 10 tiles for the figure
k.Padding = 'compact';
k.TileSpacing = 'compact';

nexttile(1, [1 1]); % I_1
plot(tlong,ylong(:,1),Color='blue'); % Plotting the Timeseries for I_1.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_1$: $v(t)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(2, [1 1]); % I_2
plot(tlong,ylong(:,3),Color='blue'); % Plotting the Timeseries for I_2.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_2$: $v(t)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(3, [1 1]);% I_3
plot(tlong,ylong(:,5),Color='blue'); % Plotting the Timeseries for I_3.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_3$: $v(t)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(4, [1 1]); % I_4
plot(tlong,ylong(:,7),Color='blue'); % Plotting the Timeseries for I_4.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_4$: $v(t)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(5, [1 1]); % I_5
plot(tlong,ylong(:,9),Color='blue'); % Plotting the Timeseries for I_5.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_5$: $v(t)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(6, [1 1]); % I_6
plot(tlong,ylong(:,11),Color='blue'); % Plotting the Timeseries for I_6.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_6$: $v(t)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(7, [1 1]); % I_7
plot(tlong,ylong(:,13),Color='blue'); % Plotting the Timeseries for I_7.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_7$: $v(t)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(8, [1 1]); % O_1
plot(tlong,ylong(:,15),Color='red'); % Plotting the Timeseries for O_1.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$O_1$: $v(t)$ (1)',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(9, [1 1]); % O_2
plot(tlong,ylong(:,17),Color='magenta'); % Plotting the Timeseries for O_2.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$ (2)',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(10, [1 1]); % O_3
plot(tlong,ylong(:,19),Color='green'); % Plotting the Timeseries for O_3.
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time',FontSize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$O_3$: v(t) $(4)$',FontSize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

sgt = sgtitle('\textbf{Oscillatory Threshold Computing - Seven-Input Bit Counter Output}', fontsize = 18, Interpreter = 'latex'); % Giving a title to the figure.  

function cols = FN(~,y,pars,I,mat, m,p,a) %cols is the output. 
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
b=pars(1); c=pars(2); % These are our constant values. 
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
