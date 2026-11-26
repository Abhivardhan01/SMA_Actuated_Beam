# SMA-Actuated Beam: Analytical Modeling and Optimization

## Overview

Developed an analytical MATLAB framework to investigate the structural response of an Euler–Bernoulli beam actuated by a Shape Memory Alloy (SMA) wire bonded over a finite portion of the beam. The framework incorporates temperature-dependent SMA properties and recovery strain to predict actuation-induced bending and beam deformation.

The study considers both cantilever and simply supported beam configurations.

## Methodology

- Developed an analytical Euler–Bernoulli beam formulation under transverse loading.
- Incorporated temperature-dependent SMA elastic modulus and transformation strain to model thermal actuation.
- Evaluated beam curvature, rotation, transverse deflection, bending moment, and stress distributions.
- Formulated an inverse design problem to determine the SMA actuator location and length for a prescribed curvature distribution.
- Implemented multi-start Nelder–Mead optimization using MATLAB's `fminsearch` to minimize the integrated squared curvature error.

## Optimization Formulation

The actuator starting position and length are the design variables:

$$
\min_{x_1,l} J(x_1,l)
$$

where the objective function is defined as

$$
J(x_1,l)=\int_0^L
\left[\kappa(x;x_1,l)-\kappa_d(x)\right]^2\,dx
$$

Here, $\kappa$ is the actual beam curvature and $\kappa_d$ is the prescribed target curvature.

## Repository Structure

```text
SMA_Actuated_Beam/
├── Main.m
├── SMA_OptimizeActuator.m
└── SMA_AnalyticalStudy.m
