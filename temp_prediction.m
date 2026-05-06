function temp_prediction(a)
% TEMP_PREDICTION  Show temperature change rate and predict future value.
% temp_prediction(a) keeps reading temperature from A0 every ~1 sec,
% works out how fast it's changing (in C/min), predicts what it will be
% in 5 minutes, and drives three LEDs as warnings:
% Green(D9): steady if temperature is 18-24C and change is slow
% Red(D11): steady if heating up faster than 4 C/min
% Yellow(D10): steady if cooling down faster than 4 C/min
% Input: a - Arduino object made with arduino()
% Press Ctrl+C to stop.
green='D9';
yellow='D10';
red='D11';
windowSize=5;    % how many recent points to use      
tempwindow=[];   % timestamps for those points      
timeWindow=[];   % temperatures for those points      
tic;
lastSample=-999;
fprintf('Temperature prediction monitor started. Ctrl+C to stop.\n');
while true
    now=toc;
    
    % read sensor every ~1 second
    if (now-lastSample)>=1.0
        v=readVoltage(a,'A0');
        T=(v-0.5)/0.01;   % convert to deg C
        
        % add to sliding window
        tempwindow(end+1)=T;
        timeWindow(end+1)=now;
        
        % keep only the most recent windowSize points
        if length(tempwindow)>windowSize
            tempwindow(1)=[];
            timeWindow(1)=[];
        end      
        lastSample = now;
    end
    
    % compute rate only when we have enough data
    if length(tempwindow)>=windowSize
        fit=polyfit(timeWindow,tempwindow,1);   % linear fit
        rate_s=fit(1);                          % slope in C/s
        rate_min=rate_s*60;                     % convert to C/min
    else
        rate_s=0;
        rate_min=0;
    end
    
    % prediction
    T_current=tempwindow(end);       % latest temperature
    T_pred=T_current+rate_s*300;     % 5 minutes = 300 seconds
    
    % print to screen
    fprintf('Current: %.2f C | Rate: %+.2f C/min | Predicted in 5 min: %.2f C\n', ...
        T_current, rate_min, T_pred);
    
    % LED logic (based on rate and comfort range)
    incomfortrange=(T_current >= 18) && (T_current <= 24);
    ratestable=abs(rate_min)<= 4;
    
    if incomfortrange && ratestable
        % everything okay: green on, others off
        writeDigitalPin(a,green,1);
        writeDigitalPin(a,yellow,0);
        writeDigitalPin(a,red,0);
        
    elseif rate_min>4
        % heating up too fast: red on, others off
        writeDigitalPin(a,green,0);
        writeDigitalPin(a,yellow,0);
        writeDigitalPin(a,red,1);
        
    elseif rate_min<-4
        % cooling down too fast: yellow on, others off
        writeDigitalPin(a,green,0);
        writeDigitalPin(a,yellow,1);
        writeDigitalPin(a,red,0);
        
    else
        % rate is okay but temperature outside comfort range
        % (fallback – turn all off or leave as is; here we turn all off)
        writeDigitalPin(a,green,0);
        writeDigitalPin(a,yellow,0);
        writeDigitalPin(a,red,0);
    end
    
    pause(0.02);   % reduce CPU load
end