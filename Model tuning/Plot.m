%% Variable initialisation
clear
clc
load('GraneResponsesWithVoltageOffset.mat');
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
mj = ms*Jm;
sledgeModel = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);


inputs = [small_bang_input, small_ramp_input, small_step_input, small_sine_input, big_bang_input, big_ramp_input, big_step_input, big_sine_input];
sledgeResponses = [small_bang_sledge, small_ramp_sledge, small_step_sledge, small_sine_sledge, big_bang_sledge, big_ramp_sledge, big_step_sledge, big_sine_sledge];
pendulumResponses = [bang_angle, ramp_neg_angle, ramp_pos_angle, sine_angle, staircase_angle, step_2V_angle, step_3V_angle, step_n2V_angle, step_n3V_angle];

%% Plot initial model
figure(1)
for i = 1:length(inputs)
    subplot(3,3,i);
    y = lsim(sledgeModel, inputs(i).Data,inputs(i).Time);
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(sledgeResponses(i).Time, sledgeResponses(i).Data, 'Color', 'red')
end

%% Plot other model 
newValues = num2cell([6.50966186168443e-05 2.54521253558318 0.418590929040413 0.0706376302151075]);
[mj, Dsm, kt, ke] = newValues{:};
sledgeModel = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);

figure(2)
for i = 1:length(inputs)
    subplot(3,3,i);
    y = lsim(sledgeModel, inputs(i).Data,inputs(i).Time);
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(sledgeResponses(i).Time, sledgeResponses(i).Data, 'Color', 'red')
end
