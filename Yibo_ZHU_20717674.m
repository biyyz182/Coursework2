% Linking MATLAB to GitHub
% CW2
% Yibo ZHU
% biyyz182@nottingham.edu.cn
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