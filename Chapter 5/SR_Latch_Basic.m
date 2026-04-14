tmax=1000; 
tspan=[0 tmax]; % Timespan for solving the system. 

e1 = 0.15; 
i1 = -0.65;
input_current = 1;

% You apply an initial input current to O_2 through input_current.
%       This will cause initial oscillatory behaviour of O_2, in essentially the exact same way that we control the behaviour of input oscillators. 
%       This will also set make the coupling weight X_1 active from O_2 to O_1. 
%       The only real limitation this all places on the values for the weights is that W_1 should be above the threshold value for oscillation T. 

% Then you apply the input current to both O_1 & O_2 simultaneously - No change in the state of the system should occur. 
%       The key limitation that is applied to this is that X_1 should be sufficiently close to W_1, so that the inhibitory coupling from O_2 to O_1 is strong enough to ensure that the Input_Current cannot overcome the threshold value and begin oscillation. 
%       Since O_2 is already oscillating and O_1 is not the inhibitory coupling weight X_1 will only be supplied to O_1.
%       The inhibitory coupling from O_1 to O_2 will not be activated since we have that O_1 will not be oscillating.

% Then we want to set the latch. So we apply an input current from I_1 to O_1
%       The input_current and an additional input utilising the weight W_1 is input into O_1.
%       The extra input of the weight should be enough to take the additional input current over the threshold value, despite the initial inhibitory connection between the two threshold oscillators. 
%       Therefore, O_1 begins to oscillate and inhibits O_2. 

% Then when we want to reset the SR-FF we use I_2 and a symmetric process to the one described above occurs. 

% Set up of synaptic weight inputs. 
%   The first column represents the weights applied from I_1 to I_1, I_2, O_1 and O_2 respectively. 
%   The second column represents the weights applied from I_2 to I_1, I_2, O_1 and O_2 respectively.
%   The third column represents the weights applied from O_1 to I_1, I_2, O_1 and O_2 respectively.
%   The fourth column represents the weights applied from O_2 to I_1, I_2, O_1 and O_2 respectively.
mat = [0 0 0 0 % Weights applied to I_1
       0 0 0 0 % Weights applied to I_2
      e1 0 0 i1 % Weights applied to O_1
      0 e1 i1 0]'; % Weights applied to O_2


I1=[0 0 0 input_current % Inputs in the first instance to I_1, I_2, O_1, O_2
   0 0 input_current input_current
   1 0 input_current input_current % Inputs in the second instance to I_1, I_2, O_1, O_2
   0 0 input_current input_current
   0 1 input_current input_current % Inputs in the third instance to I_1, I_2, O_1, O_2
   0 0 input_current input_current]; 

I2=[0 0 input_current 0 % Inputs in the first instance to I_1, I_2, O_1, O_2
   0 0 input_current input_current
   0 1 input_current input_current % Inputs in the second instance to I_1, I_2, O_1, O_2
   0 0 input_current input_current
   1 0 input_current input_current % Inputs in the third instance to I_1, I_2, O_1, O_2
   0 0 input_current input_current]; 

m = -100; % Used in Activation Function.
p = 60; % Used in Activation Function. 
yinit = zeros(size(mat,1)*2,1); % Both fast and slow variables for all oscillators will initially be set to zero. 
a = 0.1; % alpha (in FHN)
b = 0.1; % gamma (in FHN)
c = 0.1;  % epsilon (in FHN)

nodes = size(I1,2);
ylong1 = [];tlong1 = []; %Where outputs will be stored. 

for loop1=1:size(I1,1) % Loops through 4 times - This represents our 4 sets of inputs. (0,0),(0,1),(1,0) & (1,1).
    [t,y]=ode45(@FN, tspan, yinit, [] , [a b c], I1(loop1,:)', mat, m, p); 
    % tspan is just simply the set of time that you are going to be solving over. 
    % yinit is your initial values to solve for. 
    % [] 
    % [a b c]. a = Threshold voltage for spiking / b = oscillatory frequency (ensures that blocking mechanism doesn't just continuously grow. If we have that b is high then the oscillatory frequency is high.  c = critical point location / growth rate of blocking mech. 
    % I(loop1,:) will be a vector [0 0 0 0], [0 1 0 0], [1 0 0 0], [1 1 0 0]. 
    % mat holds the weights that you are going to apply. 
   
    
    yinit = y(end,:)'; % This is taking the voltage from the last set of inputs and using them as the starting voltage for the next set of inputs.
    tlong1 = [tlong1;t + (loop1-1)*tmax]; % These take on the outputs for the x axis. The times that has been solved for. 
    ylong1 = [ylong1;y]; % These hold the values for the y axis. 
end


% Carry out the same computation as the code above, just with different input currents, defined by I_2. 
nodes = size(I2,2);
yinit = zeros(size(mat,1)*2,1); % Both fast and slow variables for all oscillators will initially be set to zero.
ylong2 = [];tlong2 = []; %Where outputs will be stored. 
for loop1=1:size(I2,1) % Loops through 4 times - This represents our 4 sets of inputs. (0,0),(0,1),(1,0) & (1,1). 
    [t,y]=ode45(@FN, tspan, yinit, [], [a b c], I2(loop1,:)',mat, m, p); 
    % tspan is just simply the set of time that you are going to be solving over. 
    % yinit is your initial values to solve for. 
    % [] 
    % [a b c]. a = Threshold voltage for spiking / b = oscillatory frequency (ensures that blocking mechanism doesn't just continuously grow. If we have that b is high then the oscillatory frequency is high.  c = critical point location / growth rate of blocking mech. 
    % I(loop1,:) will be a vector [0 0 0 0], [0 1 0 0], [1 0 0 0], [1 1 0 0]. 
    % mat holds the weights that you are going to apply. 
   
    
    yinit=y(end,:)'; % This is taking the voltage from the last set of inputs and using them as the starting voltage for the next set of inputs.
    tlong2=[tlong2; t + (loop1-1) * tmax]; % These take on the outputs for the x axis. The times that has been solved for. 
    ylong2=[ylong2 ; y]; % These hold the values for the y axis. 
end

% Graphically displaying outputs. 

figure(name = 'Set-Reset (SR) Latch')
t = tiledlayout(4,2); % 2 columns (1 for the instance where the latch is initially set & 1 for where the latch is initially not set.). 4 rows for each of the oscillators I_1, I_2, O_1, O_2. 
t.Padding = 'compact';
t.TileSpacing = 'compact';

% Here we show the example of where the latch is initially not set. 

nexttile(1, [1 1]) % This represents I_1
plot(tlong1,ylong1(:,1),'green'); % Plotting the Timeseries for I_1.
axis([tlong1(1) tlong1(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time',fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 1 ($I_1$) (Set) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(3, [1 1])  % This represents I_2
plot(tlong1,ylong1(:,3),'blue'); % Plotting the Timeseries for I_2.
axis([tlong1(1) tlong1(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 2 ($I_2$) (Reset) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(5, [1 1])  % This represents O_1
plot(tlong1,ylong1(:,5),'red'); % Plotting the Timeseries for O_1.
axis([tlong1(1) tlong1(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 1 ($O_1$) (Q) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(7, [1 1])  % This represents O_2
plot(tlong1,ylong1(:,7),'magenta'); % Plotting the Timeseries for O_2.
axis([tlong1(1) tlong1(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time',fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 2 ($O_2$) ($\bar{Q}$) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.


% Now we show the example whereby the latch is initially set.

nexttile(2, [1 1]) % This represents I_1
plot(tlong2,ylong2(:,1),'green'); % Plotting the Timeseries for I_1.
axis([tlong2(1) tlong2(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 1 ($I_1$) (Set) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(4, [1 1])  % This represents I_2
plot(tlong2,ylong2(:,3),'blue'); % Plotting the Timeseries for I_2.
axis([tlong2(1) tlong2(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 2 ($I_2$) (Reset) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(6, [1 1])  % This represents O_1
plot(tlong2,ylong2(:,5),'red'); % Plotting the Timeseries for O_1.
axis([tlong2(1) tlong2(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 1 ($O_1$) (Q) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(8, [1 1])  % This represents O_2
plot(tlong2,ylong2(:,7),'magenta'); % Plotting the Timeseries for O_2.
axis([tlong2(1) tlong2(end) -0.5 1]); % Setting up the limits of the axis.
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 2 ($O_2$) ($\bar{Q}$) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

sgt = sgtitle('\textbf{Oscillatory Threshold Computing, Set-Reset (SR) Latch Output - Sustained Inputs / Inpulses, Without Noise}', fontsize = 18, Interpreter = 'latex'); % Title of the Figure.
    



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
