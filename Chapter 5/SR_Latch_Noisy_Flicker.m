Tmax = 1; % The time period the simulation will be carried out over. 

W1 = 1.15; % Weight Applied to the two output oscillators (O_1 & O_2) from the two input oscillators (I_1 & I_2) 
X1 = -1.5; % The inhibitory weighting between the two output oscillators. 
I_C = 1; % This is the external input current applied to the two output oscillators.  

% Holds the 'synaptic' weights applied to each of the oscillators. 
Weights_Matrix = [0 0 0 0 % Holds the weights applied to I_1 from I_1, I_2, O_1, O_2
                  0 0 0 0 % Holds the weights applied to I_2 from I_1, I_2, O_1, O_2
                  W1 0 0 X1 % Holds the weights applied to O_1 from I_1, I_2, O_1, O_2
                  0 W1 X1 0]'; % Holds the weights applied to O_2 from I_1, I_2, O_1, O_2

% ==========================================================================================================================================================================================
% ==========================================================================================================================================================================================
% ==========================================================================================================================================================================================

% In this version (Flicker), we only want the inputs to the two input oscilators (I_1 & I_2) to be flickers / impulses that last for a very short period of time (like an actual neuron), saving power as well. 
% Therefore, we have to set the inputs matrix up slightly different. In this version we use a much larger matrix, for the input ocillators I_1 and I_2 we only set their inputs to 1 for an extremely short amount of time.

% In this example of inputs we wanted to initially provide an input to O_2 only (i.e. not set the latch).
Oscillator_Inputs = zeros(6000,4); % 6,000 rows representing the inputs at all timesteps & 4 representing the number of modelled oscillators. 
Oscillator_Inputs(2001:2010,1) = 1; % Set up the inputs to I_1. 
Oscillator_Inputs(4001:4010,2) = 1; % Set up the inputs to I_2. 
Oscillator_Inputs(:,3) = input_current; Oscillator_Inputs(1:1000, 3) = 0; % Set up the inputs to O_1 - Should receive input_current at all timesteps, except the first 1,000 timesteps (because we initially do not want to set the latch).
Oscillator_Inputs(:,4) = input_current; % Set up the inputs to O_2. 

% In this example of inputs we wanted to initially provide an input to O_1 only (i.e. set the latch).
Oscillator_Inputs2 = zeros(6000,4); % 6,000 rows representing the inputs at all timesteps & 4 representing the number of modelled oscillators.
Oscillator_Inputs2(4001:4010,1) = 1; % Set up the inputs to I_1. 
Oscillator_Inputs2(2001:2010,2) = 1; % Set up the inputs to I_2. 
Oscillator_Inputs2(:,3) = input_current; % Set up the inputs to O_1 (initially set the latch).
Oscillator_Inputs2(:,4) = input_current; Oscillator_Inputs2(1:1000,4) = 0; % Set up the inputs to O_2, delay the additional input current applied to it (as we initially want to set the latch).
% ==========================================================================================================================================================================================
% ==========================================================================================================================================================================================
% ==========================================================================================================================================================================================

m = -100; % Used in the activation function. 
p = 60; % Used in the activation function. 
Activation_Function = @(v, m, p) 1./(1 + exp(m*v+p)); % The Activation Function. 
Fast_Variable = @(u, a, v, input_current, activation_funct_val, Weights_Matrix) (-u.*(u-a).*(u-1)-v+input_current) + (Weights_Matrix' * activation_funct_val')'; % Fast Variable function. 
Slow_Variable = @(v, c, u, b) c .* (u - b.*v); % Slow Variable function. 

a=0.1;b=0.1;c=0.1;  % alpha, gamma, epsilon - Will be used when calling the functions defined above. 

% ==================================================================================================================================
% ==================================================================================================================================
% ADDING Gaussian Noise
% The variable 'noise' below allows you to change the level of noise added to the system.
% The noise is added through adding a random value to the fast variable of the system at each timestep.
% The 'noise' alters the random values distribution from a N(0,1) distribution to a N(0, noise^2) distribution. 
% i.e. you are changing the STANDARD DEVIATION of the noise to be added. 

% Since Z = (x-mew)/sd, and we want x, given Z, mew and sd, we just rearrange and will just multiply by sd (the noise) later on in the program.
% So, obviously, if you make the noise 0 nothing happens & you can continue as you were.


noise=0.1; % Standard deviation of the noise to be added.
% ==================================================================================================================================
% ==================================================================================================================================

% yinit will hold what the values of the fast and slow variable should be at the beginning of each of the sections in the matrix Oscillator_Inputs.
yinit=zeros(size(Weights_Matrix,1)*2,1);  % Therefore, we can initially set the yinit to be a set of zeros, with the correct number of inputs as they should all begin from rest.
Y_Long = []; % Will hold the solutions of the equations. 
Timestep = 0.01; 
Number_Of_Iterations = Tmax / Timestep; % Obvious that if we are going over time Tmax & we are looking at every Timestep defined by Timestep, we need to loop through that many times per input.

for looper1 = 1:size(Oscillator_Inputs,1) % Loop through all of the inputs in the Oscillator_Inputs matrix. 
    % CANNOT CONTINUE TO USE ODE45 FOR THIS PROBLEM - Takes far too long. 
    % One of the most common methodologies for solving these types of systems (Stochastic Differential Equation) is the Euler-Maruyama Method.
    Oscillators = zeros(Number_Of_Iterations, size(Weights_Matrix,1)*2); % Produces a matrix of the correct size to hold values for the fast & slow variables - Will eventually hold these values for each iteration IN TURN. 
    Oscillators(1,:) = yinit; % Make sure each of the fast & slow variable values for each oscillator is correct for the beginning of the simulation.

    for looper2 = 1:Number_Of_Iterations - 1 % Need to go to - 1, otherwise errors will occur.

        % EULER-MARUYAMA METHOD FOR THE FAST VARIABLE: X(T + 1) = X(T) + (f(X(T)) * Timestep) + (random value * sqrt(Timestep) * noise)
        Oscillators(looper2 + 1, 1:2:end) = (Oscillators(looper2, 1:2:end)) + (Fast_Variable(Oscillators(looper2, 1:2:end), a, Oscillators(looper2, 2:2:end), Oscillator_Inputs(looper1,:), Activation_Function(Oscillators(looper2, 2:2:end), m, p), Weights_Matrix) * Timestep) + (randn(1, size(Weights_Matrix,1)) * sqrt(Timestep) * noise)  ; % Fast Variable
        % EULER METHOD FOR THE SLOW VARIABLE: X(T + 1) = X(T) + (f(X(T)) * Timestep)
        Oscillators(looper2 + 1, 2:2:end) = (Oscillators(looper2, 2:2:end)) + ((Slow_Variable(Oscillators(looper2, 2:2:end), c, Oscillators(looper2, 1:2:end), b)) * Timestep); %Slow Variable
     
    end 
    yinit = Oscillators(end,:); % Need continuity, so you take the values from the last iteration and use them for the next one. 
    Y_Long = [Y_Long; Oscillators]; % Simply stores the outputs of each iteration. 
end 

% Repeat the same code as above, but for the alternative set of inputs described by the matrix Oscillator_Inputs2
yinit=zeros(size(Weights_Matrix,1)*2,1);  % Therefore, we can initially set the yinit to be a set of zeros, with the correct number of inputs as they should all begin from rest.
Y_Long2 = []; % Will hold the solutions of the equations. 
for looper1 = 1:size(Oscillator_Inputs2,1) % Loop through all of the inputs in the Oscillator_Inputs matrix. 
    % CANNOT CONTINUE TO USE ODE45 FOR THIS PROBLEM - Takes far too long. 
    % One of the most common methodologies for solving these types of systems (Stochastic Differential Equation) is the Euler-Maruyama Method.
    Oscillators = zeros(Number_Of_Iterations, size(Weights_Matrix,1)*2); % Produces a matrix of the correct size to hold values for the fast & slow variables - Will eventually hold these values for each iteration IN TURN. 
    Oscillators(1,:) = yinit; % Make sure each of the fast & slow variable values for each oscillator is correct for the beginning of the simulation.

    for looper2 = 1:Number_Of_Iterations - 1 % Need to go to - 1, otherwise errors will occur.

        %EULER-MARUYAMA METHOD: X(T + 1) = X(T) + (f(X(T)) * Timestep) + (random value * sqrt(Timestep) * noise)
        Oscillators(looper2 + 1, 1:2:end) = (Oscillators(looper2, 1:2:end)) + (Fast_Variable(Oscillators(looper2, 1:2:end), a, Oscillators(looper2, 2:2:end), Oscillator_Inputs2(looper1,:), Activation_Function(Oscillators(looper2, 2:2:end), m, p), Weights_Matrix) * Timestep) + (randn(1, size(Weights_Matrix,1)) * sqrt(Timestep) * noise) ; % Fast Variable
        % EULER METHOD FOR THE SLOW VARIABLE: X(T + 1) = X(T) + (f(X(T)) * Timestep)
        Oscillators(looper2 + 1, 2:2:end) = (Oscillators(looper2, 2:2:end)) + ((Slow_Variable(Oscillators(looper2, 2:2:end), c, Oscillators(looper2, 1:2:end), b)) * Timestep); %Slow Variable
     
    end 
    yinit = Oscillators(end,:); % Need continuity, so you take the values from the last iteration and use them for the next one. 
    Y_Long2 = [Y_Long2; Oscillators]; % Simply stores the outputs of each iteration. 
end

% Displaying the results graphically. 

figure(name = 'Set-Reset (SR) Latch, Noisy Flicker');
t = tiledlayout(4,2); % 4 rows for the 4 oscillators, 2 different systems. 
t.Padding = 'compact';
t.TileSpacing = 'compact';

nexttile(1, [1 1]) % Representing I_1
plot(Y_Long(:,1),'green'); % Plotting the Timeseries for I_1.
ylim([-1 1.5]);
xlabel('Time',fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 1 ($I_1$) (Set) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(3, [1 1]) % Representing I_2
plot(Y_Long(:,3),'blue'); % Plotting the Timeseries for I_2.
ylim([-1 1.5]);
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 2 ($I_2$) (Reset) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(5, [1 1]) % Representing O_1
plot(Y_Long(:,5),'red'); % Plotting the Timeseries for O_1.
ylim([-1 1.5]);
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 1 ($O_1$) (Q) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(7, [1 1]) % Representing O_2
plot(Y_Long(:,7),'magenta'); % Plotting the Timeseries for O_2.
ylim([-1 1.5]);
xlabel('Time',fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 2 ($O_2$) ($\bar{Q}$) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

% ===========================================================================================
% ===========================================================================================

% Graphing the other version, whereby, initially the latch is set. 

nexttile(2, [1 1]) % Representing I_1
plot(Y_Long2(:,1),'green'); % Plotting the Timeseries for I_1.
ylim([-1 1.5]);
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 1 ($I_1$) (Set) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(4, [1 1]) % Representing I_2
plot(Y_Long2(:,3),'blue'); % Plotting the Timeseries for I_2.
ylim([-1 1.5]);
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$I_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Input Oscillator 2 ($I_2$) (Reset) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(6, [1 1]) % Representing O_1
plot(Y_Long2(:,5),'red'); % Plotting the Timeseries for O_1.
ylim([-1 1.5]);
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_1$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 1 ($O_1$) (Q) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

nexttile(8, [1 1]) % Representing O_2
plot(Y_Long2(:,7),'magenta'); % Plotting the Timeseries for O_2.
ylim([-1 1.5]);
xlabel('Time', fontsize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$O_2$: $v(t)$',fontsize = 15, Interpreter='latex'); % Naming the y-axis.
title('Output Oscillator 2 ($O_2$) ($\bar{Q}$) - Fast Variable ($v$) Time Series Plot',fontsize = 15, Interpreter='latex'); % Giving a title to the graph.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.

sgt = sgtitle('\textbf{Oscillatory Threshold Computing, Set-Reset (SR) Latch Output - Small Impulses, With Noise $\sigma$ = 0.1}', fontsize = 18, Interpreter = 'latex');% Title of the graph. 