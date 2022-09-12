close all;
clear all;

%% Average Value Formula

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

alpha = 0.9;    % High Precision Radars use a high alpha (close to 1)
beta  = 0.9;    % High Precision Radars use a high beta  (close to 1)

% Update State Equation for position





















