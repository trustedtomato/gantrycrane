clear
clc
close all

addpath('../')
run("../GlobalVariables.m");

% %%
% try
%     fileID = fopen('bestCascadeGene_SledgeOuterPendulumInner.bin');
%     initialGene = fread(fileID, [1 6], 'double');
%     fclose(fileID);
% catch ME
%     initialGene = [1 1 1 1 1 1];
% end


% % initialGene = [0.65 0 0 28 0 3.7]; % best genetically tuned results from [1 1 1 1 1 1]
% initialGene = [0.5 0 0.0001 13 0 0.5]; % best sledge outer pendulum inner manually tuned values
% populationSize = 50;
% generations = 50;
% %global fitnesses Nth everyNthGenerationsBestGenes sledgeOuterPendulumInner;
% fitnesses = zeros(1, generations);
% Nth = 1;
% everyNthGenerationsBestGenes = zeros(generations/Nth, 6);
% sledgeOuterPendulumInner = true;

% %% Optimize cascade controller with Sledge as outer loop and Pendulum as inner loop
% optimizedGene = optimizeGene(initialGene, populationSize, generations, @fitnessFunction, @logBestGene);

% %% Run and plot the response with optimized gene
% options = simset('SrcWorkspace', 'current');
% newValues = num2cell(optimizedGene);
% [OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};

% setPoint = 0.5;

% % TODO: use setPoint as the set point, and rename p_in to pIn, etc.
% % sets positionResponse and angleResponse
% sim("../controllers/CascadeModelSledgeOuterPendulumInnerForGeneticTuning", 17, options);

% fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);

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


populationSize = 50;
generations = 50;
%initialGene = [2 0.001 0.2 500 0.001 2.5];
initialGene = [2 0 0.2 10 0 0.0001]; % best pendulum outer sledge inner manually tuned values
optimizedGene = optimizeGene(initialGene, populationSize, generations, @fitnessFunction, @logBestGene);
%%
options = simset('SrcWorkspace', 'current');
newValues = num2cell(optimizedGene);
[OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};
setPoint = 0.5;

% TODO: use setPoint as the set point, and rename p_in to pIn, etc.
% sets positionResponse and angleResponse
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
    options = simset('SrcWorkspace', 'current');
    newValues = num2cell(gene);
    [OuterKp, OuterKi, OuterKd, InnerKp, InnerKi, InnerKd] = newValues{:};
    
    setPoint = 0.5;
    % sets positionResponse and angleResponse
    % if (sledgeOuterPendulumInner)
    %     sim("../controllers/CascadeModelSledgeOuterPendulumInnerForGeneticTuning", 17, options);
    % else
    %     sim("../controllers/CascadeModelPendulumOuterSledgeInnerForGeneticTuning", 17, options);
    % end
    % sim("../controllers/CascadeModelSledgeOuterPendulumInnerForGeneticTuning", 17, options);
    sim("../controllers/CascadeModelPendulumOuterSledgeInnerForGeneticTuning", 17, options);

    fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
end

function logBestGene(bestGene, bestFitness, generation)
    % global fitnesses Nth everyNthGenerationsBestGenes sledgeOuterPendulumInner;
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
    % save the best gene and its fitness to a global variable
    % fitnesses(generation) = bestFitness;
    % % save the best gene for every Nth generation to a global variable
    % if mod(generation, Nth) == 0
    %     everyNthGenerationsBestGenes(generation/Nth, :) = bestGene(:);
    % end
end