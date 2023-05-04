%% Initialize variables
clc
clear
format long
addpath('../')
run("../GlobalVariables.m");
calculateOptimizedModel()


function calculateOptimizedModel()
    d = load('GraneResponsesWithVoltageOffset.mat');
    load FirstOrderAngleFilter.mat AngleFilter
    load ../GlobalVariables.mat mj Dsm kt ke rm Ra Dp Lcm ml mr Lr g Jp

    inputs = [d.bang3vInput, d.rampInput, d.step1vInput, d.sine3vInput, d.step4vInput];
    responses = [d.bang3vAngleResponse, d.rampAngleResponse, d.step1vAngleResponse, d.sine3vAngleResponse, d.step4vAngleResponse];

    weights = [1 1 1 1 1];
    initialGene = [Jp Dp];
    
    for i = 1:length(responses)
        responses(i).Data = filter(AngleFilter, responses(i).Data);
    end
    
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
            [Jp, Dp] = newValues{:};
        end
        model = tf(kt/(Ra*rm), [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]) * tf([(Lcm * ml + Lr/2*mr) 0 0], [Jp Dp (Lcm * ml + Lr * mr / 2)*g]);
    end
end