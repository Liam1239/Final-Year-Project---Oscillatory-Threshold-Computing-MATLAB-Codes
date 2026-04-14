a=0.1; %Threshold
b=0.1; %Stoping the blocking from growing too much
c=0.1; %Growth Rate

Oscillator_Inputs = [1 0.7 0.4]; % In this example, we use three different input currents to demonstrate the variation in oscillatory strength / amplitude that you get when adding different input currents. 
Weights_Matrix = zeros (3); % There are no oscillatory couplings between the oscillators. Therefore, the weights matrix can just be a set of zeros. 
Tmax=250; % The time over which the system will be solved.

m = -100; % Used in the activation function. 
p = 60; % Used in the activation function. 
Activation_Function = @(v, m, p) 1./(1 + exp(m*v+p)); % The Activation Function. 
Fast_Variable = @(u, a, v, input_current, activation_funct_val, Weights_Matrix) (-u.*(u-a).*(u-1)-v+input_current) + (Weights_Matrix' * activation_funct_val')'; % Fast Variable function. 
Slow_Variable = @(v, c, u, b) c .* (u - b.*v); % Slow Variable function. 


% ==================================================================================================================================
% ==================================================================================================================================
% ADDING Gaussian Noise
% The variable 'noise' below allows you to change the level of noise added to the system.
% The noise is added through adding a random value to the fast variable of the system at each timestep.
% The 'noise' alters the random values distribution from a N(0,1) distribution to a N(0, noise^2) distribution. 
% i.e. you are changing the STANDARD DEVIATION of the noise to be added. 

% Since Z = (x-mew)/sd, and we want x, given Z, mew and sd, we just rearrange and will just multiply by sd (the noise) later on in the program.
% So, obviously, if you make the noise 0 nothing happens & you can continue as you were.

noise=0.05; % Standard deviation of the noise to be added. 
% ==================================================================================================================================
% ==================================================================================================================================

% yinit will hold what the values of the fast and slow variable should be at the beginning of each of the sections in the matrix Oscillator_Inputs.
yinit = [0.5; 1.474; 0.5; 1.474; 0.5; 1.474];

%yinit=zeros(size(Weights_Matrix,1)*2,1);  % Therefore, we can initially set the yinit to be a set of zeros, with the correct number of inputs as they should all begin from rest.
Y_Long = []; % Will hold the solutions of the equations. 
Timestep = 0.01; % Tiemsteps for integration. 
Number_Of_Iterations = Tmax / Timestep; % Obvious that if we are going over time Tmax & we are looking at every Timestep defined by Timestep, we need to loop through that many times per input.

for looper1 = 1:size(Oscillator_Inputs,1) % Loop through all of the inputs in the Oscillator_Inputs matrix. 
    % CANNOT CONTINUE TO USE ODE45 FOR THIS PROBLEM - Takes far too long. 
    % One of the most common methodologies for solving these types of systems (Stochastic Differential Equation) is the Euler-Maruyama Method.
    Oscillators = zeros(Number_Of_Iterations, size(Weights_Matrix,1)*2); % Produces a matrix of the correct size to hold values for the fast & slow variables - Will eventually hold these values for each iteration IN TURN. 
    Oscillators(1,:) = yinit; % Make sure each of the fast & slow variable values for each oscillator is correct for the beginning of the simulation.

    for looper2 = 1:Number_Of_Iterations - 1 % Need to go to - 1, otherwise errors will occur.

        % EULER-MARUYAMA METHOD FOR THE FAST VARIABLE: X(T + 1) = X(T) + (f(X(T)) * Timestep) + (random value * sqrt(Timestep) * noise)
        Oscillators(looper2 + 1, 1:2:end) = (Oscillators(looper2, 1:2:end)) + (Fast_Variable(Oscillators(looper2, 1:2:end), a, Oscillators(looper2, 2:2:end), Oscillator_Inputs(looper1,:), Activation_Function(Oscillators(looper2, 2:2:end), m, p), Weights_Matrix) * Timestep) + (randn(1, size(Weights_Matrix,1)) * sqrt(Timestep) * noise)  ; % Fast Variable
        % Euler METHOD FOR THE SLOW VARIABLE: X(T + 1) = X(T) + (f(X(T)) * Timestep)
        Oscillators(looper2 + 1, 2:2:end) = (Oscillators(looper2, 2:2:end)) + ((Slow_Variable(Oscillators(looper2, 2:2:end), c, Oscillators(looper2, 1:2:end), b)) * Timestep); %Slow Variable
     
    end 
    
    yinit = Oscillators(end,:); % Need continuity, so you take the values from the last iteration and use them for the next one. 
    Y_Long = [Y_Long; Oscillators]; % Simply stores the outputs of each iteration. 
end 

% Displaying the results graphically. 
figure(name = 'Noisy FitzHugh-Nagumo Threshold Oscillators');
t = tiledlayout('flow');
t.Padding = 'compact';
t.TileSpacing = 'compact';

nexttile(1,[2 2]); % This tile will simply display the phase portrait of each of the three systems. 
plot(Oscillators(:,1),Oscillators(:,2), Color = 'blue', LineWidth = 1); % Plotting v(t) vs w(t) for the first system.
hold on; 
plot(Oscillators(:,3),Oscillators(:,4), Color = 'red', LineWidth = 1); % Plotting v(t) vs w(t) for the second system.
hold on; 
plot(Oscillators(:,5),Oscillators(:,6), Color = 'magenta', LineWidth = 1); % Plotting v(t) vs w(t) for the third system.
xlabel('$v(t)$',FontSize=15, Interpreter='latex'); % Naming the x-axis.
ylabel('$w(t)$',FontSize=15, Interpreter='latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.
title('Phase Portraits of Stochastic FitzHugh-Nagumo Models', FontSize = 15, Interpreter='latex'); %  Giving a title to the graph.
legend('Input Current = 1', 'Input Current = 0.7','Input Current = 0.4', fontsize = 10, Interpreter='latex'); % Giving a legend to the graph.


nexttile(2,[1 2]); % This tile will display the time series of the fast variable for each of the three systems. 
plot(Oscillators(:,1), color = 'blue', LineWidth = 1); % Plotting the time series of the fast variable of the first system. 
hold on; 
plot(Oscillators(:,3), color = 'red', LineWidth = 1); % Plotting the time series of the fast variable of the second system. 
hold on; 
plot(Oscillators(:,5), color = 'magenta', LineWidth = 1); % Plotting the time series of the fast variable of the third system. 
xlabel('$t$', FontSize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$v(t)$', FontSize = 15, Interpreter='latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.
title('Time Series of the Stochastic FitzHugh-Nagumo Fast Variable / Membrane Potential, $v(t)$', FontSize = 15, Interpreter='latex'); %  Giving a title to the graph.
legend('Input Current = 1', 'Input Current = 0.7','Input Current = 0.4', fontsize = 10,Interpreter='latex'); %  Giving a legend to the graph.

nexttile(3,[1 2]); % This tile will display the time series of the slow variable for each of the three systems. 
plot(Oscillators(:,2), color = 'blue', LineWidth = 1); % Plotting the time series of the slow variable of the first system.
hold on; 
plot(Oscillators(:,4), color = 'red', LineWidth = 1); % Plotting the time series of the slow variable of the second system.
hold on;
plot(Oscillators(:,6), color = 'magenta', LineWidth = 1); % Plotting the time series of the slow variable of the thirds system.
xlabel('$t$', FontSize = 15, Interpreter='latex'); % Naming the x-axis.
ylabel('$w(t)$', FontSize = 15, Interpreter='latex'); % Naming the y-axis.
set(get(gca,'ylabel'),'rotation',0); % Making the y-axis label horizontal.
title('Time Series of the Stochastic FitzHugh-Nagumo Slow Variable / Blocking Mechanism, $w(t)$', FontSize=15, Interpreter='latex'); %  Giving a title to the graph.
legend('Input Current = 1', 'Input Current = 0.7','Input Current = 0.4', fontsize = 10,Interpreter='latex'); %  Giving a legend to the graph.


sgt = sgtitle('\textbf{Plots of Stochastic FitzHugh-Nagumo Threshold Oscillators, Where $\sigma$ = 0.05}',  FontSize=18, Interpreter='latex'); % Title of the Figure.