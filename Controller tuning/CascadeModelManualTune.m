clear
clc

addpath('../')
%%
run("GlobalVariables.m");
% load('../Results/NoisyAngleResponse.mat');
options = simset('SrcWorkspace', 'current');


KpArray = [0, 1, 10, 25, 33, 45, 75, 100, 200];
colorMap = turbo(length(KpArray));
legendInfo = cell(1, length(KpArray));
for i = 1:length(KpArray)
    Kp = KpArray(i);
    Ki = 0;
    
    % sets angleResponse
    sim("controllers\CascadeModelInnerLoopForTuning.slx", 17, options);
    hold on
    % plot angleResponse on the same figure
    plot(angleResponse.time, angleResponse.data, 'Color', colorMap(i, :))
    grid on
    % add legend
    legendInfo{i} = ['Kp = ' num2str(Kp)];
end

% add legend to plot
legend(legendInfo)
% add labels to plot
xlabel('Time [s]')
ylabel('Angle [deg]')