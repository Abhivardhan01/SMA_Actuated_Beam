
function Results = SMA_AnalyticalStudy(p, Support, MakePlots)
% ==============================================================
% SMA ACTUATED EULER-BERNOULLI BEAM
%
% Analytical / semi-analytical beam formulation.
% No FEM, no mesh, no element assembly.
%
% Supports:
%   1. Cantilever
%   2. Simply supported
%
% Outputs:
%   Temperature, martensite fraction, SMA modulus,
%   transformation strain, curvature, rotation,
%   deflection, bending moment and stresses.
%
% ==============================================================

clc;

%% 1. DEFAULT PARAMETERS

if nargin < 1 || isempty(p)

    p.L = 1.0;

    % Beam geometry
    p.b = 30e-3;
    p.h = 5e-3;

    % Beam material
    p.Eb = 70e9;

    % Uniform transverse load (positive downward)
    p.q0 = 10;

    % SMA location and length
    p.x1 = 0.25;
    p.l  = 0.50;

    % SMA wire geometry
    p.D = 0.5e-3;
    p.d = p.h/2;

    % SMA material properties
    p.EA = 70e9;
    p.EM = 30e9;

    p.epsL = 0.04;

    % Transformation temperatures (deg C)
    p.Ms = 40;
    p.Mf = 20;
    p.As = 50;
    p.Af = 70;

    % Temperature profile along SMA
    p.Tstart = 40;
    p.Tend   = 80;

    % Numerical integration resolution
    p.N = 1001;

end

if nargin < 2 || isempty(Support)
    Support = 'cantilever';
end

if nargin < 3
    MakePlots = true;
end

%% 2. GEOMETRIC PROPERTIES

L = p.L;

Abeam = p.b*p.h;

Ibeam = p.b*p.h^3/12;

EIbeam = p.Eb*Ibeam;

Asma = pi*p.D^2/4;

Isma = pi*p.D^4/64;

d = p.d;

x1 = p.x1;

x2 = p.x1 + p.l;

if x1 < 0 || p.l <= 0 || x2 > L
    error('Invalid SMA actuator location or length.');
end

%% 3. LONGITUDINAL COORDINATE

x = linspace(0,L,p.N)';

dx = x(2)-x(1);

%% 4. TEMPERATURE FIELD

T = NaN(size(x));

SMAregion = (x >= x1) & (x <= x2);

% Linear temperature distribution along actuator
% T = Tstart at x1
% T = Tend   at x2

T(SMAregion) = p.Tstart + ...
    (p.Tend-p.Tstart)*(x(SMAregion)-x1)/p.l;

%% 5. MARTENSITE FRACTION

xi = NaN(size(x));

Tact = T(SMAregion);

xiAct = zeros(size(Tact));

for i = 1:length(Tact)

    if Tact(i) <= p.As

        xiAct(i) = 1.0;

    elseif Tact(i) >= p.Af

        xiAct(i) = 0.0;

    else

        xiAct(i) = (p.Af-Tact(i))/(p.Af-p.As);

    end

end

xi(SMAregion) = xiAct;

%% 6. TEMPERATURE-DEPENDENT SMA PROPERTIES

Es = zeros(size(x));

EpsT = zeros(size(x));

Es(SMAregion) = ...
    (1-xi(SMAregion))*p.EA + ...
    xi(SMAregion)*p.EM;

EpsT(SMAregion) = ...
    xi(SMAregion)*p.epsL;

%% 7. COMPOSITE FLEXURAL RIGIDITY

EI = EIbeam*ones(size(x));

EI(SMAregion) = EIbeam + ...
    Es(SMAregion).*(Isma+Asma*d^2);

%% 8. SMA ACTUATION MOMENT

Ma = zeros(size(x));

Ma(SMAregion) = ...
    Es(SMAregion).*Asma.*d.*EpsT(SMAregion);

%% 9. EXTERNAL BENDING MOMENT
%
% Uniform distributed load q0, positive downward.
%
% Cantilever:
% M = q0*(L-x)^2/2
%
% Simply supported:
% M = q0*x*(L-x)/2
%
% These are the statically determined external-load
% moment distributions for the respective supports.

Mexternal = zeros(size(x));

switch lower(Support)

    case 'cantilever'

        Mexternal = p.q0*(L-x).^2/2;

    case 'simply supported'

        Mexternal = p.q0*x.*(L-x)/2;

    otherwise

        error('Support must be cantilever or simply supported.');

end

%% 10. TOTAL CURVATURE
%
% Outside SMA:
% kappa = M/EIbeam
%
% Inside SMA:
% kappa = (M+Ma)/EIeq

Curvature = (Mexternal+Ma)./EI;

%% 11. ROTATION AND DEFLECTION
%
% theta' = kappa
% w' = theta
%
% Cantilever:
% w(0) = 0
% theta(0) = 0
%
% Simply supported:
% w(0) = 0
% w(L) = 0
%
% For the simply supported beam, initial rotation is
% determined from the second displacement boundary condition.

ThetaBase = cumtrapz(x,Curvature);

WBase = cumtrapz(x,ThetaBase);

switch lower(Support)

    case 'cantilever'

        Theta0 = 0;

    case 'simply supported'

        Theta0 = -WBase(end)/L;

end

Theta = Theta0 + ThetaBase;

W = cumtrapz(x,Theta);

%% 12. TOTAL INTERNAL BENDING MOMENT

% M_internal = EI*kappa - Ma

Moment = EI.*Curvature-Ma;

%% 13. BEAM BENDING STRESS

% Extreme beam surface stress.
% Assumes the beam neutral axis remains the reference axis.

BeamStress = -p.Eb*(p.h/2)*Curvature;

%% 14. SMA STRESS AT ITS CENTROID
%
% Uses the sign convention in the composite moment relation:
% sigma_s = Es*(d*kappa - epsT)
%
% This is the axial stress at the SMA centroid, not
% the complete stress distribution over its cross-section.

SMAStress = NaN(size(x));

SMAStress(SMAregion) = ...
    Es(SMAregion).*(d*Curvature(SMAregion)-EpsT(SMAregion));

%% 15. STORE RESULTS

Results.x = x;

Results.Temperature = T;

Results.MartensiteFraction = xi;

Results.SMAmodulus = Es;

Results.TransformationStrain = EpsT;

Results.CompositeEI = EI;

Results.ActuationMoment = Ma;

Results.ExternalMoment = Mexternal;

Results.Moment = Moment;

Results.Curvature = Curvature;

Results.Rotation = Theta;

Results.Deflection = W;

Results.BeamStress = BeamStress;

Results.SMAStress = SMAStress;

Results.TipDeflection = W(end);

Results.MaximumDeflection = max(abs(W));

Results.MaximumCurvature = max(abs(Curvature));

Results.MaximumMoment = max(abs(Moment));

Results.MaximumBeamStress = max(abs(BeamStress));

Results.Parameters = p;

Results.Support = Support;

Results.SMAregion = SMAregion;

%% 16. PRINT SUMMARY

fprintf('\n========================================\n');

fprintf(' SMA ACTUATED BEAM ANALYTICAL SOLUTION\n');

fprintf('========================================\n');

fprintf('Support condition : %s\n',Support);

fprintf('Beam length       : %.3f m\n',L);

fprintf('SMA start         : %.3f m\n',x1);

fprintf('SMA end           : %.3f m\n',x2);

fprintf('SMA length        : %.3f m\n',p.l);

fprintf('External load     : %.3f N/m\n',p.q0);

fprintf('Tip deflection    : %.6f mm\n',W(end)*1000);

fprintf('Maximum deflection: %.6f mm\n', ...
    Results.MaximumDeflection*1000);

fprintf('Maximum curvature : %.6f 1/m\n', ...
    Results.MaximumCurvature);

fprintf('Maximum moment    : %.6f N.m\n', ...
    Results.MaximumMoment);

fprintf('Maximum beam stress: %.6f MPa\n', ...
    Results.MaximumBeamStress/1e6);

fprintf('========================================\n');

%% 17. PLOTS

if MakePlots

    % ------------------------------------------
    % FIGURE 1: TEMPERATURE-DEPENDENT SMA STATE
    % ------------------------------------------

    figure('Name','SMA Temperature Dependent Properties',...
        'Color','w');

    subplot(2,2,1)

    plot(x,T,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Temperature (^oC)');

    title('Temperature Distribution');

    subplot(2,2,2)

    plot(x,xi,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Martensite Fraction');

    title('Martensite Fraction');

    ylim([0 1.1]);

    subplot(2,2,3)

    plot(x,Es/1e9,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('SMA Modulus (GPa)');

    title('Temperature Dependent Modulus');

    subplot(2,2,4)

    plot(x,EpsT,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Transformation Strain');

    title('Recovery Strain');

    sgtitle(['SMA Material Response - ',Support]);

    % ------------------------------------------
    % FIGURE 2: BEAM STRUCTURAL RESPONSE
    % ------------------------------------------

    figure('Name','SMA Beam Response','Color','w');

    subplot(3,2,1)

    plot(x,W*1000,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Deflection (mm)');

    title('Transverse Deflection');

    subplot(3,2,2)

    plot(x,Theta,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Rotation (rad)');

    title('Beam Rotation');

    subplot(3,2,3)

    plot(x,Curvature,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Curvature (1/m)');

    title('Beam Curvature');

    subplot(3,2,4)

    plot(x,Moment,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Moment (N.m)');

    title('Total Internal Bending Moment');

    subplot(3,2,5)

    plot(x,BeamStress/1e6,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Stress (MPa)');

    title('Beam Surface Stress');

    subplot(3,2,6)

    plot(x,SMAStress/1e6,'LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Stress (MPa)');

    title('SMA Centroid Stress');

    sgtitle(['Beam Response - ',Support]);

    % ------------------------------------------
    % FIGURE 3: EXTERNAL AND ACTUATION MOMENTS
    % ------------------------------------------

    figure('Name','Moment Contributions','Color','w');

    plot(x,Mexternal,'LineWidth',2);

    hold on;

    plot(x,Ma,'LineWidth',2);

    plot(x,Moment,'--','LineWidth',2);

    grid on;

    xlabel('Position (m)');
    ylabel('Moment (N.m)');

    legend('External moment',...
           'SMA actuation moment',...
           'Total internal moment',...
           'Location','best');

    title(['Moment Contributions - ',Support]);

end

end
