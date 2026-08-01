function Rotation = RotationSolution(P,Curvature)

% ===============================================================
%
% RotationSolution
%
% Computes the symbolic beam rotation by integrating the
% analytical curvature in each region.
%
% Governing Equation:
%
%       d(theta)
%      --------- = kappa
%          dx
%
% ===============================================================

%% Independent Variable

x = P.x;

%% Integration Constants

C3 = P.C3;
C4 = P.C4;
C5 = P.C5;

%% Curvatures

kappa1 = Curvature.kappa1;
kappa2 = Curvature.kappa2;
kappa3 = Curvature.kappa3;

%% --------------------------------------------------------------
% Region I
%
% 0 <= x < x1
%% --------------------------------------------------------------

theta1 = simplify( int(kappa1,x) + C3 );

%% --------------------------------------------------------------
% Region II
%
% x1 <= x <= x1+l
%% --------------------------------------------------------------

theta2 = simplify( int(kappa2,x) + C4 );

%% --------------------------------------------------------------
% Region III
%
% x1+l <= x <= L
%% --------------------------------------------------------------

theta3 = simplify( int(kappa3,x) + C5 );

%% --------------------------------------------------------------

Rotation.theta1 = theta1;

Rotation.theta2 = theta2;

Rotation.theta3 = theta3;

end