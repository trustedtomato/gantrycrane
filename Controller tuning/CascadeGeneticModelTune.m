clear
clc

run("../GlobalVariables.m");

%initialGene = [6.02219427682515,0.719683327883970,0.00794559323549371,0.267179698905954];
initialGene = [1 1 1 1];
newValues = num2cell(initialGene);
[p_in, p_out, i_in, i_out] = newValues{:};

optimizedGene = optimizeGene(initialGene, 10, 10, @fitnessFunction);

function fitness = fitnessFunction (gene)
    newValues = num2cell(gene);
    [p_in, p_out, i_in, i_out] = newValues{:};
    
    setPoint = 0.5;
    
    % TODO: use setPoint as the set point, and rename p_in to pIn, etc.
    % sets positionResponse and angleResponse
    sim("../controllers/CascadeNew", 17);

    fitness = getFitness([positionResponse.Time positionResponse.Data], setPoint, [angleResponse.Time angleResponse.Data]);
end

