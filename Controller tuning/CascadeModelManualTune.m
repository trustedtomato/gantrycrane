clear
clc

addpath('../')
%%
run("GlobalVariables.m");
options = simset('SrcWorkspace', 'current');

figure(1)
KpArray = [1, 10, 50, 100, 200, 250, 330, 500, 1000];
colorMap = turbo(length(KpArray));
legendInfo = cell(1, length(KpArray));
for i = 1:length(KpArray)
    Kp = KpArray(i);
    Ki = 0;
    Kd = 0;
    
    % sets positionResponse
    sim("controllers\CascadeModelInnerLoopForTuning.slx", 17, options);
    hold on
    % plot positionResponse on the same figure
    plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
    grid on
    % add legend
    legendInfo{i} = ['Kp = ' num2str(Kp)];
end

% add legend to plot
legend(legendInfo)
% add labels to plot
xlabel('Time [s]')
ylabel('Position [m]')

figure(2)
subplot(2,1,1);
hold on;
grid on;
subplot(2,1,2);
hold on;
grid on;
KpArray = [0.00001, 0.0001, 0.001, 0.01, 0.1];
colorMap = turbo(length(KpArray));
legendInfo = cell(1, length(KpArray));
for i = 1:length(KpArray)
    Kp = KpArray(i);
    Ki = 0;
    
    % sets positionResponse and angleResponse
    sim("controllers\CascadeModelBothLoopsForTuning.slx", 17, options);
    subplot(2,1,1);
    hold on
    % plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
    plot(positionResponse.time, positionResponse.data)
    subplot(2,1,2);
    hold on
    % plot(angleResponse.time, angleResponse.data, 'Color', colorMap(i, :))
    plot(angleResponse.time, angleResponse.data)
    % add legend containing the Kp values and the fitness values through getFitness
    legendInfo{i} = ['Kp = ' num2str(Kp) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]))];
    
end

subplot(2,1,1);
% add legend to plot
legend(legendInfo)
% add labels to plot
xlabel('Time [s]')
ylabel('Position [m]')
subplot(2,1,2);
% add legend to plot
legend(legendInfo)
% add labels to plot
xlabel('Time [s]')
ylabel('Angle [deg]')