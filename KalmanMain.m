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
close all;
clear all;

alpha = 0.9;    % High Precision Radars use a high alpha (close to 1)
beta  = 0.9;    % High Precision Radars use a high beta  (close to 1)

% Making the Data
Time = 0:1:50;

Truth.Velocity      = 40;
Truth.InitPosition  = 30e3;
Truth.Postion       = zeros(size(Time,2), 1);

for i = 1:size(Time,2)
    Truth.Postion(i) = Truth.Velocity * Time(i) + Truth.InitPosition;
end

NoiseScale          = 400;
Measured.Positon    = Truth.Postion + NoiseScale.*(rand(size(Time, 2), 1) - 0.5);



figure;
hold on;
plot(Time, Truth.Postion,'LineWidth', 1.5,'LineStyle', '--')
plot(Time, Measured.Positon, 'LineWidth', 1.5)
hold off;
grid on;
xlabel('Time (s)')
ylabel('Position (m)')
legend("Truth", "Measured");
ax = gca;
ax.FontSize = 14;
ylim([Truth.InitPosition Truth.Postion(end)])

















