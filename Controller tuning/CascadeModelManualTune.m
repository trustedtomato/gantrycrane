clear
clc
close all

addpath('../')
%%
run("GlobalVariables.m");
global pendulumNoise;
pendulumNoise = load("Results\\goodNoisyAngleResponse2min.mat").angleResponse;
pendulumNoise = pendulumNoise + 0.0065;
options = simset('SrcWorkspace', 'current');
global sledgeSettledEpsilon pendulumSettledEpsilon;
sledgeSettledEpsilon = 1.2 / 100; % 1% of 1.2m track length
pendulumSettledEpsilon = deg2rad(15 * 5/100); % 5% of 15 degrees
set(groot, 'defaultTextInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultAxesFontSize', 24);
set(groot, 'defaultLegendFontSize', 24);


% %% CASCADE WITH PENDULUM INNER SLEDGE OUTER
% %% tune Kp
% figure('Name', 'Cascade Model Inner Loop (Pendulum) Tuning: Kp')
% KpArray = [5, 15, 30, 50, 75];
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));


% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     Ki = 0;
%     Kd = 0;
%     angleResponse = getMeanSimulation(@simPendIn, @(response) fitnessPendIn(response, 0, pendulumSettledEpsilon), 10);
%     % angleResponse = getMeanSimulation(@simPendIn, @(response) fitnessPendIn(response, pendulumSettledEpsilon), 10);

%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     grid on
%     settledData = getPendulumSettledData([angleResponse.time angleResponse.data], 0, pendulumSettledEpsilon);
%     % settledData = getPendulumSettledData([angleResponse.time angleResponse.data], pendulumSettledEpsilon);
%     legendInfo{i} = ['Kp = ' num2str(Kp) ' settling time: ' num2str(settledData.Time, '%.2f')];
% end

% legend(legendInfo)
% xlabel('Time [s]')
% xlim([0 2])
% % yticks([-15 -10 -5 -0.75 0 0.75 5 10 15])
% yticks([-15 -10 -5 0 5 10 15])
% yline(0.75, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% yline(-0.75, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% ylabel('Angle [deg]')

% %% tune Kd
% figure('Name', 'Cascade Model Inner Loop (Pendulum) Tuning with: tuning Kd, Kp = 35, Ki = 0')
% Kp = 35;
% Ki = 0;
% KdArray = [0, 0.0001, 0.001, 0.01, 0.1];
% colorMap = turbo(length(KdArray) + 1);
% legendInfo = cell(1, length(KdArray));
% for i = 1:length(KdArray)
%     Kd = KdArray(i);
%     angleResponse = getMeanSimulation(@simPendIn, @(response) fitnessPendIn(response, pendulumSettledEpsilon), 10);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     grid on
%     settledData = getPendulumSettledData([angleResponse.time angleResponse.data], pendulumSettledEpsilon);
%     legendInfo{i} = ['Kd = ' num2str(Kd, '%.4f') ' settling time: ' num2str(settledData.Time, '%.2f')];
% end

% legend(legendInfo)
% xlabel('Time [s]')
% xlim([0 17])
% ylabel('Angle [deg]')

%% tune both inner and outer loops together
%% non saturated pendulum setpoint
pendulumSetpointLimit = inf;
% %% tune Kp
% figure('Name', 'Cascade Model Both Loops (Pendulum Inner, Sledge Outer) Tuning: Kp')
% % KpArray = [0.05, 0.10, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1];
% KpArray = [0.05, 0.15, 0.25, 0.5, 0.75, 1];
% Ki = 0;
% Kd = 0;
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     responses = getMeanSimulation(@simPendInSledgeOut, @fitnessPendInSledgeOut, 10);
%     positionResponse = responses.positionResponse;
%     angleResponse = responses.angleResponse;
    
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     legendInfo{i} = ['Kp = ' num2str(Kp, '%.2f') ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data], @getSledgeSettledData, @getPendulumSettledData), '%.2f')];
    
% end

% subplot(2,1,1);
% yline(0.55, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% yticks([0.2 0.4 0.5 0.6]);
% xlim([0 8]);
% grid on;
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Position [m]')
% subplot(2,1,2);
% yline(0.75, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% yline(-0.75, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% yticks([-15 -10 -5 0 5 10 15])
% xlim([0 8]);
% grid on;
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Angle [deg]')


% %% tune Ki
% figure('Name', 'Cascade Model Both Loops (Pendulum Inner, Sledge Outer) Tuning: Kd, Kp = 0.35, Ki = 0')
% Kp = 0.15;
% KiArray = [0, 0.001, 0.002, 0.003, 0.004];
% Kd = 0;
% colorMap = turbo(length(KiArray) + 1);
% legendInfo = cell(1, length(KiArray));
% for i = 1:length(KiArray)
%     Ki = KiArray(i);
%     responses = getMeanSimulation(@simPendInSledgeOut, @fitnessPendInSledgeOut, 10);
%     positionResponse = responses.positionResponse;
%     angleResponse = responses.angleResponse;
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     legendInfo{i} = ['Ki = ' num2str(Ki, '%.3f') ' fitness: ' num2str(getFitness([positionResponse.time positionResponse.data], 0.5, [angleResponse.time angleResponse.data], @getSledgeSettledData, @getPendulumSettledData), '%.2f')];
% end

% subplot(2,1,1);
% grid on;
% yticks([0.2 0.4 0.5 0.6]);
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Position [m]')

% subplot(2,1,2);
% grid on;
% legend(legendInfo)
% xlabel('Time [s]')
% ylabel('Angle [deg]')

% %% tune Kd
% figure('Name', 'Cascade Model Both Loops (Pendulum Inner, Sledge Outer) Tuning: Kd, Kp = 0.35, Ki = 0')
% Kp = 0.25;
% Ki = 0;
% KdArray = [0, 0.01, 0.02, 0.03, 0.04];
% colorMap = turbo(length(KdArray) + 1);
% legendInfo = cell(1, length(KdArray));
% for i = 1:length(KdArray)
%     Kd = KdArray(i);
%     % sets positionResponse and angleResponse
%     [responses, fitness] = getMeanSimulation(@simPendInSledgeOut, @fitnessPendInSledgeOut, 10);
%     positionResponse = responses.positionResponse;
%     angleResponse = responses.angleResponse;
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     legendInfo{i} = ['Kd = ' num2str(Kd, '%.3f') ' fitness: ' num2str(fitness, '%.2f')];
% end

% subplot(2,1,1);
% % yticks([0.2 0.4 0.5 0.6]);
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
%     % sledgeSettledData = getPendulumSettledData([positionResponse.time positionResponse.data], 0.1);
%     % angleSettledData = getPendulumSettledData([angleResponse.time angleResponse.data], 0.1);
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
%     % sledgeSettledData = getPendulumSettledData([positionResponse.time positionResponse.data], 0.1);
%     % angleSettledData = getPendulumSettledData([angleResponse.time angleResponse.data], 0.1);
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


% %% CASCADE WITH SLEDGE INNER PENDULUM OUTER
% %% tune Kp
% figure('Name', 'Cascade Model Inner Loop (Sledge) Tuning: Kp')
% KpArray = [50, 100, 200, 300, 500, 1000];
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     Ki = 0;
%     Kd = 0;

%     positionResponse = getMeanSimulation(@simSledgeIn, @(response) fitnessSledgeIn(response, sledgeSettledEpsilon), 1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
    
%     settledData = getSledgeSettledData([positionResponse.time positionResponse.data], sledgeSettledEpsilon);
%     legendInfo{i} = ['Kp = ' num2str(Kp) ' settling time: ' num2str(settledData.Time, '%.2f')];
% end

% grid on
% legend(legendInfo)
% xlabel('Time [s]')
% xlim([1 2])
% ylabel('Position [m]')
% ylim([0.45 0.52])

% %% tune Ki
% figure('Name', 'Cascade Model Inner Loop (Sledge) Tuning: Ki, Kp = 300')

% KiArray = [0, 0.25, 1];
% colorMap = turbo(length(KiArray) + 1);
% legendInfo = cell(1, length(KiArray));
% for i = 1:length(KiArray)
%     Kp = 300;
%     Ki = KiArray(i);
%     Kd = 0;

%     positionResponse = getMeanSimulation(@simSledgeIn, @(response) fitnessSledgeIn(response, sledgeSettledEpsilon), 1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
    
%     settledData = getSledgeSettledData([positionResponse.time positionResponse.data], sledgeSettledEpsilon);
%     legendInfo{i} = ['Ki = ' num2str(Ki) ' settling time: ' num2str(settledData.Time, '%.2f')];
% end

% grid on
% legend(legendInfo)
% xlabel('Time [s]')
% xlim([1.1 1.5])
% ylabel('Position [m]')
% ylim([0.490 0.502])

% %% tune Kd
% figure('Name', 'Cascade Model Inner Loop (Sledge) Tuning: Kd, Kp = 300, Ki = 0.25')
% KdArray = [-0.5, 0, 0.1, 0.5, 1, 1.5, 2, 10];
% colorMap = turbo(length(KdArray) + 1);
% legendInfo = cell(1, length(KdArray));
% for i = 1:length(KdArray)
%     Kp = 300;
%     Ki = 0.25;
%     Kd = KdArray(i);
%     
%     positionResponse = getMeanSimulation(@simSledgeIn, @(response) fitnessSledgeIn(response, sledgeSettledEpsilon), 1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     
%     settledData = getSledgeSettledData([positionResponse.time positionResponse.data], sledgeSettledEpsilon);
%     legendInfo{i} = ['Kd = ' num2str(Kd) ' settling time: ' num2str(settledData.Time, '%.2f')];
% end
% 
% grid on
% legend(legendInfo)
% xlabel('Time [s]')
% xlim([1.1 1.3])
% ylim([0.49 0.502])
% ylabel('Position [m]')

% tune both inner and outer loops together (pendulum outer, sledge inner)
%% tune Kp
% figure('Name', 'Cascade Model Both Loops (Sledge Inner, Pendulum Outer) Tuning: Kp')
% KpArray = [0.5, 1.5, 2, 5, 7];
% % KpArray = [0, 1, 2, 3];
% Ki = 0;
% Kd = 0;
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     [responses, fitness] = getMeanSimulation(@simSledgeInPendOut, @fitnessSledgeInPendOut, 10);
%     positionResponse = responses.positionResponse;
%     angleResponse = responses.angleResponse;
    
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
%     legendInfo{i} = ['Kp = ' num2str(Kp, '%.2f') ' fitness: ' num2str(fitness, '%.2f')];
    
% end

% subplot(2,1,1);
% grid on;
% legend(legendInfo)
% xlabel('Time [s]')
% xlim([0 8])
% yline(0.5, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% ylabel('Position [m]')
% subplot(2,1,2);
% grid on;
% yticks([-15 -10 -5 0 5 10 15])
% yline(0.75, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% yline(-0.75, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% legend(legendInfo)
% xlabel('Time [s]')
% xlim([0 8])
% ylabel('Angle [deg]')

%% tune Ki
figure('Name', 'Cascade Model Both Loops (Sledge Inner, Pendulum Outer) Tuning: Kd, Kp = 2, Ki = 0')

Kp = 2;
KiArray = [0, 0.001, 0.01, 0.1, 1];
Kd = 0;
colorMap = turbo(length(KiArray) + 1);
legendInfo = cell(1, length(KiArray));
for i = 1:length(KiArray)
    Ki = KiArray(i);
    [responses, fitness] = getMeanSimulation(@simSledgeInPendOut, @fitnessSledgeInPendOut, 10);
    positionResponse = responses.positionResponse;
    angleResponse = responses.angleResponse;
    subplot(2,1,1);
    hold on
    plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
    subplot(2,1,2);
    hold on
    plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
    legendInfo{i} = ['Ki = ' num2str(Ki) ' fitness: ' num2str(fitness, '%.2f')];
    
end

subplot(2,1,1);
grid on;
yline(0.5, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
legend(legendInfo)
subplot(2,1,2);
grid on;
legend(legendInfo)
xlabel('Time [s]')
ylabel('Angle [deg]')

%% retune sledge inner
% %% tune Kp
% figure('Name', 'Cascade Model Inner Loop (Sledge) Re-Tuning: Kp')
% KpArray = [1, 2, 5, 8, 9, 10];
% colorMap = turbo(length(KpArray) + 1);
% legendInfo = cell(1, length(KpArray));
% for i = 1:length(KpArray)
%     Kp = KpArray(i);
%     Ki = 0;
%     Kd = 0;

%     [results, fitness] = getMeanSimulation(@simSledgeInRetune, @(results) fitnessSledgeIn(results.positionResponse), 1);
%     positionResponse = results.positionResponse;
%     angleResponse = results.angleResponse;
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
    
%     % settledData = getSledgeSettledData([positionResponse.time positionResponse.data], sledgeSettledEpsilon);
%     legendInfo{i} = ['Kp = ' num2str(Kp) ' settling time: ' num2str(fitness, '%.2f')];
% end

% subplot(2,1,1);
% grid on
% legend(legendInfo)
% xlabel('Time [s]')
% xlim([0 6])
% ylabel('Position [m]')
% subplot(2,1,2);
% legend(legendInfo)
% grid on
% xlabel('Time [s]')
% xlim([0 6])
% ylabel('Angle [$^\circ$]')
% yline(15, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% yline(-15, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')

% %% tune Ki
% figure('Name', 'Cascade Model Inner Loop (Sledge) Re-Tuning: Ki, Kp = 8')
% KiArray = [0, 0.16, 0.2];
% colorMap = turbo(length(KiArray) + 1);
% legendInfo = cell(1, length(KiArray));
% for i = 1:length(KiArray)
%     Kp = 8;
%     Ki = KiArray(i);
%     Kd = 0;

%     [results, fitness] = getMeanSimulation(@simSledgeInRetune, @(results) fitnessSledgeIn(results.positionResponse), 1);
%     positionResponse = results.positionResponse;
%     angleResponse = results.angleResponse;
%     subplot(2,1,1);
%     hold on
%     plot(positionResponse.time, positionResponse.data, 'Color', colorMap(i, :))
%     subplot(2,1,2);
%     hold on
%     plot(angleResponse.time, angleResponse.data * (180/pi), 'Color', colorMap(i, :))
    
%     % settledData = getSledgeSettledData([positionResponse.time positionResponse.data], sledgeSettledEpsilon);
%     legendInfo{i} = ['Ki = ' num2str(Ki) ' settling time: ' num2str(fitness, '%.2f')];
% end

% subplot(2,1,1);
% grid on
% legend(legendInfo)
% xlabel('Time [s]')
% xlim([3 7])
% ylim([0.47 0.51])
% ylabel('Position [m]')
% subplot(2,1,2);
% legend(legendInfo)
% grid on
% xlabel('Time [s]')
% xlim([0 17])
% ylabel('Angle [$^\circ$]')
% yline(15, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')
% yline(-15, '--r', 'LineWidth', 1, 'HandleVisibility', 'off')


function fitness = getFitness(sledgeResponse, sledgeSetPoint, pendulumResponse)
    overshoot = max(abs(sledgeResponse(:, 2))) - abs(sledgeSetPoint);
    maxAngleValue = max(abs(pendulumResponse(:, 2)));
    
    sledgeSettledEpsilon = 1.2 / 100; % 1% of 1.2m track length
    pendulumSettledEpsilon = deg2rad(15 / 100); % 1% of 15 degrees

    settledDataSledge = getSledgeSettledData(sledgeResponse);
    settledDataPendulum = getPendulumSettledData(pendulumResponse);

    sledgeError = abs(settledDataSledge.FinalValue - sledgeSetPoint);


    %The way that I arrived at these values was that I thought about what
    %would correspond to a fitness of 1. So 15??, 15 seconds to settle
    %the sledge and 20 seconds to settle the pendulum.
    angleFactor = 1/deg2rad(15); 
    timeFactorSledge = 1/10;
    timeFactorPendulum = 1/10;
    overshootFactor = 1/0.05;
    sledgeErrorFactor = 1/0.02;
    
    if maxAngleValue > deg2rad(15)
        disp('went over max angle')
        angleFactor = angleFactor * 1000;
    end
    if overshoot > 0.05
        disp('went over overshoot limit')
        overshootFactor = 100000 * overshootFactor; 
    end
    if settledDataSledge.Time > 15
        disp('took too long to settle sledge')
        timeFactorSledge = 1000 * timeFactorSledge;
    end
    if settledDataPendulum.Time > 15
        disp('took too long to settle pendulum')
        timeFactorPendulum = 1000 * timeFactorPendulum;
    end
    if sledgeError > 0.02
        disp('sledge steady state error too high')
        sledgeErrorFactor = 1000 * sledgeErrorFactor;
    end


    %timeToSettle is a function that will calculate the time it takes
        %for the response to settle
    fitness = settledDataSledge.Time * timeFactorSledge + ...
        settledDataPendulum.Time * timeFactorPendulum +...
        maxAngleValue * angleFactor +...
        overshootFactor * overshoot +...
        sledgeErrorFactor * sledgeError;
end

function settledData = getPendulumSettledData(response)
    global pendulumSettledEpsilon;
    flippedResponse = flipud(response);
    settledData = struct('Time', 0, 'FinalValue', flippedResponse(1, 2));

    for i = 2:length(flippedResponse)
        if abs(flippedResponse(i, 2) - 0) > pendulumSettledEpsilon
            settledData.Time = flippedResponse(i, 1);
            break;
        end
    end
end

function settledData = getSledgeSettledData(response)
    global sledgeSettledEpsilon;
    flippedResponse = flipud(response);
    finalValue = flippedResponse(1, 2);
    settledData = struct('Time', 0, 'FinalValue', finalValue);

    for i = 2:length(flippedResponse)
        if abs(flippedResponse(i, 2) - finalValue) > sledgeSettledEpsilon
            settledData.Time = flippedResponse(i, 1);
            break;
        end
    end
end


function [meanSimulation, meanFitness] = getMeanSimulation(simulationFunction, fitnessFunction, numberOfSimulations)
    simulations = cell(1, numberOfSimulations);
    fitnesses = zeros(1, numberOfSimulations);
    for i = 1:numberOfSimulations
        simulations{i} = simulationFunction();
        fitnesses(i) = fitnessFunction(simulations{i});
    end
    
    [~, meanFitnessIndex] = min(abs(fitnesses - mean(fitnesses)));
    meanSimulation = simulations{meanFitnessIndex};
    meanFitness = fitnesses(meanFitnessIndex);
end


function results = simPendIn()
    global pendulumNoise;
    options = simset('SrcWorkspace', 'base');
    randomStartIndex = randi([1, 12000-1700]);
    recordedNoise = timeseries(pendulumNoise.Data(randomStartIndex:(randomStartIndex + 1700)), [0:0.01:17]);
    assignin('base', 'recordedNoise', recordedNoise);
    sim("controllers\CascadeModelPendulumInnerLoopForTuning.slx", 17, options);
    results = angleResponse;
end
function fitness = fitnessPendIn(results, setpoint, epsilon)
% function fitness = fitnessPendIn(results, epsilon)
    settledData = getPendulumSettledData([results.time results.data], setpoint, epsilon);
    % settledData = getPendulumSettledData([results.time results.data], epsilon);
    fitness = settledData.Time;
end


function results = simSledgeIn()
    global pendulumNoise;
    options = simset('SrcWorkspace', 'base');
    randomStartIndex = randi([1, 12000-1700]);
    recordedNoise = timeseries(pendulumNoise.Data(randomStartIndex:(randomStartIndex + 1700)), [0:0.01:17]);
    assignin('base', 'recordedNoise', recordedNoise);
    sim("controllers\CascadeModelSledgeInnerLoopForTuning.slx", 17, options);
    results = positionResponse;
end
function fitness = fitnessSledgeIn(results)
    settledData = getSledgeSettledData([results.time results.data]);
    fitness = settledData.Time;
end

function results = simSledgeInRetune()
    global pendulumNoise;
    options = simset('SrcWorkspace', 'base');
    randomStartIndex = randi([1, 12000-1700]);
    recordedNoise = timeseries(pendulumNoise.Data(randomStartIndex:(randomStartIndex + 1700)), [0:0.01:17]);
    assignin('base', 'recordedNoise', recordedNoise);
    sim("controllers\CascadeModelSledgeInnerLoopForTuning.slx", 17, options);
    results = struct('positionResponse', positionResponse, 'angleResponse', angleResponse);
end


function results = simPendInSledgeOut()
    global pendulumNoise;
    options = simset('SrcWorkspace', 'base');
    randomStartIndex = randi([1, 12000-1700]);
    recordedNoise = timeseries(pendulumNoise.Data(randomStartIndex:(randomStartIndex + 1700)), [0:0.01:17]);
    assignin('base', 'recordedNoise', recordedNoise);
    sim("controllers\CascadeModelSledgeOuterPendulumInnerForTuning.slx", 17, options);
    results = struct('positionResponse', positionResponse, 'angleResponse', angleResponse);
end
function fitness = fitnessPendInSledgeOut(results)
    fitness = getFitness([results.positionResponse.time results.positionResponse.data], 0.5, [results.angleResponse.time results.angleResponse.data]);
end


function results = simSledgeInPendOut()
    global pendulumNoise;
    options = simset('SrcWorkspace', 'base');
    randomStartIndex = randi([1, 12000-1700]);
    recordedNoise = timeseries(pendulumNoise.Data(randomStartIndex:(randomStartIndex + 1700)), [0:0.01:17]);
    assignin('base', 'recordedNoise', recordedNoise);
    sim("controllers\CascadeModelPendulumOuterSledgeInnerForTuning.slx", 17, options);
    results = struct('positionResponse', positionResponse, 'angleResponse', angleResponse);
end
function fitness = fitnessSledgeInPendOut(results)
    fitness = getFitness([results.positionResponse.time results.positionResponse.data], 0.5, [results.angleResponse.time results.angleResponse.data]);
end
