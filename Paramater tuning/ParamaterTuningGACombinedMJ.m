%% Initialize variables
clc
clear
load('GraneResponses.mat');
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
mj = ms * Jm;

%% Make initial figure

sledgeModel = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);

figure(1)
for i = 1:length(inputs)
    subplot(3,3,i);
    y = lsim(sledgeModel, inputs(i).Data,inputs(i).Time);
    hold off
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(sledgeResponses(i).Time, sledgeResponses(i).Data, 'Color', 'red')
end

%% Evolutionize genes

popSize = 30;
maxGens = 50;

numberOfElites = 3;
numberOfMutations = popSize - numberOfElites;


initiax`lGene = [mj Dsm kt ke];

pop=repmat(initialGene, [popSize 1]); %repmat(initialGene, [popSize 1]);

sigmaVec = initialGene;

inputs = [bang_input, ramp_neg_input, ramp_pos_input, staircase_input, step_3V_input, step_2V_input, sine_input];
sledgeResponses = [bang_sledge, ramp_neg_sledge, ramp_pos_sledge, staircase_sledge, step_3V_sledge, step_2V_sledge, sine_sledge];


weights = [10, 1, 1, 1, 1, 1, 1];

for generation = 1:maxGens
    popFitnesses = zeros(popSize,1);
    pop = abs(pop);
    for i = 1:length(inputs)
        for j = 1:popSize
            newValues = num2cell(pop(j,:));
            [mj, Dsm, kt, ke] = newValues{:};
            sledgeModel = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);
   
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
            sigmaVec./(((3-0.8)*generation/maxGens)+0.8) ...
        );
    end
end

%% Plot best gene

[a, bestThisGeneration] = min(popFitnesses);
bestGene = pop(bestThisGeneration, :);
newValues = num2cell(bestGene);
[mj, Dsm, kt, ke] = newValues{:};
sledgeModel = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);

figure(2)
for i = 1:length(inputs)
    subplot(3,3,i);
    y = lsim(sledgeModel, inputs(i).Data,inputs(i).Time);
    hold off
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(sledgeResponses(i).Time, sledgeResponses(i).Data, 'Color', 'red')
end


function error = calculateError(x, xHat)
    error = sum((x-xHat).^2);
end





