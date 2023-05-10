%Sledge and pendulum responses are matrices with one column of times and
%one column of data
%Simtime should be 17 seconds



function fitness = getFitness(sledgeResponse, sledgeSetPoint, pendulumResponse)
    overshoot = max(abs(sledgeResponse(:, 2))) - abs(sledgeSetPoint);
    maxAngleValue = max(abs(pendulumResponse(:, 2)));
    
    sledgeSettledEpsilon = 1.2 / 100; % 1% of 1.2m track length
    pendulumSettledEpsilon = deg2rad(5 * 15 / 100); % 5% of 15 degrees

    settledDataSledge = getSledgeSettledData(sledgeResponse, sledgeSettledEpsilon);
    settledDataPendulum = getPendulumSettledData(pendulumResponse, pendulumSettledEpsilon);

    sledgeError = abs(settledDataSledge.FinalValue - sledgeSetPoint);


    %The way that I arrived at these values was that I thought about what
    %would correspond to a fitness of 1. So 15??, 15 seconds to settle
    %the sledge and 20 seconds to settle the pendulum.
    angleFactor = 1/deg2rad(15); 
    timeFactorSledge = 1/10;
    timeFactorPendulum = 1/10;
    overshootFactor = 1/0.05;
    sledgeErrorFactor = 1/0.02;
    
    if maxAngleValue > deg2rad(15)
        angleFactor = angleFactor * 1000;
    end
    if overshoot > 0.05
        overshootFactor = 100000 * overshootFactor; 
    end
    if settledDataSledge.Time > 12
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
        overshootFactor * overshoot +...
        sledgeErrorFactor * sledgeError;
end


function settledData = getPendulumSettledData(response, pendulumSettledEpsilon)
    flippedResponse = flipud(response);
    settledData = struct('Time', 0, 'FinalValue', flippedResponse(1, 2));

    for i = 2:length(flippedResponse)
        if abs(flippedResponse(i, 2) - 0) > pendulumSettledEpsilon
            settledData.Time = flippedResponse(i, 1);
            break;
        end
    end
end

function settledData = getSledgeSettledData(response, sledgeSettledEpsilon)
    flippedResponse = flipud(response);
    finalValue = flippedResponse(1, 2);
    settledData = struct('Time', 0, 'FinalValue', finalValue);

    for i = 2:length(flippedResponse)
        if abs(flippedResponse(i, 2) - finalValue) > sledgeSettledEpsilon
            settledData.Time = flippedResponse(i, 1);
            break;
        end
    end
end