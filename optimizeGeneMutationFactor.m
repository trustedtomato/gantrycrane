function bestGene = optimizeGeneMutationFactor(initialGene, popSize, maxGens, fitnessFunction, onNewGeneration)
    %numberOfElites = ceil(popSize / 10);
    
    pop = repmat(initialGene, [popSize 1]); %repmat(initialGene, [popSize 1]);
    
    sigmaVec = initialGene;
    
    for generation = 1:maxGens
        popFitnesses = zeros(popSize,1);
        pop = abs(pop);
        % Calculate gene fitnesses
        parfor j = 1:popSize
            popFitnesses(j) = fitnessFunction(pop(j,:));
        end
        

        % Mutate genes which are not among the elites
        [bestFitness, indexOfBest] = min(popFitnesses);
        bestGene = pop(indexOfBest, :);

        if exist('onNewGeneration', 'var')
            onNewGeneration(bestGene, bestFitness, generation);
        end
        
        [~, sortedPopIndices] = mink(popFitnesses, popSize);

        mutationFactors = zeros(popSize);
        for i = 1:popSize
            mutationFactors(sortedPopIndices(i)) = (1 - 0) * (i - 1) / (popSize - 1);
        end

        %adjustedSigmaVec = sigmaVec./(((3-0.8)*generation/maxGens)+0.8);
        
        for i = 1:popSize
            adjustedSigmaVec = pop(i, :)./(((3-0.8)*generation/maxGens)+0.8);
            %currentIndex = indicesOfMutations(i);
            %disp(pop(i, :)./(((3-0.8)*generation/maxGens)+0.8).*mutationFactors(i))
            pop(i, :) = normrnd( ...
                pop(i, :), ...
                adjustedSigmaVec*mutationFactors(i) ...
            );
            
        end
    end
    delete(gcp('nocreate'));
end

