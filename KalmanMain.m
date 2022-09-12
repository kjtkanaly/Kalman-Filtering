%% Average Value Formula
close all;
clear all;

% Making The Data
Time = 1:0.5:20;

Truth = 5 .* ones(size(Time,2),1);
Measured = Truth + 0.5 .* (rand(size(Truth,1),1) - 0.5);

AVG = zeros(size(Truth,1),1);

for n = 1:size(Truth,1)

	PreviousMeasured = 0;

	for i = 1:n
		PreviousMeasured = PreviousMeasured + Measured(i);
	end

	AVG(n) = (1/n) .* (PreviousMeasured);

end

fig = figure;
hold on;
plot(Time,Truth,'LineWidth',1.5,'LineStyle','--');
plot(Time,Measured,'LineWidth',1.5);
plot(Time, AVG, 'LineWidth', 1.5, 'LineStyle', '-.')
hold off;
grid on;


%% Alpha−Beta Track Update Equations
close all;
clear all;

alpha = 0.2;    % High Precision Radars use a high alpha (close to 1)
beta  = 0.2;    % High Precision Radars use a high beta  (close to 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Making the Data
deltaTime   = 1;
Time        = 0:deltaTime:50;

Truth.Velocity      = 40;
Truth.InitPosition  = 30e3;
Truth.Postion       = zeros(size(Time,2), 1);

for i = 1:size(Time,2)
    Truth.Postion(i) = Truth.Velocity * Time(i) + Truth.InitPosition;
end

NoiseScale          = 400;
Measured.Positon    = Truth.Postion + NoiseScale.*(rand(size(Time, 2), 1) - 0.5);

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

    Estimate.Positon(n)  = Initial.Position + alpha * (Measured.Positon(n) - Initial.Position);
    Estimate.Velocity(n) = Initial.Velocity + beta  * ((Measured.Positon(n) - Initial.Position) / deltaTime);

    Prediction.Position  = Estimate.Positon(n) + deltaTime * Estimate.Velocity(n);
    Prediction.Velocity  = Estimate.Velocity(n);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures

figure;
hold on;
plot(Time, Truth.Postion,'LineWidth', 2,'LineStyle', '--')
plot(Time, Measured.Positon, 'LineWidth', 2)
plot(Time, Estimate.Positon, 'LineWidth', 2, 'LineStyle', '-.')
hold off;
grid on;
xlabel('Time (s)')
ylabel('Position (m)')
title('$\alpha$-$\Beta$ Filter', 'Interpreter','tex')
leg = legend("Truth", "Measured", "Estimate");
leg.Location = 'northwest';
ax = gca;
ax.FontSize = 14;
ylim([Truth.InitPosition Truth.Postion(end)])

















