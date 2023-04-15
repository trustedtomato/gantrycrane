function bestGene = optimizeGene(initialGene, popSize, maxGens, fitnessFunction, onNewGeneration)
    numberOfElites = ceil(popSize / 10);
    
    pop = repmat(initialGene, [popSize 1]); %repmat(initialGene, [popSize 1]);
    
    sigmaVec = initialGene;
    
    for generation = 1:maxGens
        popFitnesses = zeros(popSize,1);
        pop = abs(pop);

        % Calculate gene fitnesses
        for j = 1:popSize
            popFitnesses(j) = fitnessFunction(pop(j,:));
        end
        
        [~, indicesOfElites] = mink(popFitnesses, numberOfElites);
        [~, indicesOfWorsts] = maxk(popFitnesses, numberOfElites);
        
        % Use elite genes in the place of the worst genes
        for i = 1:length(indicesOfWorsts)
            currentIndex = indicesOfWorsts(i);
            pop(currentIndex, :) = pop(indicesOfElites(i), :);
        end

        % Mutate genes which are not among the elites
        indicesOfMutations = setdiff(1:length(popFitnesses), indicesOfElites);

        for i = 1:length(indicesOfMutations)
            currentIndex = indicesOfMutations(i);
            pop(currentIndex, :) = normrnd( ...
                pop(currentIndex, :), ...
                pop(currentIndex, :)./(((3-0.8)*generation/maxGens)+0.8) ...
            );
        end
        [bestFitness, indexOfBest] = min(popFitnesses);
        bestGene = pop(indexOfBest, :);

        if exist('onNewGeneration', 'var')
            onNewGeneration(bestGene, bestFitness);
        end
    end
end

