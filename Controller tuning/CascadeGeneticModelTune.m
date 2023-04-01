clear
clc

run("../GlobalVariables.m");
initialGene = [6.02219427682515,0.719683327883970,0.00794559323549371,0.267179698905954];
newValues = num2cell(initialGene);
[p_in, p_out, i_in, i_out] = newValues{:};

%%

initialGene = [1 1 1 1];

popSize = 30;
maxGens = 50;

numberOfElites = 3;
numberOfMutations = popSize - numberOfElites;

pop=repmat(initialGene, [popSize 1]); %repmat(initialGene, [popSize 1]);

sigmaVec = initialGene;

for generation = 1:maxGens
    popFitnesses = zeros(popSize,1);
    pop = abs(pop);
    for j = 1:popSize
        newValues = num2cell(pop(j,:));
        [p_in, p_out, i_in, i_out] = newValues{:};
        sim("../controllers/CascadeNew", 17);
        popFitnesses(j) = fitnessFunction([positionResponse.Time positionResponse.Data], 0.5, [angleResponse.Time angleResponse.Data]);
    end
    
    [~, indicesOfElites] = mink(popFitnesses, numberOfElites);
    [~, indicesOfWorsts] = maxk(popFitnesses, numberOfElites);
    
    for i = 1:length(indicesOfWorsts)
        currentIndex = indicesOfWorsts(i);
        pop(currentIndex, :) = pop(indicesOfElites(i), :);
    end

    indicesOfMutations = setdiff(1:length(popFitnesses),indicesOfElites);

    for i = 1:length(indicesOfMutations)
        currentIndex = indicesOfMutations(i);
        pop(currentIndex, :) = normrnd( ...
            pop(currentIndex, :), ...
            sigmaVec./(((3-0.8)*generation/maxGens)+0.8) ...
        );
    end
end
[a, bestThisGeneration] = min(popFitnesses);
bestGene = pop(bestThisGeneration, :);

