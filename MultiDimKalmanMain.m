%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KalmanMain: An investigation into Kalman Filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Global Parameters

% Mode: 0 - State Update Equation
% Mode: 1 - Alpha-Beta Filter
Mode = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Making the Data
deltaTime   = 5;
Time        = 5:deltaTime:50;

Truth.Velocity      = 0;
Truth.InitPosition  = 50; %30e3;
Truth.Postion       = [50.479, 51.025, 51.5, 52.003, 52.494, 53.002, 53.499, 54.006, 54.498, 54.991];
Truth.ProcessNoise  = 0.15;

% Truth.Postion       = zeros(size(Time,2), 1);
% for i = 1:size(Time,2)
%     Truth.Postion(i) = Truth.Velocity * Time(i) + Truth.InitPosition;
% end

NoiseScale          = 10;
Measured.Positon    = [50.45, 50.967, 51.6, 52.106, 52.492, 52.819, 53.433, 54.007, 54.523, 54.99];

% Measured.Positon    = Truth.Postion + NoiseScale.*(rand(size(Time, 2), 1) - 0.5);

%%%%%%%%%%%%%%%%
% Kalman
Initial.EstimateValue = 10; %60;
Initial.EstimateError = 100^2; %15^2;

Measured.Error = 0.1^2;

Kalman(Measured, Truth, Time, Initial);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Kalman Filter
function [Estimate] = Kalman(Measured, Truth, Time, Initial)

    % Initialize 
    Prediction.EstimateValue = Initial.EstimateValue;
    Prediction.EstimateError = Initial.EstimateError + Truth.ProcessNoise;

    % Iterative Estimates
    Estimate.Value = zeros(size(Time, 2), 1);
    Estimate.Error = zeros(size(Time, 2), 1);

    for n = 1:size(Time, 2)
        
        % STEP 1 - UPDATE
        % Kalman Gain Calculation
        K = Prediction.EstimateError / (Prediction.EstimateError + Measured.Error);

        % Estimate Current Value
        Estimate.Value(n) = Prediction.EstimateValue + K .* (Measured.Positon(n) - Prediction.EstimateValue);

        % Estimate Current Uncertainty
        Estimate.Error(n) = (1 - K) * Prediction.EstimateError;


        % STEP 2 - PREDICT
        Prediction.EstimateValue = Estimate.Value(n);
        Prediction.EstimateError = Estimate.Error(n) + Truth.ProcessNoise;

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Figures
    
    figure;
    hold on;
    plot(Time, Truth.Postion,'LineWidth', 2,'LineStyle', '--')
    plot(Time, Measured.Positon, 'LineWidth', 2)
    plot(Time, Estimate.Value, 'LineWidth', 2, 'LineStyle', '-.')
    hold off;
    grid on;
    xlabel('Time (s)')
    ylabel('Position (m)')
    title('Kalman Filter: Estimate Value', 'Interpreter','latex')
    leg = legend("Truth", "Measured", "Estimate");
    leg.Location = 'northwest';
    ax = gca;
    ax.FontSize = 14;
    if Truth.InitPosition < Truth.Postion(end)
        ylim([Truth.InitPosition Truth.Postion(end)])
    else
        ylim([(Truth.InitPosition - 10) (Truth.InitPosition + 10)])
    end

    figure;
    hold on;
    plot(Time, ones(size(Time, 2),1) .* Measured.Error, 'LineWidth', 2, 'LineStyle', '--')
    plot(Time, Estimate.Error, 'LineWidth', 2)
    hold off;
    grid on;
    xlabel('Time (s)')
    ylabel('Uncertainty')
    title('Kalman Filter: Estimate Uncertainties', 'Interpreter','latex')
    leg = legend("Measurement Error", "Estimate Uncertainty");
    leg.Location = 'northwest';
    ax = gca;
    ax.FontSize = 14;
    ylim([0 Measured.Error + 5])

end











