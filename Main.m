
%% MAIN FILE: SMA Actuator Optimization
% Optimizes SMA actuator location and length
% to achieve a prescribed varying curvature.

clc;
clear;
close all;

fprintf('========================================\n');
fprintf(' SMA ACTUATOR OPTIMIZATION\n');
fprintf('========================================\n\n');

%% Run analytical model and optimization

SMA_OptimizeActuator();

fprintf('\nOptimization analysis completed.\n');
fprintf('Check the generated plots for the optimized\n');
fprintf('actuator configuration and curvature matching.\n');
