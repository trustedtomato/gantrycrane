clear
clc
close all

addpath('../')
%%
run("GlobalVariables.m");
options = simset('SrcWorkspace', 'current');
sledgeSettledEpsilon = 1.2 / 100; % 1% of 1.2m track length
pendulumSettledEpsilon = deg2rad(15 / 100); % 1% of 15 degrees
set(groot, 'defaultTextInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultAxesFontSize', 24);
set(groot, 'defaultLegendFontSize', 24);
% %% CASCADE WITH PENDULUM INNER SLEDGE OUTER
% %% tune Kp
% figure('Name', 'Cascade Model Inner Loop (Pendulum) Tuning: Kp')
% KpArray = [5, 10, 13, 15, 20];
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     Ki = 0;
%     Kd = 0;
    
%     sim("controllers\CascadeModelPendulumInnerLoopForTuning.slx", 17, options);
%     settledData = getSettledData([angleResponse.time angleResponse.data], pendulumSettledEpsilon);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     grid on
%     % pad Kp so that a value of "5" is displayed as " 5"
%     legendInfo{i} = ['Kp = ' num2str(Kp) ' settling time: ' num2str(settledData.Time, '%.2f')];
%     % legendInfo{i} = sprintf('Kp = %2.2f, settling time = %4.2f', Kp, settledData.Time);
% end

% legend(legendInfo)
% xlabel('Time [s]')
% xlim([0 7])
% ylabel('Angle [deg]')

% %% tune Kd
% figure('Name', 'Cascade Model Inner Loop (Pendulum) Tuning with: tuning Kd, Kp = 13, Ki = 0')
% Kp = 13;
% Ki = 0;
% KdArray = [0, 0.1, 0.5, 1, 2];
% colorMap = turbo(length(KdArray) + 1);
% legendInfo = cell(1, length(KdArray));
% for i = 1:length(KdArray)
%     Kd = KdArray(i);
    
%     sim("controllers\CascadeModelPendulumInnerLoopForTuning.slx", 17, options);
%     settledData = getSettledData([angleResponse.time angleResponse.data], pendulumSettledEpsilon);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     grid on
%     legendInfo{i} = ['Kd = ' num2str(Kd, '%.1f') ' settling time: ' num2str(settledData.Time, '%.2f')];
% end

% legend(legendInfo)
% xlabel('Time [s]')
% xlim([0 3.5])
% ylabel('Angle [deg]')

%% tune both inner and outer loops together
%% non saturated pendulum setpoint
pendulumSetpointLimit = inf;
% %% tune Kp
% figure('Name', 'Cascade Model Both Loops (Pendulum Inner, Sledge Outer) Tuning: Kp')
% subplot(2,1,1);
% % mark the y axis at 0.5m
% yticks([0.2 0.4 0.5 0.6]);
% xlim([0 10]);
% hold on;
% grid on;
% subplot(2,1,2);
% yticks([-20 -15 -10 0 10 15 20]);
% xlim([0 10]);
% hold on;
% grid on;
% KpArray = [0.1, 0.2, 0.35, 0.5, 1, 10];
% Ki = 0;
% Kd = 0;
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     sim("controllers\CascadeModelSledgeOuterPendulumInnerForTuning.slx", 17, options);
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     % sledgeSettledData = getSettledData([positionResponse.time positionResponse.data], 0.1);
%     % angleSettledData = getSettledData([angleResponse.time angleResponse.data], 0.1);
%     % legendInfo{i} = ['Kp = ' num2str(Kp) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data / (180/pi)])) ' sledge settling time: ' num2str(sledgeSettledData.Time) ' sledge final value: ' num2str(sledgeSettledData.FinalValue) ' angle settling time: ' num2str(angleSettledData.Time) ' angle final value: ' num2str(angleSettledData.FinalValue)];
%     legendInfo{i} = ['Kp = ' num2str(Kp, '%.2f') ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]), '%.2f')];
    
% end

% subplot(2,1,1);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Position [m]')
% subplot(2,1,2);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Angle [deg]')

% %% tune Kd
% figure('Name', 'Cascade Model Both Loops (Pendulum Inner, Sledge Outer) Tuning: Kd, Kp = 0.35, Ki = 0')
% subplot(2,1,1);
% yticks([0.2 0.4 0.5 0.6]);
% hold on;
% grid on;
% subplot(2,1,2);
% hold on;
% grid on;
% Kp = 0.35;
% Ki = 0;
% KdArray = [-0.4, -0.3, -0.1, 0, 0.1, 0.2, 0.3, 0.4];
% colorMap = turbo(length(KdArray) + 1);
% legendInfo = cell(1, length(KdArray));
% for i = 1:length(KdArray)
%     Kd = KdArray(i);
%     % sets positionResponse and angleResponse
%     sim("controllers\CascadeModelSledgeOuterPendulumInnerForTuning.slx", 17, options);
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     % sledgeSettledData = getSettledData([positionResponse.time positionResponse.data], 0.1);
%     % angleSettledData = getSettledData([angleResponse.time angleResponse.data], 0.1);
%     % legendInfo{i} = ['Kp = ' num2str(Kp) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data / (180/pi)])) ' sledge settling time: ' num2str(sledgeSettledData.Time) ' sledge final value: ' num2str(sledgeSettledData.FinalValue) ' angle settling time: ' num2str(angleSettledData.Time) ' angle final value: ' num2str(angleSettledData.FinalValue)];
%     legendInfo{i} = ['Kd = ' num2str(Kd, '%.1f') ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]))];
    
% end

% subplot(2,1,1);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Position [m]')
% subplot(2,1,2);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Angle [deg]')

% %% saturated pendulum setpoint
% figure('Name', 'Cascade Model Both Loops (Pendulum Inner, Sledge Outer) Tuning With Saturated Pendulum Setpoint: Kp')
% pendulumSetpointLimit = deg2rad(15);
% subplot(2,1,1);
% hold on;
% grid on;
% subplot(2,1,2);
% hold on;
% grid on;
% KpArray = [0.1, 0.2, 0.35, 0.5, 1, 10];
% Ki = 0;
% Kd = 0;
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     % sets positionResponse and angleResponse
%     sim("controllers\CascadeModelSledgeOuterPendulumInnerForTuning.slx", 17, options);
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     % sledgeSettledData = getSettledData([positionResponse.time positionResponse.data], 0.1);
%     % angleSettledData = getSettledData([angleResponse.time angleResponse.data], 0.1);
%     % legendInfo{i} = ['Kp = ' num2str(Kp) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data / (180/pi)])) ' sledge settling time: ' num2str(sledgeSettledData.Time) ' sledge final value: ' num2str(sledgeSettledData.FinalValue) ' angle settling time: ' num2str(angleSettledData.Time) ' angle final value: ' num2str(angleSettledData.FinalValue)];
%     legendInfo{i} = ['Kp = ' num2str(Kp, '%.2f') ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]), '%.2f')];
    
% end

% subplot(2,1,1);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Position [m]')
% subplot(2,1,2);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Angle [deg]')

% %% tune Kd
% figure('Name', 'Cascade Model Both Loops (Pendulum Inner, Sledge Outer) Tuning With Saturated Pendulum Setpoint: Kd, Kp = 0.35, Ki = 0')
% subplot(2,1,1);
% hold on;
% grid on;
% subplot(2,1,2);
% hold on;
% grid on;
% Kp = 0.35;
% Ki = 0;
% KdArray = [-0.4, -0.3, -0.2, -0.1, -0.01, -0.001, 0, 0.001, 0.01, 0.1, 0.2, 0.3, 0.4];
% colorMap = turbo(length(KdArray) + 1);
% legendInfo = cell(1, length(KdArray));
% for i = 1:length(KdArray)
%     Kd = KdArray(i);
%     % sets positionResponse and angleResponse
%     sim("controllers\CascadeModelSledgeOuterPendulumInnerForTuning.slx", 17, options);
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     % sledgeSettledData = getSettledData([positionResponse.time positionResponse.data], 0.1);
%     % angleSettledData = getSettledData([angleResponse.time angleResponse.data], 0.1);
%     % legendInfo{i} = ['Kp = ' num2str(Kp) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data / (180/pi)])) ' sledge settling time: ' num2str(sledgeSettledData.Time) ' sledge final value: ' num2str(sledgeSettledData.FinalValue) ' angle settling time: ' num2str(angleSettledData.Time) ' angle final value: ' num2str(angleSettledData.FinalValue)];
%     legendInfo{i} = ['Kd = ' num2str(Kd) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]))];
    
% end

% subplot(2,1,1);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Position [m]')
% subplot(2,1,2);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Angle [deg]')


%% CASCADE WITH SLEDGE INNER PENDULUM OUTER
%% tune Kp
% figure('Name', 'Cascade Model Inner Loop (Sledge) Tuning: Kp')
% KpArray = [50, 100, 200, 330, 500, 1000];
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     Ki = 0;
%     Kd = 0;
    
%     sim("controllers\CascadeModelSledgeInnerLoopForTuning.slx", 17, options);
%     settledData = getSettledData([positionResponse.time positionResponse.data], sledgeSettledEpsilon);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     grid on
%     % legendInfo{i} = ['Kp = ' num2str(Kp) ' settling time (1%): ' num2str(settledData.Time, '%.2f')];
%     legendInfo{i} = ['Kp = ' num2str(Kp) ' settling time: ' num2str(settledData.Time, '%.2f')];
%     % legendInfo{i} = sprintf('Kp = %2.2f, settling time = %4.2f', Kp, settledData.Time);
% end

% legend(legendInfo)
% xlabel('Time [s]')
% xlim([1 2])
% ylabel('Position [m]')
% ylim([0.45 0.52])

% %% tune Kd
% figure('Name', 'Cascade Model Inner Loop (Sledge) Tuning: Kd, Kp = 330')
% Kp = 330;
% Ki = 0;
% KdArray = [0, 0.1, 0.5, 1, 1.5, 2];
% colorMap = turbo(length(KdArray) + 1);
% legendInfo = cell(1, length(KdArray));
% for i = 1:length(KdArray)
%     Kd = KdArray(i);
    
%     sim("controllers\CascadeModelSledgeInnerLoopForTuning.slx", 17, options);
%     settledData = getSettledData([positionResponse.time positionResponse.data], sledgeSettledEpsilon * 0.1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     grid on
%     legendInfo{i} = ['Kd = ' num2str(Kd, '%.1f') ', settling time (0.1\%): ' num2str(settledData.Time)];
%     % legendInfo{i} = sprintf('Kp = %2.2f, settling time = %4.2f', Kp, settledData.Time);
% end

% legend(legendInfo)
% xlabel('Time [s]')
% xlim([1.1 1.3])
% ylim([0.49 0.502])
% ylabel('Position [m]')

%% tune both inner and outer loops together (pendulum outer, sledge inner)
%% tune Kp
figure('Name', 'Cascade Model Both Loops (Sledge Inner, Pendulum Outer) Tuning: Kp')
subplot(2,1,1);
yticks([0 0.2 0.4 0.5 0.6])
hold on;
grid on;
subplot(2,1,2);
yticks([-15 -5 0 5 15])
hold on;
grid on;
% KpArray = [0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5];
KpArray = [0, 1, 2, 3];
Ki = 0;
Kd = 0;
colorMap = turbo(length(KpArray) + 1);
legendInfo = cell(1, length(KpArray));
for i = 1:length(KpArray)
    Kp = KpArray(i);
    sim("controllers\CascadeModelPendulumOuterSledgeInnerForTuning.slx", 17, options);
    subplot(2,1,1);
    hold on
    plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
    subplot(2,1,2);
    hold on
    plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
    % sledgeSettledData = getSettledData([positionResponse.time positionResponse.data], 0.1);
    % angleSettledData = getSettledData([angleResponse.time angleResponse.data], 0.1);
    % legendInfo{i} = ['Kp = ' num2str(Kp) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data / (180/pi)])) ' sledge settling time: ' num2str(sledgeSettledData.Time) ' sledge final value: ' num2str(sledgeSettledData.FinalValue) ' angle settling time: ' num2str(angleSettledData.Time) ' angle final value: ' num2str(angleSettledData.FinalValue)];
    % legendInfo{i} = ['Kp = ' num2str(Kp, '%.4f') ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]), '%.2f')];
    legendInfo{i} = ['Kp = ' num2str(Kp, '%.1f') ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]), '%.2f')];
    
end

subplot(2,1,1);
legend(legendInfo)
xlabel('Time [s]')
xlim([0 5])
ylabel('Position [m]')
subplot(2,1,2);
legend(legendInfo)
xlabel('Time [s]')
xlim([0 5])
ylabel('Angle [deg]')

%% tune Kd
figure('Name', 'Cascade Model Both Loops (Sledge Inner, Pendulum Outer) Tuning: Kd, Kp = 0.05, Ki = 0')
subplot(2,1,1);
xlabel('Time [s]')
ylabel('Position [m]')
yticks([0 0.2 0.4 0.5 0.6])
xlim([0 6])
hold on;
grid on;

subplot(2,1,2);
xlabel('Time [s]')
ylabel('Angle [deg]')
xlim([0 6])
yticks([-5 0 5 10 15])
hold on;
grid on;
Kp = 2;
Ki = 0;
KdArray = [0, 0.1, 0.2, 0.3];
colorMap = turbo(length(KdArray) + 1);
legendInfo = cell(1, length(KdArray));
for i = 1:length(KdArray)
    Kd = KdArray(i);
    sim("controllers\CascadeModelPendulumOuterSledgeInnerForTuning.slx", 17, options);
    subplot(2,1,1);
    hold on
    plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
    subplot(2,1,2);
    hold on
    plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
    % sledgeSettledData = getSettledData([positionResponse.time positionResponse.data], 0.1);
    % angleSettledData = getSettledData([angleResponse.time angleResponse.data], 0.1);
    % legendInfo{i} = ['Kp = ' num2str(Kp) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data / (180/pi)])) ' sledge settling time: ' num2str(sledgeSettledData.Time) ' sledge final value: ' num2str(sledgeSettledData.FinalValue) ' angle settling time: ' num2str(angleSettledData.Time) ' angle final value: ' num2str(angleSettledData.FinalValue)];
    legendInfo{i} = ['Kd = ' num2str(Kd) ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data]))];
    
end

subplot(2,1,1);
legend(legendInfo)
subplot(2,1,2);
legend(legendInfo)


function settledData = getSettledData(response, epsilon)
    flippedResponse = flipud(response);
    settledData = struct('Time', 0, 'FinalValue', flippedResponse(1, 2));
    minimumValue = flippedResponse(1, 2);
    maximumValue = flippedResponse(1, 2);

    for i = 2:length(flippedResponse)
        row = flippedResponse(i, :);
        if minimumValue > row(2)
            minimumValue = row(2);
        elseif maximumValue < row(2)
            maximumValue = row(2);
        end
    
        if abs(maximumValue - minimumValue) > epsilon
            settledData.Time = row(1);
            return 
        end
    end
end