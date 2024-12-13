clear
load("m/ExampleData.mat");      % clears existing data from ws, adds new data

function newArray = timeElapsed(datetime_array)
    % This function converts an array of elements in datetime format
    % into the total elapsed time in seconds since the first data point was
    % acquired
    %
    % To find out more about datetime formats and arrays try the command:
    %
    %   >> doc datetime
    %
    % Copyright 2018 The MathWorks, Inc
    
    newArray = second(datetime_array);
    arraySize = numel(newArray); % Number of elements in the array
    first = newArray(1);
    i = 1;
    
    % The following loop will run until it reaches the end of the array.
    % Whenever the next number is smaller than the current number the loop will
    % add 60 seconds and then start at the begining of the array again.
    while i < arraySize
        if newArray(i) > newArray(i+1)
            newArray(i+1) = newArray(i+1) +60;
            i = 1;
        end
        i = i+1;
    end
    
    % Subtract the first number to all elements of the array in order to start
    % the array at 0.
        newArray = newArray - first;  
end

lon = Position.longitude;       % stores lat & long data
lat = Position.latitude;
posDT = Position.Timestamp;     % get timestamps for position values

xAcc = Acceleration.X;          % get xyz acceleration values
yAcc = Acceleration.Y;
zAcc = Acceleration.Y;
accDT = Acceleration.Timestamp; % get timestamp for acceleration values

posTi = timeElapsed(posDT);     % get time elapsed for both accel and position datetimes
accTi = timeElapsed(accDT);

earthCircle = 24901; % no idea what this means
totalDist = 0;

for i = 1:(length(lat)-1)   % for values in latitude list
    lat1 = lat(i);          % calculates distances between lat[i], lat[i+1]
    lat2 = lat(i+1);
    lon1 = lon(i);          % does same for long
    lon2 = lon(i+1);

    degDist = distance(lat1, lon1, lat2, lon2); % returns distance degrees (?) from data
    dist = (degDist/360)*earthCircle;            % adds to distance

    totalDist = totalDist + dist;     % increments distance (from prev calculations) to total distance
end

strideLen = 2.5;                % stride length in ft
totalDist_ft = totalDist*5280;  % miles -> feet: miles/5280
steps = totalDist_ft/strideLen;    % gets steps based on total distance divided by strideLength

disp("total distance travelled: " + num2str(totalDist));   % prints stuff
disp("steps taken:              " + num2str(steps));       % prints stuff

plot(accTi, xAcc);  % plots data
hold on;
plot(accTi, yAcc);
plot(accTi, zAcc);

xlim([0 50]);

legend("xAcc", "yAcc", "zAcc");
xlabel("Time (seconds)");
ylabel("Acceleration (m/seconds^2");
title("Acceleration Data vs. Time")

hold off;               % stops plotting data
