
clc
Ra = 4.2;
Jm = 0.0000218;
rm = 0.7/100;
Dsm = 62.892;
kt = 0.138;
ke = 0.1377;
ms = 0.93;
mr = 0.085;
ml = 0.184;
hl = 1.5/100;
Lr = 24.1/100;
Lcm =  Lr + hl/2;
g = 9.82;
Dp = 0.007;
Jp = 0.016; %Parameter list says 0.016???


popSize = 100;
maxGens = 100;

numberOfElites = 10;
numberOfMutations = popSize - numberOfElites;


initialGene = [ms Jm Dsm kt ke];

pop=repmat(initialGene, [popSize 1]); %repmat(initialGene, [popSize 1]);

sigmaVec = initialGene;
%pendulumModel = tf([Lcm*ml+Lr/2*mr 0 0], [Jp Dp Lcm*ml+Lr/2*mr]);




inputs = [bang_input, ramp_neg_input, ramp_pos_input, staircase_input, step_3V_input, step_2V_input, sine_input];
sledgeResponses = [bang_sledge, ramp_neg_sledge, ramp_pos_sledge, staircase_sledge, step_3V_sledge, step_2V_sledge, sine_sledge];

weights = [2.5, 1, 1, 1, 1, 1.5, 1];


for generation = 1:maxGens
    popFitnesses = zeros(popSize,1);
    pop = abs(pop);
    for i = 1:length(inputs)
        for j = 1:popSize
            newValues = num2cell(pop(j,:));
            [ms, Jm, Dsm, kt, ke] = newValues{:};
            sledgeModel = tf([kt/(Ra*rm)], [ms*Jm/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);
   
            x = lsim(sledgeModel, inputs(i).Data, inputs(i).Time);
            xHat = sledgeResponses(i).Data;
            error = calculateError(x, xHat);
            popFitnesses(j) = popFitnesses(j) + error*weights(i); 
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
            sigmaVec./(((3-1)*generation/maxGens)+1) ...
        );
    end
    if mod(generation, 10) == 0
        disp(generation);
        [a, bestThisGeneration] = min(popFitnesses);
        disp([a, bestThisGeneration])
    end
end




function error = calculateError(x, xHat)
    error = sum((x-xHat).^2);
end



