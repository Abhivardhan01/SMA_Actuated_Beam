function Curvature = CurvatureSolution(P,Forces)

% ===============================================================
% CurvatureSolution
%
% Computes the analytical beam curvature in the three regions
% together with a symbolic piecewise curvature function.
%
% ===============================================================

%% Variables

x    = P.x;

x1   = P.x1;
l    = P.l;

Eb   = P.Eb;
Ib   = P.Ib;

EIeq = P.EIeq;

Ma   = P.Ma;

M    = Forces.M;

%% ---------------------------------------------------------------
% Region I
%
% 0 <= x < x1
%% ---------------------------------------------------------------

kappa1 = simplify( M/(Eb*Ib) );

%% ---------------------------------------------------------------
% Region II
%
% x1 <= x <= x1+l
%% ---------------------------------------------------------------

kappa2 = simplify( (M + Ma)/EIeq );

%% ---------------------------------------------------------------
% Region III
%
% x1+l < x <= L
%% ---------------------------------------------------------------

kappa3 = simplify( M/(Eb*Ib) );

%% ---------------------------------------------------------------
% Complete Piecewise Curvature
%% ---------------------------------------------------------------

kappa = piecewise( ...
            x < x1 , kappa1 , ...
            x <= x1+l , kappa2 , ...
            kappa3 );

%% ---------------------------------------------------------------

Curvature.kappa1 = kappa1;
Curvature.kappa2 = kappa2;
Curvature.kappa3 = kappa3;

Curvature.kappa = simplify(kappa);

end