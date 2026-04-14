tmax=1000; % The time over which the system will be solved
tspan=[0 tmax];

w1 = 0.7; % Synaptic weight coupling - From All input Oscillators (I_1 - I_15) to O_1.
w2 = 0.35; % Synaptic weight coupling - From All input Oscillators (I_1 - I_15) to O_2.
w3 = (13/60); % Synaptic weight coupling - From All input Oscillators (I_1 - I_15) to O_3.
w4 = (419/2240); % Synaptic weight coupling - From All input Oscillators (I_1 - I_15) to O_4.

x1 = -1.25; % Synaptic weight coupling - From O_2 to O_1. 
x2 = -1.375; % Synaptic weight coupling - From O_3 to O_2. 
x3 = -2.65; % Synaptic weight coupling - From O_3 to O_1. 
x4 = -1.741; % Synaptic weight coupling - From O_4 to O_3. 
x5 = -2.775; % Synaptic weight coupling - From O_4 to O_2.
x6 = -5.5; % Synaptic weight coupling - From O_4 to O_1. 

% Weights Matrix
mat = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_1
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_2
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_3
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_4
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_5
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_6
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_7
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_8
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_9
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_10
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_11
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_12
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_13
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_14
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % Weights applied to I_15
    w1 w1 w1 w1 w1 w1 w1 w1 w1 w1 w1 w1 w1 w1 w1 0 x1 x3 x6 % O_1 should receive weight inputs of w1 from each of the input oscillators, x1 from O2, x3 from O3, x6 from O4. 
    w2 w2 w2 w2 w2 w2 w2 w2 w2 w2 w2 w2 w2 w2 w2 0 0 x2 x5 % O_2 should receive weight inputs of w2 from each of the input oscillators, x2 from O3, x5 from O4. 
    w3 w3 w3 w3 w3 w3 w3 w3 w3 w3 w3 w3 w3 w3 w3 0 0 0 x4 % O_3 should receive weight inputs of w3 from each of the input oscillators, x4 from O4. 
    w4 w4 w4 w4 w4 w4 w4 w4 w4 w4 w4 w4 w4 w4 w4 0 0 0 0]'; % O_4 should receive weight inputs of w4 from each of the input oscillators. 

I = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % 1st Run, no inputs to any oscillators. 
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % 2nd Run, 1 input to 1 input oscillators. 
    1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % 3rd Run, 1 input to 2 input oscillators. 
    1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % 4th Run, 1 input into 3 input oscillators.
    1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % 5th Run, 1 input into 4 input oscillators.
    1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 % 6th Run, 1 input into 5 input oscillators.
    1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 % 7th Run, 1 input into 6 input oscillators.
    1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 % 8th Run, 1 input into 7 input oscillators.
    1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 % 9th Run, 1 input into 8 input oscillators.
    1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 % 10th Run, 1 input into 9 input oscillators.
    1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 % 11th Run, 1 input into 10 input oscillators.
    1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 % 12th Run, 1 input into 11 input oscillators.
    1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 % 13th Run, 1 input into 12 input oscillators.
    1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 % 14th Run, 1 input into 13 input oscillators.
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 % 15th Run, 1 input into 14 input oscillators.
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0]; % 16th Run, 1 input into 15 input oscillators.

m = -100; % Used in Activation Function.
p = [60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 75 135]'; % Used in the activation function, but altered for this implementation of OTC. 
% For this implementation, to ensure a working solution, adjustments are required to the oscillatory thresholds for O_3 & O_4. Therefore, the
% activation function also has to change, to ensure that the adjusted oscillators do not impact other oscillators, when they shouldn't. 

yinit = zeros(size(mat,1)*2,1); % Both fast and slow variables for all oscillators will initially be set to zero. 

a = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.15 0.3]'; % alpha in FHN. 
% For this implementation - we are required to change the value of a. By raising / lowering a in comparison to its baseline value 0.1 you can
% increase / decrease the threshold of additional input current required to induce oscillation. For this implementation, it is necessary to
% increase the oscillatory threshold for both O_3 & O_4, to both widen their inequalities and to ensure undesired oscillation is not observed. 

b = 0.1; % gamma (in FHN)
c = 0.1;  % epsilon (in FHN)

nodes = size(I,2); % Number of oscillators.
ylong = [];tlong = []; %Where outputs will be stored. 
for loop1=1:size(I,1) % Loops through 4 times - This represents our 4 sets of inputs. (0,0),(0,1),(1,0) & (1,1). 
    [t,y]=ode45(@FN,tspan,yinit,[],[b c],I(loop1,:)',mat, m, p, a); 
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


t = 0:0.1:tmax * 16; % Used to pass into the below function, to display the number of inputs at any one time.  

I = @(t) heaviside(t-tmax) + heaviside(t-2*tmax) + heaviside(t-3*tmax) + heaviside(t-4*tmax) + ...
heaviside(t-5*tmax) + heaviside(t-6*tmax) + heaviside(t-7*tmax) + heaviside(t-8*tmax) + ...
heaviside(t-9*tmax) + heaviside(t-10*tmax) + heaviside(t-11*tmax) + heaviside(t-12*tmax) + ...
heaviside(t-13*tmax) + heaviside(t-14*tmax) + heaviside(t-15*tmax) + heaviside(t-16*tmax); % This function is used to display the number of inputs throughout the simulation. 

% Graphically displaying the outputs of the system. 
figure(Name = ['Fifteen-Input Bit Counter']); % Naming the Figure. 

k = tiledlayout(5,1); % 5 Rows needed - 1 for displaying the number of inputs used & 4 for each of the required output oscillators. 
k.Padding = 'compact';
k.TileSpacing = 'compact';

nexttile(1, [1 1]); % Number of inputs.
plot(t,I(t),'color','blue'); % Plotting The number of inputs applied to the system. 
xlabel('Time', FontSize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel({'Number of  ','Active Inputs'}, FontSize = 15, Interpreter='latex'); % Naming the y-axis
set(get(gca,'ylabel'),'rotation',0); % % Making the y-axis label horizontal.

nexttile(2, [1 1]); % O_1
plot(tlong,ylong(:,31),Color='red'); % Plotting the time series of O_1 (which represents 1). 
xlim([t(1) t(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time', FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_1$: $v(t)$ (1)', FontSize=15, Interpreter='latex'); % Naming the y-axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(3, [1 1]); % O_2
plot(tlong,ylong(:,33),Color='magenta'); % Plotting the time series of O_2 (which represents 2). 
xlim([t(1) t(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time', FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$ (2)', FontSize=15, Interpreter='latex'); % Naming the y-axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(4, [1 1]); % O_3
plot(tlong,ylong(:,35),Color='green'); % Plotting the time series of O_3 (which represents 4). 
xlim([t(1) t(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time', FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_3$: $v(t)$ (4)', FontSize=15, Interpreter='latex'); % Naming the y-axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(5, [1 1]); % O_4
plot(tlong,ylong(:,37),Color='cyan'); % Plotting the time series of O_4 (which represents 8). 
xlim([t(1) t(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits. 
xlabel('Time', FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_4$: $v(t)$ (8)', FontSize=15, Interpreter='latex'); % Naming the y-axis
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

sgt = sgtitle('\textbf{Oscillatory Threshold Computing - Fifteen-Input Bit Counter Output}', fontsize = 18, Interpreter='latex');
 

function cols = FN(~, y, pars, I, mat, m, p, a) % cols is the output. 
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
b=pars(1); c=pars(2); % These are our constant values (a needed to be passed in on its own as it is now an array).
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