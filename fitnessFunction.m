%Sledge and pendulum responses are matrices with one column of times and
%one column of data
%Simtime should be 17 seconds

clc
getFitness([sine_sledge.Time sine_sledge.Data], 0, [sine_angle.Time, sine_angle.Data])


function fitness = getFitness(sledgeResponse, sledgeSetPoint, pendulumResponse)
    overshoot = max(abs(sledgeResponse(:, 2))) - abs(sledgeSetPoint);
    maxAngleValue = max(abs(pendulumResponse(:, 2)));
    
    sledgeSettledEpsilon = 0.1;
    pendulumSettledEpsilon = 0.1;

    settledDataSledge = getSettledData(sledgeResponse, sledgeSettledEpsilon);
    settledDataPendulum = getSettledData(pendulumResponse, pendulumSettledEpsilon);

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

function settledData = getSettledData(response, epsilon)
    flippedResponse = flipud(response);
    settledData = struct("Time", 0, "FinalValue", flippedResponse(1, 2));
    minimumValue = flippedResponse(1, 2);
    maximumValue = flippedResponse(1, 2);

    for i = 2:length(flippedResponse)
        row = flippedResponse(i, :);
        if minimumValue > row(2)
            minimumValue = row(2);
        elseif maximumValue < row(2)
            maximumValue = row(2);
        end
    
        if abs(maximumValue - minimumValue) > epsilon
            settledData.Time = row(1);
            return 
        end
    end
end