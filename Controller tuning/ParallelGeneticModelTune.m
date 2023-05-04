clear
clc

addpath('../')

try
    fileID = fopen('bestParallelGene.bin');
    initialGene = fread(fileID, [1 4], 'double');
    fclose(fileID);
catch ME
    initialGene = [1 1 1 1];
end

optimizedGene = optimizeGene(initialGene, 100, 100, @fitnessFunction, @logBestGene);
% optimizedGene = [2.269 4.5205e-06 3.6344 0.011028];

%% Run and plot the response with optimized gene
run("../GlobalVariables.m");
load("Results\NoisyAngleResponse.mat");
options = simset('SrcWorkspace', 'current');
newValues = num2cell(optimizedGene);
[SKp, SKi, PKp, PKi] = newValues{:};

setPoint = 0.5;

% TODO: use setPoint as the set point, and rename p_in to pIn, etc.
% sets positionResponse and angleResponse
sim("../controllers/ParallelNewModel", 17, options);

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
    load("Results\NoisyAngleResponse.mat");
    options = simset('SrcWorkspace', 'current');
    newValues = num2cell(gene);
    [SKp, SKi, PKp, PKi] = newValues{:};
    
    setPoint = 0.5;

    % TODO: use setPoint as the set point, and rename p_in to pIn, etc.
    % sets positionResponse and angleResponse
    sim("../controllers/ParallelNewModel", 17, options);

    fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
end

function logBestGene(bestGene, bestFitness, generation)
    fprintf('-\n-\n-\n')
    disp('Logging best gene and fitness:')
    disp(num2str(bestGene))
    disp(num2str(bestFitness))
    currentTime = clock;
    fprintf('Simulating %d generation finished at %02d:%02d:%02d.\n', generation, currentTime(4), currentTime(5), round(currentTime(6)));
    fprintf('-\n-\n-\n')
    fileID = fopen('bestParallelGene.bin','w');
    nbytes = fwrite(fileID, [bestGene bestFitness], 'double');
    fclose(fileID);
end