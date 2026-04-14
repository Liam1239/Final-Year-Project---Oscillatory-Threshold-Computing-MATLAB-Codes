tmax = 1000;
tspan = [0 tmax]; % Timespan for solving the system. 

% EXCITATORY SYNAPTIC WEIGHTS.
AND = 0.4; % Excitatory weight applied commonly throughout the system.
w3 = 0.65; % Excitatory weight applied from the output of O_1 to O_3.
w5 = 0.24; % Excitatory weight applied to O_5 from all of its inputs.

% INHIBITORY SYNAPTIC WEIGHTS.
i1 = -1.5; % Inhibitory weight applied from O_5 to O_4 and O_3.

% Weights matrix. 
mat = [0 0 0 0 0 0 0 0 0       % Weights applied to I_1.
       0 0 0 0 0 0 0 0 0       % Weights applied to I_2.
       0 0 0 0 0 0 0 0 0       % Weights applied to I_3.
       0 0 0 0 0 0 0 0 0       % Weights applied to I_4.
       0 AND AND 0 0 0 0 0 0   % Weights applied to O_1 (Intermediary oscillator).
       AND 0 AND 0 0 0 0 0 0   % Weights applied to O_2 (represents the denary value 1).
       AND 0 0 AND w3 0 0 0 i1 % Weights applied to O_3 (represents the denary value 2).
       0 AND 0 AND 0 0 0 0 i1  % Weights applied to O_4 (represents the denary value 4). 
       w5 0 0 w5 w5 0 0 0 0]'; % Weights applied to O_5 (represents the denary value 8). 
       
% Inputs Matrix. 
I = [0 0 0 0 0 0 0 0 0 % 0 * 0
     0 0 1 0 0 0 0 0 0 % 0 * 1
     0 0 0 1 0 0 0 0 0 % 0 * 2
     0 0 1 1 0 0 0 0 0 % 0 * 3

     1 0 0 0 0 0 0 0 0 % 1 * 0
     1 0 1 0 0 0 0 0 0 % 1 * 1
     1 0 0 1 0 0 0 0 0 % 1 * 2
     1 0 1 1 0 0 0 0 0 % 1 * 3

     0 1 0 0 0 0 0 0 0 % 2 * 0
     0 1 1 0 0 0 0 0 0 % 2 * 1
     0 1 0 1 0 0 0 0 0 % 2 * 2
     0 1 1 1 0 0 0 0 0 % 2 * 3
     
     1 1 0 0 0 0 0 0 0 % 3 * 0
     1 1 1 0 0 0 0 0 0 % 3 * 1
     1 1 0 1 0 0 0 0 0 % 3 * 2
     1 1 1 1 0 0 0 0 0 % 3 * 3
     ];

m = -100; % Used in Activation Function.
p = 60; % Used in Activation Function.
yinit = zeros(size(mat,1)*2,1); % Both fast and slow variables for all oscillators will initially be set to zero. 
a = 0.1; % alpha (in FHN)
b = 0.1; % gamma (in FHN)
c = 0.1;  % epsilon (in FHN)

nodes = size(I,2);
ylong = []; % Where the y outputs are stored (values for the fast variable).
tlong = []; % Where the x outputs are stored (values for the time).

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
figure(Name = 'Two-By-Two Bit Multiplier'); % Naming the Figure.
t = tiledlayout(8,1);
t.Padding = 'compact';
t.TileSpacing = 'compact';

% =========================================================================
% =========================================================================
% INPUT OSCILLATORS

nexttile(1, [1 1]) % Representing I_1 --> Represents the output for the denary value 1 in the first input number. 
plot(tlong, ylong(:,1),'blue'); % Time series of the fast variable for I_1
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits. 
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_1$: $v(t)$, (1)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(2, [1 1]) % Representing I_2 --> Represents the output for the denary value 2 in the first input number. 
plot(tlong, ylong(:,3),'blue'); % Time series of the fast variable for I_2
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_2$: $v(t)$, (2)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(3, [1 1]) % Representing I_3 --> Represents the output for the denary value 1 in the second input number. 
plot(tlong, ylong(:,5),'green'); % Time series of the fast variable for I_3
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_3$: $v(t)$, (1)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(4, [1 1]) % Representing I_4 --> Represents the output for the denary value 2 in the second input number. 
plot(tlong, ylong(:,7),'green'); % Time series of the fast variable for I_4
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$I_4$: $v(t)$, (2)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

% =========================================================================
% =========================================================================
% OUTPUT OSCILLATORS

nexttile(5, [1 1]) % Representing O_2 --> Represents the output for the denary value 1 in the output numbers.
plot(tlong, ylong(:,11),'magenta'); % Time series of the fast variable for O_2
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$, (1)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(6, [1 1]) % Representing O_3 --> Represents the output for the denary value 2 in the output numbers.
plot(tlong, ylong(:,13),'magenta'); % Time series of the fast variable for O_3
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$O_3$: $v(t)$, (2)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(7, [1 1]) % Representing O_4 --> Represents the output for the denary value 4 in the output numbers.
plot(tlong, ylong(:,15),'magenta'); % Time series of the fast variable for O_4
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$O_4$: $v(t)$, (4)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(8, [1 1]) % Representing O_5 --> Represents the output for the denary value 8 in the output numbers.
plot(tlong, ylong(:,17),'magenta'); % Time series of the fast variable for O_5
xlim([tlong(1) tlong(end)]); % Setting the X-Axis limits.
ylim([-0.5 1]); % Setting the Y-Axis limits.
xlabel('Time',fontsize = 15, Interpreter = 'latex'); % Naming the x-axis.
ylabel('$O_5$: $v(t)$, (8)',fontsize = 15, Interpreter = 'latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

sgt = sgtitle('\textbf{Oscillatory Threshold Computing, Two-By-Two Bit Multiplier Output}', fontsize = 18, Interpreter = 'latex');
 

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
nodes = floor(length(y)/2);
cols = zeros(nodes*2,1); % We need cols (the output), to have 8 rows and 1 column. The 8 rows represent the same 
u = y(1:2:end); % Will hold the set of values for the fast variable. 
v = y(2:2:end); % will hold the set of values for the slow variable. 
cols(1:2:end)= -u .* (u - a) .* (u - 1) - v + I; % Fast variable part of the differential equation. 

% Based on our Knowlegde of the FN model we can tel from this that the rate of change / neuron will spike when the value for 
% voltage gets to 0.1. Once it reaches that value it will gro=w, anything below that value and it will stay low (i.e. threshold value = 0.1)
% We also know that the value for voltage will only continue to rise until it reaches the value 1, as a limit. 

cols(2:2:end) = c * (u - b * v); % Second variable part of the differential equation.

cols(1:2:end)= cols(1:2:end) + mat * Activation_Function(v,m,p); % Clearly here the coupling between oscillators is being done.
end