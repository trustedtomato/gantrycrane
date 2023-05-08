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
Lcm = Lr + hl/2;
g = 9.82;
Dp = 0.007;
Jp = 0.016; %Parameter list says 0.016???
mj = (ms + ml + mr) * Jm;

% Use the most up-to-date good gene we found for the sledge model
newValues = num2cell([0.000000072062003   4.808165222544377   0.013630362230646   0.003287543558176]);
[mj, Dsm, kt, ke] = newValues{:};

% Use the most up-to-date good gene we found for the pendulum model
newValues = num2cell([0.013551853285670   0.001390599626095]);
[Jp, Dp] = newValues{:};

continuousSledgeModel = tf(kt/(Ra*rm), [mj/rm^2 kt*ke/(rm^2*Ra)+Dsm 0]);
continuousPendulumModel = tf([(Lcm * ml + Lr/2*mr) 0 0], [Jp Dp (Lcm * ml + Lr * mr / 2)*g]);

discreteSledgeModel = c2d(continuousSledgeModel, 1/100);
discretePendulumModel = c2d(continuousPendulumModel, 1/100);

save GlobalVariables.mat