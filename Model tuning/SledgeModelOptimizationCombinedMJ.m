%% Initialize variables
clc
clear

calculateOptimizedModel()

function calculateOptimizedModel()
    d = load('GraneResponsesWithVoltageOffset.mat');
    load ../GlobalVariables.mat mj Dsm kt ke rm Ra

    inputs = [d.small_bang_input, d.small_ramp_input, d.small_step_input, d.small_sine_input, d.big_bang_input, d.big_ramp_input, d.big_step_input, d.big_sine_input];
    responses = [d.small_bang_sledge, d.small_ramp_sledge, d.small_step_sledge, d.small_sine_sledge, d.big_bang_sledge, d.big_ramp_sledge, d.big_step_sledge, d.big_sine_sledge];

    weights = [1 1 1 1 1 1 1 1];
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
    
    %% Plot best gene
    
    figure(2)
    for i = 1:length(inputs)
        subplot(3, 3, i);
        inputs(i).Data
        inputs(i).Time
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