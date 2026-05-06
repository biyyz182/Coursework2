function temp_monitor(a)
% TEMP_MONITOR  Monitor live temperature and drive LEDs.
% temp_monitor(a) keeps reading temperature from A0 every second,
% updating a live graph, and controlling three LEDs:
% Green(D9) stays on when temp 18-24 C
% Yellow(D10) blinks every 0.5s when temp < 18 C
% Red(D11) blinks every 0.25s when temp > 24 C
% Input: a-Arduino object from arduino()
% Press Ctrl+C to stop.
green='D9';
yellow='D10';
red='D11';
% arrays to store time and temperature for the plot
times=[];
temps=[];
% set up the figure
figure('Name','Real-Time Temperature Monitor');
hLine=plot(NaN, NaN, 'b-','LineWidth',1.5);
xlabel('Time (s)');
ylabel('Temperature (C)');
title('Live Temperature Monitor');
grid on;
xlim([0 60]);    
ylim([10 35]);  
% timing stuff
t0=tic;                      
lastSampleTime=-999;        
lastYellowToggle=0;         
lastRedToggle=0;             
yellowState=0;              
redState=0;                  
fprintf('Live monitor started. Press Ctrl+C to stop.\n');
    while true
        now=toc(t0);             
        if (now-lastSampleTime)>=1.0
            v=readVoltage(a,'A0');
            T=(v-0.5)/0.01;          % conversion from voltage to C
            % store data
            times(end+1)=now;
            temps(end+1)=T;
            lastSampleTime=now;

            % update live plot
            set(hLine,'XData',times,'YData',temps);
            if now>60
                xlim([now-60, now]); % scroll
            end
            drawnow;
        end
        % control LEDs 
        % comfortable range: green on, others off
        if T>=18&&T<=24
            writeDigitalPin(a,green,1);
            writeDigitalPin(a,yellow,0);
            writeDigitalPin(a,red,0);
        % too cold: blink yellow every 0.5s, others off
        elseif T<18
            writeDigitalPin(a,green,0);
            writeDigitalPin(a,red,0);
            if (now-lastYellowToggle)>=0.25
                yellowState= ~yellowState;
                writeDigitalPin(a,yellow,yellowState);
                lastYellowToggle=now;
            end
        % too hot: blink red every 0.25s, others off (T > 24)
        else 
            writeDigitalPin(a,green,0);
            writeDigitalPin(a,yellow,0);
            if (now-lastRedToggle)>=0.125
                redState=~redState;
                writeDigitalPin(a,red,redState);
                lastRedToggle=now;
            end
        end
        pause(0.02);
    end
end