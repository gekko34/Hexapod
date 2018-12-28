## File: getPoleLength_hexapod.m
## Platform: Octave, https://www.gnu.org/software/octave/ 
## Author: gekko34
## Created: 2018-12-28
## Version: alpha
## Function: checks the pole/actuator lengths
## Input:  hexapod coordinates [B, T, C, D]
## Output: error vector
## Dependencies: global MaxActuatorLength, global MinActuatorLength

function [err, RetVec] = getPoleLength_hexapod(T, B, C, D)
% returns pole lengths
% returns an error if poles exceed the maximum lenght.
% returns an error if poles aree below the minimum length.

  % global parameters
  global MaxActuatorLength;
  global MinActuatorLength;

  err = 0;
  RetVec = [];

  for i = 1:6 
    Lx = [B(i,1), B(i,2), B(i,3)] - [T(i,1), T(i,2), T(i,3)];   
    RetVec = [ RetVec sqrt(Lx(1)^2+Lx(2)^2+Lx(3)^2) ];            
  end

  if (max(RetVec) > MaxActuatorLength)
    err = 2;
  end 

  if (min(RetVec) < MinActuatorLength )
    err = 2;
  end

end
