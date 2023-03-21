clc
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
mj = ms*Jm;
sledgeModel = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);


inputs = [bang_input, ramp_neg_input, ramp_pos_input, sine_input, staircase_input, step_2V_input, step_3V_input, step_n2V_input, step_n3V_input];
sledgeResponses = [bang_sledge, ramp_neg_sledge, ramp_pos_sledge, sine_sledge, staircase_sledge, step_2V_sledge, step_3V_sledge, step_n2V_sledge, step_n3V_sledge];
pendulumResponses = [bang_angle, ramp_neg_angle, ramp_pos_angle, sine_angle, staircase_angle, step_2V_angle, step_3V_angle, step_n2V_angle, step_n3V_angle];
figure(1)
for i = 1:length(inputs)
    
    subplot(3,3,i);
    y = lsim(sledgeModel, inputs(i).Data,inputs(i).Time);
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(sledgeResponses(i).Time, sledgeResponses(i).Data, 'Color', 'red')
end
newValues = num2cell([3.67416040888944e-05	102.615345312043	0.340740270907700	0.0489035116090748]);
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

newValues = num2cell([8.75065073996072e-05	23.7197897989919	0.0664416291413136	0.0894270704267776]);
[mj, Dsm, kt, ke] = newValues{:};
sledgeModel = tf([kt/(Ra*rm)], [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);

figure(3)
for i = 1:length(inputs)
    
    subplot(3,3,i);
    y = lsim(sledgeModel, inputs(i).Data,inputs(i).Time);
    plot(inputs(i).Time, y, 'Color', 'blue');
    hold on
    plot(sledgeResponses(i).Time, sledgeResponses(i).Data, 'Color', 'red')
end

%initialGene = [ms Jm Dsm kt ke];