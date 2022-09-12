%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KalmanMain: An investigation into Kalman Filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Global Parameters

% Mode: 0 - State Update Equation
% Mode: 1 - Alpha-Beta Filter
Mode = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Making the Data
deltaTime   = 1;
Time        = 0:deltaTime:50;

Truth.Velocity      = 0;
Truth.InitPosition  = 30e3;
Truth.Postion       = zeros(size(Time,2), 1);

for i = 1:size(Time,2)
    Truth.Postion(i) = Truth.Velocity * Time(i) + Truth.InitPosition;
end

NoiseScale          = 400;
Measured.Positon    = Truth.Postion + NoiseScale.*(rand(size(Time, 2), 1) - 0.5);

StateUpdateEquation(Measured.Positon, Truth, Time);

alpha = 0.2;    % High Precision Radars use a high alpha (close to 1)
beta  = 0.2;    % High Precision Radars use a high beta  (close to 1)

Estimate = AlphaBeta(alpha, beta, Measured.Positon, Truth, Time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% State Update Equation
function [Estimate] = StateUpdateEquation(Measured, Truth, Time)

    Estimate = zeros(size(Time, 2), 1);

    Prediction = Truth.Postion(1);
    
    for n = 1:size(Time, 2)
        
        % Kalman Gain
        alpha = 1/n; 
    
	    Estimate(n) = Prediction + alpha * (Measured(n) - Prediction);

        Prediction = Estimate(n);
    
    end
    
    fig = figure;
    hold on;
    plot(Time,Truth.Postion,'LineWidth', 2, 'LineStyle', '--');
    plot(Time,Measured,'LineWidth', 2);
    plot(Time, Estimate, 'LineWidth', 2, 'LineStyle', '-.')
    hold off;
    grid on;
    xlabel('Time (s)')
    ylabel('Position (m)')
    title('State Update Filter')
    leg = legend("Truth", "Measured", "Estimate");
    leg.Location = 'northwest';
    ax = gca;
    ax.FontSize = 14;
    if Truth.InitPosition < Truth.Postion(end)
        ylim([Truth.InitPosition Truth.Postion(end)])
    else
        ylim([(Truth.InitPosition - 300) (Truth.InitPosition + 300)])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Alpha−Beta Track Update Equations
function [Estimate] = AlphaBeta(alpha, beta, Measured, Truth, Time)

    deltaTime = Time(2) - Time(1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Track-Estimate
    Estimate.Positon  = zeros(size(Time, 2), 1);
    Estimate.Velocity = zeros(size(Time, 2), 1);
    
    Estimate.Positon(1)  = Truth.InitPosition;
    Estimate.Velocity(1) = Truth.Velocity;
    
    Prediction.Position  = Estimate.Positon(1) + deltaTime * Estimate.Velocity(1);
    Prediction.Velocity  = Estimate.Velocity(1);
    
    for n = 2:size(Time, 2) 
        
        Initial.Position = Prediction.Position;
        Initial.Velocity = Prediction.Velocity;
    
        Estimate.Positon(n)  = Initial.Position + alpha * (Measured(n) - Initial.Position);
        Estimate.Velocity(n) = Initial.Velocity + beta  * ((Measured(n) - Initial.Position) / deltaTime);
    
        Prediction.Position  = Estimate.Positon(n) + deltaTime * Estimate.Velocity(n);
        Prediction.Velocity  = Estimate.Velocity(n);
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Figures
    
    figure;
    hold on;
    plot(Time, Truth.Postion,'LineWidth', 2,'LineStyle', '--')
    plot(Time, Measured, 'LineWidth', 2)
    plot(Time, Estimate.Positon, 'LineWidth', 2, 'LineStyle', '-.')
    hold off;
    grid on;
    xlabel('Time (s)')
    ylabel('Position (m)')
    title('$\alpha$ - $\beta$ Filter', 'Interpreter','latex')
    leg = legend("Truth", "Measured", "Estimate");
    leg.Location = 'northwest';
    ax = gca;
    ax.FontSize = 14;
    if Truth.InitPosition < Truth.Postion(end)
        ylim([Truth.InitPosition Truth.Postion(end)])
    else
        ylim([(Truth.InitPosition - 300) (Truth.InitPosition + 300)])
    end


end














