% Linking MATLAB to GitHub
% CW2
% Yibo ZHU
% biyyz182@nottingham.edu.cn
% Test
a = arduino('COM3','Uno');
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
duration=600;                
n_samples=duration;          
voltage_data=zeros(n_samples,1);  
temp_data=zeros(n_samples,1);
fprintf('Starting temperature acquisition for %d seconds...\n', duration);
for i = 1:n_samples
    voltage_data(i) = readVoltage(a, 'A0');        
    temp_data(i) = (voltage_data(i) - 0.5) / 0.01; 
    pause(1);                                       
end
fprintf('Acquisition complete.\n');
