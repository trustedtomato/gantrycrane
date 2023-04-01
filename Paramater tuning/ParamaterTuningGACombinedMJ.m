%% Initialize variables
clc
clear

global model shouldTrainPendulum Lcm ml Lr mr g Jp Dp kt Ra rm mj ke Dsm;

load('GraneResponsesWithVoltageOffset.mat');
load('IIRAngleFilterObject.mat')
run('../GlobalVariables.m')


inputs = [small_bang_input, small_ramp_input, small_step_input, small_sine_input, big_bang_input, big_ramp_input, big_step_input, big_sine_input];
sledgeResponses = [small_bang_sledge, small_ramp_sledge, small_step_sledge, small_sine_sledge, big_bang_sledge, big_ramp_sledge, big_step_sledge, big_sine_sledge];
pendulumResponses = [small_bang_angle, small_ramp_angle, small_step_angle, small_sine_angle, big_bang_angle, big_ramp_angle, big_step_angle, big_sine_angle];
sledgeWeights = [1 1 1 1 1 1 1 1];
pendulumWeights = [1 0 1 1 1 0 1 1];

for i = 1:length(pendulumResponses)
    pendulumResponses(i).Data = filter(IIRAngleFilter, pendulumResponses(i).Data);
end

shouldTrainPendulum = true;

initialGene = [mj Dsm kt ke];
responses = sledgeResponses;
weights = sledgeWeights;
if shouldTrainPendulum
    initialGene = [Jp Dp];
    responses = pendulumResponses;
    weights = pendulumWeights;
end

%% Make initial figure

initalizeModel()

figure(1)
for i = 1:length(inputs)
    subplot(3,3,i);
    y = lsim(model, inputs(i).Data,inputs(i).Time);
    hold off
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(responses(i).Time, responses(i).Data, 'Color', 'red')
end

%% Evolutionize genes

popSize = 30;
maxGens = 50;

numberOfElites = 3;
numberOfMutations = popSize - numberOfElites;

pop=repmat(initialGene, [popSize 1]); %repmat(initialGene, [popSize 1]);

sigmaVec = initialGene;

for i = 1:length(inputs)
    weights(i) = 1/(sum(inputs(i).Data.^2) * length(inputs(i).Time));
end

for generation = 1:maxGens
    popFitnesses = zeros(popSize,1);
    pop = abs(pop);
    for i = 1:length(inputs)
        for j = 1:popSize
            initalizeModel(pop(j,:))

            x = lsim(model, inputs(i).Data, inputs(i).Time);
            xHat = responses(i).Data;
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
initalizeModel(bestGene)

figure(2)
for i = 1:length(inputs)
    subplot(3,3,i);
    y = lsim(model, inputs(i).Data,inputs(i).Time);
    hold off
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(responses(i).Time, responses(i).Data, 'Color', 'red')
end

function error = calculateError(x, xHat)
    error = sum((x-xHat).^2);
end

function initalizeModel(gene)
    global model shouldTrainPendulum Lcm ml Lr mr g Jp Dp kt Ra rm mj ke Dsm;

    if shouldTrainPendulum
        if exist('gene', 'var')
            newValues = num2cell(gene);
            [Jp, Dp] = newValues{:};
        end
        model = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]) * tf([(Lcm * ml + Lr/2*mr) 0 0], [Jp Dp (Lcm * ml + Lr * mr / 2)*g]);
    else
        if exist('gene', 'var')
            newValues = num2cell(gene);
            [mj, Dsm, kt, ke] = newValues{:};
        end
        model = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);
    end
end