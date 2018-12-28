## File: create_hexapod.m
## Platform: Octave, https://www.gnu.org/software/octave/ 
## Author: gekko34
## Created: 2018-12-28
## Version: alpha
## Function: creates the hexapod platform
## Input: hexapod dimensions
## Output: hexapod coordinates [H, B, T, C, D]
## Dependencies: -

function [H, B, T, C, D] = create_hexapod()
% creates hexapod platform 
% returns coordinates
% H = Table top
% T = Top frame
% B = Base frame
% C = Top frame joint voctors
% D = Base frame joint voctors


% Table top
  h = 100; % height, above top frame
  b = 800; % wide
  l = 800; % length

  H0 = [-l/2, -b/2, h];
  H1 = [l/2, -b/2, h];
  H2 = [l/2, b/2, h];
  H3 = [-l/2, b/2, h];

  H = [H0; H1; H2; H3; H0]; % top side
  H = [H ;[H0; H1; H2; H3; H0] + [0,0,-30]]; % bottom  side (-30mm)


% Top frame
  h = 0;
  c = 500;
  e = 200;

  Xt = [
	  (sqrt(3)/6)*(2*c + e)
	  -(sqrt(3)/6)*(c - e)
      -(sqrt(3)/6)*(c + 2*e)
      -(sqrt(3)/6)*(c + 2*e)
      -(sqrt(3)/6)*(c - e)
      (sqrt(3)/6)*(2*c + e)
      (sqrt(3)/6)*(2*c + e)
  ];
  Yt = [
     e/2
     (c + e)/2
     c/2
     -c/2
     -(c + e)/2
     -e/2
     e/2   
  ];
  Zt = ones(7,1) *h;

  T = [Xt, Yt, Zt];


% Base frame
  h = -700; % below top frame
  b = 800;
  d = 200;

  Xb = [
	  (sqrt(3)/6)*(2*b + d)
	  -(sqrt(3)/6)*(b - d)
      -(sqrt(3)/6)*(b + 2*d)
      -(sqrt(3)/6)*(b + 2*d)
      -(sqrt(3)/6)*(b - d)
      (sqrt(3)/6)*(2*b + d)
      (sqrt(3)/6)*(2*b + d)
  ];
  Yb = [
     d/2
     (b + d)/2
     b/2
     -b/2
     -(b + d)/2
     -d/2
     d/2
  ];
  Zb = ones(7,1)*h;

  B = [Xb, Yb, Zb];


% rotate  platform  90°
  yaw = 2 *pi /360 *90;

  T = calc_hexapod(0, 0, yaw, 0, 0, 0, 0, 0, 0, T);
  B = calc_hexapod(0, 0, yaw, 0, 0, 0, 0, 0, 0, B);
  H = calc_hexapod(0, 0, yaw, 0, 0, 0, 0, 0, 0, H);

% Top frame joint vectors
  C = zeros(6,3);
  T2 = calc_hexapod(0, 0, 0, 0, -100, 0, 0, 0, 0, T);
  C(3,:) = T2(3,:);
  C(4,:) = T2(4,:);
  T2 = calc_hexapod(0, 0, 0, sin(deg2rad(60))*100, cos(deg2rad(60))*100, 0, 0, 0, 0, T);
  C(5,:) = T2(5,:);
  C(6,:) = T2(6,:);
  T2 = calc_hexapod(0, 0, 0, -sin(deg2rad(60))*100, cos(deg2rad(60))*100, 0, 0, 0, 0, T);
  C(1,:) = T2(1,:);
  C(2,:) = T2(2,:);

% Base frame frame joint vectors
  D = zeros(6,3);
  B2 = calc_hexapod(0, 0, 0, sin(deg2rad(60))*100, cos(deg2rad(60))*100, 0, 0, 0, 0, B);;
  D(2,:) = B2(2,:);
  D(3,:) = B2(3,:);
  B2 = calc_hexapod(0, 0, 0, -sin(deg2rad(60))*100, cos(deg2rad(60))*100, 0, 0, 0, 0, B);
  D(4,:) = B2(4,:);
  D(5,:) = B2(5,:);
  B2 = calc_hexapod(0, 0, 0, 0, -100, 0, 0, 0, 0, B);
  D(6,:) = B2(6,:);
  D(1,:) = B2(1,:);

end
