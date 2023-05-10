clear
clc
close all

addpath('../')
run("../GlobalVariables.m");
set(groot, 'defaultTextInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultLegendFontSize', 12);

% % %%
% % try
% %     fileID = fopen('bestCascadeGene_SledgeOuterPendulumInner.bin');
% %     initialGene = fread(fileID, [1 6], 'double');
% %     fclose(fileID);
% % catch ME
% %     initialGene = [1 1 1 1 1 1];
% % end
% 
% 
% % initialGene = [0.25 0 0.0001 30 0 0.0001]; % best sledge outer pendulum inner manually tuned values
% initialGene = [1 1 1 1 1 1];
populationSize = 100;
generations = 100;
global fitnesses Nth everyNthGenerationsBestGenes sledgeOuterPendulumInner;
fitnesses = zeros(1, generations);
Nth = 20;
everyNthGenerationsBestGenes = zeros(generations/Nth, 6);
sledgeOuterPendulumInner = true;
% 
% %% Optimize cascade controller with Sledge as outer loop and Pendulum as inner loop
% optimizedGene = optimizeGene(initialGene, populationSize, generations, @fitnessFunction, @logBestGene);
% 
% %% Run and plot the response with optimized gene
% options = simset('SrcWorkspace', 'current');
% newValues = num2cell(optimizedGene);
% [OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};
% 
% setPoint = 0.5;
% 
% % sets positionResponse and angleResponse
% recordedNoise = getRecordedNoise();
% sim("../controllers/CascadeModelSledgeOuterPendulumInnerForGeneticTuning", 17, options);
% 
% fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
% 
% figure('Name', 'Cascade Model Sledge Outer Pendulum Inner Genetic Tuning Best Gene Response');
% subplot(2,1,1);
% plot(positionResponse.Time, positionResponse.Data);
% xlabel('Time [s]')
% ylabel('Position [m]')
% grid on
% subplot(2,1,2);
% plot(angleResponse.Time, angleResponse.Data.*(180/pi));
% xlabel('Time [s]')
% ylabel('Angle [deg]')
% grid on
% % plot the best fitness for each generation
% figure('Name', 'Cascade Model Sledge Outer Pendulum Inner Genetic Tuning Best Fitnesses for Each Generation');
% plot(fitnesses);
% xlabel('Generation')
% ylabel('Fitness')
% grid on
% % plot the best gene for every Nth generation
% figure('Name', 'Cascade Model Sledge Outer Pendulum Inner Genetic Tuning Best Genes for Every Nth Generation');
% legendInfo = cell(1, length(generations/Nth));
% for i = 1:generations/Nth
%     newValues = num2cell(everyNthGenerationsBestGenes(i,:));
%     [OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};
%     setPoint = 0.5;
%     recordedNoise = getRecordedNoise();
%     sim("../controllers/CascadeModelSledgeOuterPendulumInnerForGeneticTuning", 17, options);
%     subplot(2,1,1);
%     hold on;
%     plot(positionResponse.Time, positionResponse.Data);
%     xlabel('Time [s]')
%     ylabel('Position [m]')
%     grid on
%     subplot(2,1,2);
%     hold on;
%     plot(angleResponse.Time, angleResponse.Data.*(180/pi));
%     xlabel('Time [s]')
%     ylabel('Angle [deg]')
%     grid on
%     legendInfo{i} = "Generation " + i*Nth + " Sledge Kp: " + OuterKp + " Sledge Ki: " + OuterKi + " Sledge Kd: " + OuterKd + " Pendulum Kp: " + InnerKp + " Pendulum Ki: " + InnerKi + " Pendulum Kd: " + InnerKd + " Fitness: " + fitnesses(i*Nth);
% end
% subplot(2,1,1);
% legend(legendInfo)
% subplot(2,1,2);
% legend(legendInfo)

%% Optimize cascade controller with Pendulum as outer loop and Sledge as inner loop
sledgeOuterPendulumInner = false;
try
    fileID = fopen('bestCascadeGene_PendulumOuterSledgeInner.bin');
    initialGene = fread(fileID, [1 6], 'double');
    fclose(fileID);
catch ME
    initialGene = [1 1 1 1 1 1];
end



%initialGene = [2 0 0.0001 8 0.16 0.0001]; % best pendulum outer sledge inner manually tuned values
initialGene = [1 1 1 1 1 1];
optimizedGene = optimizeGene(initialGene, populationSize, generations, @fitnessFunction, @logBestGene);
%%
options = simset('SrcWorkspace', 'current');
newValues = num2cell(optimizedGene);
[OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};
setPoint = 0.5;

% sets positionResponse and angleResponse
recordedNoise = getRecordedNoise();
sim("../controllers/CascadeModelPendulumOuterSledgeInnerForGeneticTuning", 17, options);

fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);

figure('Name', 'Cascade Model Pendulum Outer Sledge Inner Genetic Tuning Best Gene Response');
subplot(2,1,1);
plot(positionResponse.Time, positionResponse.Data);
xlabel('Time [s]')
ylabel('Position [m]')
grid on
subplot(2,1,2);
plot(angleResponse.Time, angleResponse.Data.*(180/pi));
xlabel('Time [s]')
ylabel('Angle [deg]')
grid on
% plot the best fitness for each generation
figure('Name', 'Cascade Model Pendulum Outer Sledge Inner Genetic Tuning Best Fitnesses for Each Generation');
plot(fitnesses);
xlabel('Generation')
ylabel('Fitness')
grid on
% plot the best gene for every Nth generation
figure('Name', 'Cascade Model Pendulum Outer Sledge Inner Genetic Tuning Best Genes for Every Nth Generation');
legendInfo = cell(1, length(generations/Nth));
for i = 1:generations/Nth
    newValues = num2cell(everyNthGenerationsBestGenes(i,:));
    [OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};
    setPoint = 0.5;
    recordedNoise = getRecordedNoise();
    sim("../controllers/CascadeModelPendulumOuterSledgeInnerForGeneticTuning", 17, options);
    subplot(2,1,1);
    hold on;
    plot(positionResponse.Time, positionResponse.Data);
    xlabel('Time [s]')
    ylabel('Position [m]')
    grid on
    subplot(2,1,2);
    hold on;
    plot(angleResponse.Time, angleResponse.Data.*(180/pi));
    xlabel('Time [s]')
    ylabel('Angle [deg]')
    grid on
    legendInfo{i} = "Generation " + i*Nth + " Pendulum Kp: " + OuterKp + " Pendulum Ki: " + OuterKi + " Pendulum Kd: " + OuterKd + " Sledge Kp: " + InnerKp + " Sledge Ki: " + InnerKi + " Sledge Kd: " + InnerKd + " Fitness: " + fitnesses(i*Nth);
end
subplot(2,1,1);
legend(legendInfo)
subplot(2,1,2);
legend(legendInfo)

%% Functions

function fitness = fitnessFunction (gene)
    % global sledgeOuterPendulumInner;
    run("../GlobalVariables.m");
    recordedNoise = getRecordedNoise();
    options = simset('SrcWorkspace', 'current');
    newValues = num2cell(gene);
    [OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};
    
    setPoint = 0.5;
    %sim("../controllers/CascadeModelSledgeOuterPendulumInnerForGeneticTuning", 17, options);
    sim("../controllers/CascadeModelPendulumOuterSledgeInnerForGeneticTuning", 17, options);

    fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
end

function logBestGene(bestGene, bestFitness, generation)
    global fitnesses Nth everyNthGenerationsBestGenes sledgeOuterPendulumInner;
    % % save the best gene and its fitness to a file
    % if(sledgeOuterPendulumInner)
    %     fileID = fopen('bestCascadeGene_SledgeOuterPendulumInner.bin','w');
    % else
    %     fileID = fopen('bestCascadeGene_PendulumOuterSledgeInner.bin','w');
    % end
    % fileID = fopen('bestCascadeGene_SledgeOuterPendulumInner.bin','w');
    fileID = fopen('bestCascadeGene_PendulumOuterSledgeInner.bin','w');
    nbytes = fwrite(fileID, [bestGene bestFitness], 'double');
    fclose(fileID);
    disp("Generation " + generation + " Best Gene: " + num2str(bestGene) + " Fitness: " + bestFitness);
    %save the best gene and its fitness to a global variable
    fitnesses(generation) = bestFitness;
    %save the best gene for every Nth generation to a global variable
    if mod(generation, Nth) == 0
        everyNthGenerationsBestGenes(generation/Nth, :) = bestGene(:);
    end
end

function recordedNoise = getRecordedNoise()
    pendulumNoise = load("Results\\goodNoisyAngleResponse2min.mat").angleResponse;
    pendulumNoise = pendulumNoise + 0.0065;
    randomStartIndex = randi([1, 12000-1700]);
    recordedNoise = timeseries(pendulumNoise.Data(randomStartIndex:(randomStartIndex + 1700)), [0:0.01:17]);
end