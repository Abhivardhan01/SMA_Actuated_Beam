function PostProcessing(Optimization)

Cases = {'Cantilever','SimplySupported'};

%% Temperature vs Recovery Strain

figure

hold on

for i = 1:length(Cases)

    BC = Cases{i};

    plot( ...
        Optimization.(BC).Temperature,...
        Optimization.(BC).epsT,...
        'LineWidth',2);

end

xlabel('Temperature (^oC)')

ylabel('Recovery Strain')

legend(Cases)

grid on

title('Temperature vs Recovery Strain')

%% Temperature vs Optimal Location

figure

hold on

for i = 1:length(Cases)

    BC = Cases{i};

    plot( ...
        Optimization.(BC).Temperature,...
        Optimization.(BC).Xopt(:,1),...
        'LineWidth',2);

end

xlabel('Temperature (^oC)')

ylabel('Optimal SMA Location, x_1 (m)')

legend(Cases)

grid on

title('Temperature vs Optimal SMA Location')

%% Temperature vs Optimal Length

figure

hold on

for i = 1:length(Cases)

    BC = Cases{i};

    plot( ...
        Optimization.(BC).Temperature,...
        Optimization.(BC).Xopt(:,2),...
        'LineWidth',2);

end

xlabel('Temperature (^oC)')

ylabel('Optimal SMA Length, l (m)')

legend(Cases)

grid on

title('Temperature vs Optimal SMA Length')

%% Temperature vs Objective Function

figure

hold on

for i = 1:length(Cases)

    BC = Cases{i};

    plot( ...
        Optimization.(BC).Temperature,...
        Optimization.(BC).Jmin,...
        'LineWidth',2);

end

xlabel('Temperature (^oC)')

ylabel('Minimum Objective')

legend(Cases)

grid on

title('Temperature vs Minimum Objective')

%% Summary Table

fprintf('\n');
fprintf('============================================================\n');
fprintf('OPTIMIZATION RESULTS\n');
fprintf('============================================================\n\n');

for i = 1:length(Cases)

    BC = Cases{i};

    fprintf('%s\n',BC);

    fprintf('------------------------------------------------------------\n');

    fprintf('%8s %12s %12s %15s\n',...
        'Temp',...
        'x1',...
        'Length',...
        'Objective');

    for k = 1:length(Optimization.(BC).Temperature)

        fprintf('%8.2f %12.5f %12.5f %15.6e\n',...
            Optimization.(BC).Temperature(k),...
            Optimization.(BC).Xopt(k,1),...
            Optimization.(BC).Xopt(k,2),...
            Optimization.(BC).Jmin(k));

    end

    fprintf('\n');

end

end