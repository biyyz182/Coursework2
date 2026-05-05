% Linking MATLAB to GitHub
% CW2
% Yibo ZHU
% biyyz182@nottingham.edu.cn
% Test
a=arduino('COM3','Uno');
writeDigitalPin(a,'D2',1);
pause(1);
writeDigitalPin(a,'D2',0);
for k = 1:10
    writeDigitalPin(a,'D2',1);
    pause(0.5);
    writeDigitalPin(a,'D2',0);
    pause(0.5);
end
% Task 1
a=arduino('COM3','Uno');
duration=600;                
n=duration;          
V=zeros(n,1);  
T=zeros(n,1);
fprintf('Starting temperature acquisition for %d seconds...\n',duration);
for i=1:n
    V(i)=readVoltage(a,'A0');        
    T(i)=(V(i)-0.5)/0.01; 
    pause(1);                                       
end
fprintf('Acquisition complete.\n');
T_min=min(T);
T_max=max(T);
T_avg=mean(T);
fprintf('Minimum temperature: %.2f °C\n',T_min);
fprintf('Maximum temperature: %.2f °C\n',T_max);
fprintf('Average temperature: %.2f °C\n',T_avg);
time_minutes = (0:n-1)/60;   
plot(time_minutes, T,'b-','LineWidth',1.5);
xlabel('Time (minutes)');
ylabel('Temperature (°C)');
title('10-Minute Temperature Recording');
grid on;
saveas(gcf, 'temperature_plot.png');     
fprintf('Plot saved as temperature_plot.png\n');
fprintf('\n========== Data Log ==========\n');
fprintf('Data logging initiated : %s\n',datestr(now,'dd/mm/yyyy'));
fprintf('Location : University of Nottingham Ningbo China\n');
for minute=0:10
    idx=minute*60+1;              
    if idx<=n
        fprintf('Minute %d Temperature %.2f C\n',minute,T(idx));
    end
end
fprintf('Max temp %.2f C\n',T_max);
fprintf('Min temp %.2f C\n',T_min);
fprintf('Average temp %.2f C\n',T_avg);
fprintf('Data logging terminated\n');
fid = fopen('capsule_temperature.txt','w');
fprintf(fid,'Data logging initiated : %s\n',datestr(now,'dd/mm/yyyy'));
fprintf(fid,'Location : University of Nottingham Ningbo China\n');
for minute=0:10
    idx=minute*60+1;
    if idx<=n
        fprintf(fid,'Minute %d Temperature %.2f C\n',minute,T(idx));
    end
end
fprintf(fid,'Max temp %.2f C\n',T_max);
fprintf(fid,'Min temp %.2f C\n',T_min);
fprintf(fid,'Average temp %.2f C\n',T_avg);
fprintf(fid,'Data logging terminated\n');
fclose(fid);
fprintf('Log file "capsule_temperature.txt" written.\n');
% Task 2: LED temperature monitor
% Call the function (a must already exist from earlier)
a=arduino('COM3','Uno');
temp_monitor(a);