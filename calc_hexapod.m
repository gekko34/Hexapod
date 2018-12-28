## File: calc_hexapod.m
## Platform: Octave, https://www.gnu.org/software/octave/ 
## Author: gekko34
## Created: 2018-12-28
## Version: alpha
## Function: moves the hexapod platform coordinates
## Input: transition vector
## Output: new platform coordinates
## Dependencies: -

function RetVec = calc_hexapod(roll, pitch, yaw, surge, sway, heave, xOffset, yOffset, zOffset, Vec)
% Shift pivot point
% Rotation matrix
% Translation matrix

% Shift pivot point
  RetVec = Vec + [xOffset, yOffset, zOffset]; 

% Rotation
  RotRoll = [ cos(roll), 0, sin(roll)
            0, 1, 0;
            -sin(roll), 0, cos(roll) ];
         
  RotPitch = [ 1, 0, 0
             0, cos(pitch), -sin(pitch);
             0, sin(pitch), cos(pitch) ];

  RotYaw = [ cos(yaw), -sin(yaw), 0;
           sin(yaw), cos(yaw), 0;
           0, 0, 1 ];         
 
  RetVec = RetVec *RotRoll *RotPitch *RotYaw;

% Translation
  RetVec = RetVec +[surge, sway, heave];

end
