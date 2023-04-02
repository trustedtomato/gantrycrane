clear
clc

run("../GlobalVariables.m");
initialGene = [10 0 1 0];
newValues = num2cell(initialGene);
SKd = 0;
PKd = 0;
[SKp, SKi, PKp, PKi] = newValues{:};

%%

initialGene = [10 0 1 0];

popSize = 30;
maxGens = 50;

numberOfElites = 3;
numberOfMutations = popSize - numberOfElites;

pop=repmat(initialGene, [popSize 1]); %repmat(initialGene, [popSize 1]);

sigmaVec = initialGene;

genesAndFitnesses = containers.Map({[num2str(SKp), ' ', num2str(SKi), num2str(PKp), num2str(PKi)]}, [1.129]);

for generation = 1:maxGens
    popFitnesses = zeros(popSize,1);
    pop = abs(pop);
    for j = 1:popSize
        newValues = num2cell(pop(j,:));
        [SKp, SKi, PKp, PKi] = newValues{:};
        if isKey(genesAndFitnesses, [num2str(SKp), ' ', num2str(SKi), num2str(PKp), num2str(PKi)])
            popFitnesses(j) = genesAndFitnesses([num2str(SKp), ' ', num2str(SKi), num2str(PKp), num2str(PKi)]);
        else
            sim("../controllers/ParallelNew", 17);
            popFitnesses(j) = fitnessFunction([positionResponse.Time positionResponse.Data], 0.5, [angleResponse.Time angleResponse.Data]);
            genesAndFitnesses([num2str(SKp), ' ', num2str(SKi), num2str(PKp), num2str(PKi)]) = popFitnesses(j);
        end
        
        disp(['Generation:', ' ', num2str(generation)])
        for i = 1:30
            disp([num2str(pop(i,:)), ' ', ': ', num2str(popFitnesses(i))])
        end
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
