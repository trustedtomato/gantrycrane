clear
clc

addpath('../')
%%
%initialGene = [6.02219427682515,0.719683327883970,0.00794559323549371,0.267179698905954];
try
    fileID = fopen('bestCascadeGene.bin');
    initialGene = fread(fileID, [1 4], 'double');
    fclose(fileID);
catch ME
    initialGene = [1 1 1 1];
end

optimizedGene = optimizeGene(initialGene, 10, 10, @fitnessFunction, @logBestGene);

%% Run and plot the response with optimized gene
run("../GlobalVariables.m");
load('../Results/NoisyAngleResponse.mat');
options = simset('SrcWorkspace', 'current');
newValues = num2cell(optimizedGene);
[p_in, p_out, i_in, i_out] = newValues{:};

setPoint = 0.5;

% TODO: use setPoint as the set point, and rename p_in to pIn, etc.
% sets positionResponse and angleResponse
sim("../controllers/CascadeNewModel", 17, options);

fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);

figure(1);
plot(positionResponse.Time, positionResponse.Data);
grid on
figure(2);
plot(angleResponse.Time, angleResponse.Data.*(180/pi));
grid on

%% Functions

function fitness = fitnessFunction (gene)
    run("../GlobalVariables.m");
    load('../Results/NoisyAngleResponse.mat');
    options = simset('SrcWorkspace', 'current');
    newValues = num2cell(gene);
    [p_in, p_out, i_in, i_out] = newValues{:};
    
    setPoint = 0.5;

    % TODO: use setPoint as the set point, and rename p_in to pIn, etc.
    % sets positionResponse and angleResponse
    sim("../controllers/CascadeNewModel", 17, options);

    fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
end

function logBestGene(bestGene, bestFitness)
    fileID = fopen('bestCascadeGene.bin','w');
    nbytes = fwrite(fileID, [bestGene bestFitness], 'double');
    fclose(fileID);
end