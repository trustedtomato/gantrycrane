%% Initialize variables
clc
clear

addpath('../')
calculateOptimizedModel()

function calculateOptimizedModel()
    d = load('GraneResponsesWithVoltageOffset.mat');
    load IIRAngleFilterObject.mat IIRAngleFilter
    load ../GlobalVariables.mat mj Dsm kt ke rm Ra Dp Lcm ml mr Lr g Jp

    inputs = [d.small_bang_input, d.small_ramp_input, d.small_step_input, d.small_sine_input, d.big_bang_input, d.big_ramp_input, d.big_step_input, d.big_sine_input];
    responses = [d.small_bang_angle, d.small_ramp_angle, d.small_step_angle, d.small_sine_angle, d.big_bang_angle, d.big_ramp_angle, d.big_step_angle, d.big_sine_angle];

    weights = [1 0 1 1 1 0 1 1];
    initialGene = [Jp Dp];
    
    for i = 1:length(responses)
        responses(i).Data = filter(IIRAngleFilter, responses(i).Data);
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
            [Jp, Dp] = newValues{:};
        end
        model = tf(kt/(Ra*rm), [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]) * tf([(Lcm * ml + Lr/2*mr) 0 0], [Jp Dp (Lcm * ml + Lr * mr / 2)*g]);
    end
end