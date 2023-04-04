clear
clc

%initialGene = [6.02219427682515,0.719683327883970,0.00794559323549371,0.267179698905954];
try
    fileID = fopen('bestCascadeGene.bin');
    initialGene = fread(fileID, [1 4], 'double');
    fclose(fileID);
catch ME
    initialGene = [1 1 1 1];
end

optimizedGene = optimizeGene(initialGene, 3, 3, @fitnessFunction, @logBestGene);

function fitness = fitnessFunction (gene)
    run("../GlobalVariables.m");
    options = simset('SrcWorkspace', 'current');
    newValues = num2cell(gene);
    [p_in, p_out, i_in, i_out] = newValues{:};
    
    setPoint = 0.5;

    % TODO: use setPoint as the set point, and rename p_in to pIn, etc.
    % sets positionResponse and angleResponse
    sim("../controllers/CascadeNew", 17, options);

    fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
end

function logBestGene(bestGene, bestFitness)
    fileID = fopen('bestCascadeGene.bin','w');
    nbytes = fwrite(fileID, [bestGene bestFitness], 'double');
    fclose(fileID);
end