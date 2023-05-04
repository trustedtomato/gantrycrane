%% Initialize variables
clc
clear
format long
addpath('../')
run("../GlobalVariables.m");
calculateOptimizedModel()

function calculateOptimizedModel()
    d = load('GraneResponsesWithVoltageOffset.mat');
    load ../GlobalVariables.mat mj Dsm kt ke rm Ra

    inputs = [d.bang3vInput, d.rampInput, d.step1vInput, d.sine3vInput, d.step4vInput];
    responses = [d.bang3vPositionResponse, d.rampPositionResponse, d.step1vPositionResponse, d.sine3vPositionResponse, d.step4vPositionResponse];

    weights = [1 1 1 1 1];
    initialGene = [mj Dsm kt ke];
    
    %% Make initial figure

    model = getModel(initialGene);

    figure(1)
    for i = 1:length(inputs)
        subplot(3,3,i);
        y = lsim(model, inputs(i).Data, inputs(i).Time);
        hold off
        plot(inputs(i).Time, y, 'Color', 'blue');
        hold on
        plot(responses(i).Time, responses(i).Data, 'Color', 'red')
    end
    
    %% Evolutionize genes

    bestGene = optimizeModelGene(inputs, responses, weights, initialGene, @getModel);
    model = getModel(bestGene);
    bestGene
    %% Plot best gene
    
    figure(2)
    for i = 1:length(inputs)
        subplot(3, 3, i);
        y = lsim(model, inputs(i).Data, inputs(i).Time);
        hold off
        plot(inputs(i).Time, y, 'Color', 'blue');
        hold on
        plot(responses(i).Time, responses(i).Data, 'Color', 'red')
    end
    
    function model = getModel(gene)
        if exist('gene', 'var')
            newValues = num2cell(gene);
            [mj, Dsm, kt, ke] = newValues{:};
        end
        model = tf(kt/(Ra*rm), [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);
    end
end