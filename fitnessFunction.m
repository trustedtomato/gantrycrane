%Sledge and pendulum responses are matrices with one column of times and
%one column of data
%Simtime should be 17 seconds

function fitness = fitnessFunction(sledgeResponse, sledgeSetPoint, pendulumResponse)
    overshoot = max(abs(sledgeResponse)) - abs(sledgeSetPoint);
    maxAngleValue = max(abs(pendulumResponse));
    
    settledDataSledge = getSettledData(sledgeResponse);
    settledDataPendulum = getSettledData(pendulumResponse);

    sledgeError = abs(settledDataSledge.FinalValue - sledgeSetPoint);


    %The way that I arrived at these values was that I thought about what
    %would correspond to a fitness of 1. So 15°, 15 seconds to settle
    %the sledge and 20 seconds to settle the pendulum.
    angleFactor = 1/deg2rad(15); 
    timeFactorSledge = 1/10;
    timeFactorPendulum = 1/10;
    overshootFactor = 0;
    sledgeErrorFactor = 1/0.02;
    
    if maxAngleValue > deg2rad(15)
        angleFactor = angleFactor * 1000;
    end
    if overshoot > 0.05
        overshootFactor = 100000 * (overshoot + 1); 
    end
    if settledDataSledge.Time > 15
        timeFactorSledge = 1000 * timeFactorSledge;
    end
    if settledDataPendulum.Time > 15
        timeFactorPendulum = 1000 * timeFactorPendulum;
    end
    if sledgeError > 0.02
        sledgeErrorFactor = 1000 * sledgeErrorFactor;
    end
    
    %timeToSettle is a function that will calculate the time it takes
        %for the response to settle
    fitness = settledDataSledge.Time * timeFactorSledge + ...
        settledDataPendulum.Time * timeFactorPendulum +...
        maxAngleValue * angleFactor +...
        overshootFactor +...
        sledgeErrorFactor * sledgeError;
end

%Stability checking by looking at the change in amplitude difference of
%peaks and valleys

%From end of response, store maximum and minimum value until maximum and
%minimum are further apart than the error range

%Return settling time, final value

function settledData = getSettledData(response, errorRange)



end