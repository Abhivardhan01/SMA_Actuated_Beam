
function SMA_OptimizeActuator()
% ==============================================================
% SMA ACTUATOR LOCATION AND LENGTH OPTIMIZATION
%
% Design variables:
%   x1 = actuator starting position
%   l  = actuator length
%
% Objective:
%   Minimize squared curvature error.
%
% Support conditions:
%   1. Cantilever
%   2. Simply supported
%
% Uses SMA_AnalyticalStudy.m
% No FEM.
% ==============================================================

clc;

close all;

%% 1. INITIAL PARAMETERS

Base = SMA_AnalyticalStudy([], 'cantilever', false);

p = Base.Parameters;

% Design variable bounds

p.lMin = 0.10;

p.lMax = 0.70;

% Target curvature distribution
%
% Example: constant desired curvature
%
% Change this function for your application.

kappaMax = 0.20;  % Maximum desired curvature (1/m)

p.kappaTarget = @(x) kappaMax*(1 - x/p.L).^2;

% Numerical resolution

p.N = 1001;

%% 2. SUPPORT CONDITIONS

Supports = {'cantilever','simply supported'};

OptimizationResults = struct();

%% 3. OPTIMIZATION FOR EACH SUPPORT CONDITION

for s = 1:length(Supports)

    Support = Supports{s};

    fprintf('\n\n');
    fprintf('========================================\n');

    fprintf(' OPTIMIZATION: %s\n',Support);

    fprintf('========================================\n');

    %% 3.1 MULTIPLE INITIAL GUESSES

    InitialValues = [-2 0 2];

    BestObjective = Inf;

    BestZ = [];

    Options = optimset(...
        'Display','off',...
        'TolX',1e-6,...
        'TolFun',1e-10,...
        'MaxIter',500);

    for i = 1:length(InitialValues)

        for j = 1:length(InitialValues)

            z0 = [InitialValues(i), InitialValues(j)];

            Objective = @(z) ObjectiveFunction(...
                z,p,Support);

            [z,J] = fminsearch(...
                Objective,z0,Options);

            if J < BestObjective

                BestObjective = J;

                BestZ = z;

            end

        end

    end

    %% 3.2 RECOVER OPTIMAL DESIGN VARIABLES

    [x1opt,lopt] = DecodeVariables(BestZ,p);

    %% 3.3 SOLVE ANALYTICAL BEAM AT OPTIMUM

    p.x1 = x1opt;

    p.l = lopt;

    Ropt = SMA_AnalyticalStudy(p,Support,false);

    %% 3.4 TARGET CURVATURE

    x = Ropt.x;

    kappaTarget = p.kappaTarget(x);

    %% 3.5 FINAL OBJECTIVE VALUE

    Jopt = trapz(x,...
        (Ropt.Curvature-kappaTarget).^2);

    %% 3.6 STORE RESULTS

    OptimizationResults(s).Support = Support;

    OptimizationResults(s).x1 = x1opt;

    OptimizationResults(s).l = lopt;

    OptimizationResults(s).J = Jopt;

    OptimizationResults(s).Response = Ropt;

    %% 3.7 PRINT OPTIMUM

    fprintf('\nOPTIMAL ACTUATOR CONFIGURATION\n');

    fprintf('Starting position = %.6f m\n',x1opt);

    fprintf('Actuator length   = %.6f m\n',lopt);

    fprintf('Actuator end      = %.6f m\n',x1opt+lopt);

    fprintf('Minimum objective = %.10e\n',Jopt);

    fprintf('Tip deflection    = %.6f mm\n',...
        Ropt.TipDeflection*1000);

    %% 4. OBJECTIVE FUNCTION CONTOUR PLOT

    nX1 = 50;

    nL = 50;

    Lvector = linspace(p.lMin,p.lMax,nL);

    X1vector = linspace(0,p.L-p.lMin,nX1);

    [LL,XX1] = meshgrid(Lvector,X1vector);

    Jgrid = NaN(size(LL));

    for i = 1:size(LL,1)

        for j = 1:size(LL,2)

            x1 = XX1(i,j);

            l = LL(i,j);

            if x1+l <= p.L

                Jgrid(i,j) = DirectObjective(...
                    x1,l,p,Support);

            end

        end

    end

    figure('Color','w');

    contourf(LL,XX1,Jgrid,25);

    hold on;

    colorbar;

    plot(lopt,x1opt,'rp',...
        'MarkerSize',12,...
        'MarkerFaceColor','r');

    xlabel('SMA Length (m)');

    ylabel('SMA Starting Position (m)');

    title(['Curvature Error Objective - ',Support]);

    legend('Objective function',...
        'Optimal configuration',...
        'Location','best');

    grid on;

    %% 5. OPTIMIZED CURVATURE VS TARGET

    figure('Color','w');

    plot(x,Ropt.Curvature,'b','LineWidth',2);

    hold on;

    plot(x,kappaTarget,'r--','LineWidth',2);

    xline(x1opt,'k:','SMA start');

    xline(x1opt+lopt,'k--','SMA end');

    xlabel('Position (m)');

    ylabel('Curvature (1/m)');

    title(['Optimized Curvature - ',Support]);

    legend('Actual curvature',...
        'Target curvature',...
        'Location','best');

    grid on;

    %% 6. OPTIMIZED DEFLECTION

    figure('Color','w');

    plot(x,Ropt.Deflection*1000,...
        'LineWidth',2);

    xlabel('Position (m)');

    ylabel('Deflection (mm)');

    title(['Optimized Beam Deflection - ',Support]);

    grid on;

    %% 7. OPTIMIZED TEMPERATURE-DEPENDENT RESPONSE

    figure('Color','w');

    subplot(2,2,1);

    plot(x,Ropt.Temperature,'LineWidth',2);

    xlabel('Position (m)');

    ylabel('Temperature (^oC)');

    title('Temperature');

    grid on;

    subplot(2,2,2);

    plot(x,Ropt.MartensiteFraction,'LineWidth',2);

    xlabel('Position (m)');

    ylabel('Martensite Fraction');

    title('Martensite Evolution');

    grid on;

    subplot(2,2,3);

    plot(x,Ropt.TransformationStrain,'LineWidth',2);

    xlabel('Position (m)');

    ylabel('Recovery Strain');

    title('Recovery Strain');

    grid on;

    subplot(2,2,4);

    plot(x,Ropt.ActuationMoment,'LineWidth',2);

    xlabel('Position (m)');

    ylabel('Moment (N.m)');

    title('SMA Actuation Moment');

    grid on;

    sgtitle(['Optimized SMA Properties - ',Support]);

end

%% 8. COMPARE OPTIMIZED DESIGNS

fprintf('\n\n========================================\n');

fprintf(' FINAL OPTIMIZATION COMPARISON\n');

fprintf('========================================\n');

for s = 1:length(Supports)

    fprintf('\n%s\n',OptimizationResults(s).Support);

    fprintf('Optimal x1 = %.6f m\n',...
        OptimizationResults(s).x1);

    fprintf('Optimal l  = %.6f m\n',...
        OptimizationResults(s).l);

    fprintf('Minimum J  = %.10e\n',...
        OptimizationResults(s).J);

end

end


%% ==============================================================
% OBJECTIVE FUNCTION WITH CONSTRAINED VARIABLES
% ==============================================================

function J = ObjectiveFunction(z,p,Support)

[x1,l] = DecodeVariables(z,p);

J = DirectObjective(x1,l,p,Support);

end


%% ==============================================================
% TRANSFORM UNCONSTRAINED VARIABLES TO DESIGN VARIABLES
% ==============================================================

function [x1,l] = DecodeVariables(z,p)

% Logistic transformation

u = max(min(z(1),30),-30);

v = max(min(z(2),30),-30);

s1 = 1/(1+exp(-u));

s2 = 1/(1+exp(-v));

% Actuator length bounds

l = p.lMin+(p.lMax-p.lMin)*s2;

% Actuator location bounds

x1 = (p.L-l)*s1;

end


%% ==============================================================
% DIRECT CURVATURE ERROR OBJECTIVE
% ==============================================================

function J = DirectObjective(x1,l,p,Support)

pLocal = p;

pLocal.x1 = x1;

pLocal.l = l;

% Analytical beam solution

R = SMA_AnalyticalStudy(pLocal,Support,false);

% Desired curvature

kappaTarget = p.kappaTarget(R.x);

% Actual curvature

kappaActual = R.Curvature;

% Squared L2 curvature error

J = trapz(R.x,...
    (kappaActual-kappaTarget).^2);

end
