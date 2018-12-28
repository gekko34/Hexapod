## File: main.m
## Platform: Octave, https://www.gnu.org/software/octave/ 
## Author: gekko34
## Created: 2018-12-28
## Version: alpha
## Function: calculates and runs the hexapod platform
## Input:  min. and max. actuator length
## Output: charts, pole lengths
## Dependencies: create_hexapod.m, show_hexapod.m, calc_hexapod.m, getPoleLength_hexapod.m

% clean up 
clear;
close all;
clf;
clc;

% global parameters
global MaxActuatorLength = 860;
global MinActuatorLength = 660;

% highlighted pole
poleNr = 5; 

% create hexapod platform
pod.TT = {}; % Table top (H)
pod.TF = {}; % Top Frame (T)
pod.BF = {}; % Base Frame (B)
pod.J_TF = {}; % Joints Top Frame (C)
pod.J_BF = {}; % Joints Base Frame (D)

[pod.TT, pod.BF, pod.TF, pod.J_TF, pod.J_BF] = create_hexapod();

%-------------------------------------------------------------------------------
% show and label hexapod platform
figure(1)

%hold on; % -> switch to 2 dimensional view
 
show_hexapod(pod.TF, pod.BF, pod.J_TF, pod.J_BF, pod.TT, "blue");

axis( [-600, 600, -600, 600, -800, 600] )

% add lables
for i = 1:6 
   text( pod.TT(i,1), pod.TT(i,2), pod.TT(i,3), ["T" int2str(i)]); 
   text( pod.BF(i,1), pod.BF(i,2), pod.BF(i,3), ["B" int2str(i)]);
endfor

% highlight pole
X = [ pod.J_TF(poleNr,1), pod.J_TF(poleNr,2), pod.J_TF(poleNr,3);
      pod.TF(poleNr,1),   pod.TF(poleNr,2),   pod.TF(poleNr,3);
      pod.BF(poleNr,1),   pod.BF(poleNr,2),   pod.BF(poleNr,3);
      pod.J_BF(poleNr,1), pod.J_BF(poleNr,2), pod.J_BF(poleNr,3) ];
      
plot3(X(:,1), X(:,2), X(:,3),'LineWidth',3,'Color',"blue");

% add lables
text( pod.J_TF(poleNr,1), pod.J_TF(poleNr,2), pod.J_TF(poleNr,3), ["J_TF" int2str(poleNr)]); 
text( pod.TF(poleNr,1),   pod.TF(poleNr,2),   pod.TF(poleNr,3),   ["TF"   int2str(poleNr)]);
text( pod.BF(poleNr,1),   pod.BF(poleNr,2),   pod.BF(poleNr,3),   ["BF"   int2str(poleNr)]);
text( pod.J_BF(poleNr,1), pod.J_BF(poleNr,2), pod.J_BF(poleNr,3), ["J_BF" int2str(poleNr)]);

%-------------------------------------------------------------------------------
% run hexapod platform

Lm = []; % pole lengths
K = []; % error vector

figure(2);

%hold on; % -> switch to 2 dimensional view

% run hexapod
% transition = [ roll, pitch, yaw, surge, sway, heave, xOffset, yOffset, zOffset ]
% roll, pitch, yaw -> degree
% surge, sway, heave -> mm

for i = -3:1:3;
%  V = [ 0, 0, 0, 0, 0, i/3*105, 0, 0, 0 ]; % heave
%  V = [ 0, 0, 0, 0, i/3*105, 0, 0, 0, 0 ]; % sway
  V = [ i/3*30, 0, 0, 0, 0, 0, 0, 0, 0 ]; % roll


% copy platform
% move axis 
  pod2.BF = pod.BF;
  pod2.J_BF = pod.J_BF;
 
  pod2.TF = calc_hexapod(deg2rad(V(1)), deg2rad(V(2)), -deg2rad(V(3)), -V(5), -V(4), V(6), V(7), V(8), V(9), pod.TF);
  pod2.TT = calc_hexapod(deg2rad(V(1)), deg2rad(V(2)), -deg2rad(V(3)), -V(5), -V(4), V(6), V(7), V(8), V(9), pod.TT);
  pod2.J_TF = calc_hexapod(deg2rad(V(1)), deg2rad(V(2)), -deg2rad(V(3)), -V(5), -V(4), V(6), V(7), V(8), V(9), pod.J_TF);  

% check pole/actuator lengths  
  [LengthErr, X] = getPoleLength_hexapod(pod2.TF, pod2.BF, pod2.J_TF, pod2.J_BF);
  Lm =  [Lm; X];

% in case of an eeror, write vector to the error vector "K"  
  if( LengthErr )
      K = [K; V'];
  end
  
% show hexapod 
% "blue" = OK
% "red" = NOK (error, pole/actuator length out of range)

X = [ pod2.J_TF(poleNr,1), pod2.J_TF(poleNr,2), pod2.J_TF(poleNr,3);
      pod2.TF(poleNr,1),   pod2.TF(poleNr,2),   pod2.TF(poleNr,3);
      pod2.BF(poleNr,1),   pod2.BF(poleNr,2),   pod2.BF(poleNr,3);
      pod2.J_BF(poleNr,1), pod2.J_BF(poleNr,2), pod2.J_BF(poleNr,3) ];
         
  if( LengthErr )
    show_hexapod(pod2.TF, pod2.BF, pod2.J_TF, pod2.J_BF, pod2.TT, "red");
    plot3(X(:,1), X(:,2), X(:,3),'LineWidth',3,'Color',"red");
  else
    show_hexapod(pod2.TF, pod2.BF, pod2.J_TF, pod2.J_BF, pod2.TT, "blue");
    plot3(X(:,1), X(:,2), X(:,3),'LineWidth',3,'Color',"blue"); 
  end  
  
  axis([-600, 600, -600, 600, -800, 600])

end

%-------------------------------------------------------------------------------
% show pole/actuator lenghts
figure(3);
for i = 1:6
  subplot(3,2,i);
  hold on;
  plot([0, size(Lm, 1)], [MaxActuatorLength, MaxActuatorLength], 'Color', "red");  
  plot([0, size(Lm, 1)], [MinActuatorLength, MinActuatorLength], 'Color', "red"); 
  plot(Lm(:,i), 'Color', "blue");
  ylim([600, 900]);
  title([ "Pole Length " int2str(i)], "fontweight","normal","fontsize",10);
end

