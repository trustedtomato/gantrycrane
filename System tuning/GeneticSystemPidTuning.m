clear
clc

addpath('../')

try
    fileID = fopen('../Controller tuning/bestParallelGene.bin');
    initialGene = fread(fileID, [1 4], 'double');
    fclose(fileID);
catch ME
    initialGene = [1 1 1 1];
end

optimizedGene = optimizeGene(initialGene, 20, 20, @fitnessFunction, @logBestGene);

%% Run and plot the response with optimized gene
run("../GlobalVariables.m");
options = simset('SrcWorkspace', 'current');
newValues = num2cell(optimizedGene);
[SKp, SKi, PKp, PKi] = newValues{:};

setPoint = 0.5;

% TODO: use setPoint as the set point, and rename p_in to pIn, etc.
% sets positionResponse and angleResponse
sim("../controllers/ParallelNew", 17, options);

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
    options = simset('SrcWorkspace', 'current');
    newValues = num2cell(gene);
    [SKp, SKi, PKp, PKi] = newValues{:};
    
    setPoint = 0.5;

    % TODO: use setPoint as the set point, and rename p_in to pIn, etc.
    % sets positionResponse and angleResponse
    sim("../controllers/ParallelNew", 17, options);

    fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
end

function logBestGene(bestGene, bestFitness)
    fileID = fopen('bestParallelGene.bin','w');
    nbytes = fwrite(fileID, [bestGene bestFitness], 'double');
    fclose(fileID);
end