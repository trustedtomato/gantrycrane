function gene = optimizeModel(inputs, responses, weights, initialGene, getModel)
    gene = optimizeGene(initialGene, 30, 50, @fitnessFunction);

    % for j = 1:length(inputs)
    %     weights(j) = weights(j) * length(inputs(j).Time) / sum(inputs(j).Data.^2);
    % end

    function fitness = fitnessFunction (gene)
        fitness = 0;
        for i = 1:length(inputs)
            model = getModel(gene);
            x = lsim(model, inputs(i).Data, inputs(i).Time);
            xHat = responses(i).Data;
            error = calculateError(x, xHat);
            fitness = fitness + error * weights(i);
        end
    end

    function error = calculateError(x, xHat)
        error = sum((x-xHat).^2);
    end
end