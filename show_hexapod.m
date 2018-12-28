## File: show_hexapod.m
## Platform: Octave, https://www.gnu.org/software/octave/ 
## Author: gekko34
## Created: 2018-12-28
## Version: alpha
## Function: shows the hexapod platform
## Input:  hexapod coordinates [T, B, C, D, H], pole color
## Output: 3D plot
## Dependencies: -

function show_hexapod(T, B, C, D, H, PoleColor) 
% shows the hexapod platform in 3D  

  %hold off;
  plot3(B(:,1), B(:,2), B(:,3), 'color', "black"); % plot base frame
  hold on;
  plot3(T(:,1), T(:,2), T(:,3), 'color', "black"); % plot top frame
  plot3(H(:,1), H(:,2), H(:,3), 'color', [0.7, 0.7, 0.7]); % plot table top
  scatter3(0, 0, 0, 'b'); % plot pivot point

  % plot poles
  for i = 1:6 
    P = [ B(i,1), B(i,2), B(i,3); T(i,1), T(i,2), T(i,3) ];         
    plot3(P(:,1), P(:,2), P(:,3), 'color', PoleColor);
  %  scatter3(P(:,1), P(:,2), P(:,3), 'b'); 
  endfor
     
  %axis tight;
  %refresh(); 

end