# SMA_Actuated_Beam

MATLAB implementation of an analytical and numerical framework for the analysis and optimization of a Shape Memory Alloy (SMA) actuated Euler–Bernoulli cantilever beam.

The project develops a closed-form analytical solution for the beam response under distributed loading and thermal SMA actuation while retaining the actuator location and actuator length as symbolic design variables. A curvature-based optimization framework is then employed to determine the optimal actuator configuration required to achieve a prescribed target curvature distribution.

---

## Features

- Analytical solution for shear force and bending moment
- Piecewise beam curvature solution
- Rotation and displacement computation
- Temperature-dependent SMA constitutive model
- Composite beam–SMA flexural rigidity
- Thermal actuation moment formulation
- Curvature-based optimization
- Automatic computation of optimal actuator location and actuator length
- MATLAB implementation with modular code structure

---

## Repository Structure

| File | Description |
|------|-------------|
| `Main.m` | Main driver script |
| `BeamParameters.m` | Beam and SMA material properties |
| `BeamData.m` | Problem definition and loading |
| `InternalForces.m` | Shear force and bending moment |
| `CurvatureSolution.m` | Piecewise curvature solution |
| `RotationSolution.m` | Beam rotation |
| `DisplacementSolution.m` | Beam displacement |
| `SMARecoveryStrain.m` | Temperature-dependent recovery strain |
| `SolveIntegrationConstants.m` | Computes integration constants |
| `AssembleSolution.m` | Assembles complete analytical solution |
| `ObjectiveFunction.m` | Optimization objective function |
| `OptimizeActuator.m` | Optimization routine |
| `SolveOptimalActuator.m` | Computes optimal actuator configuration |
| `NumericalOptimization.m` | Numerical optimization procedure |
| `DisplayResults.m` | Displays analytical results |
| `DisplayOptimization.m` | Displays optimization results |
| `PostProcessing.m` | Post-processing utilities |
| `AnalyticalResults.mat` | Saved analytical solution |
| `OptimizationResults.mat` | Saved optimization results |

---

## Mathematical Model

The analytical model is based on

- Euler–Bernoulli beam theory
- Linear elastic beam constitutive relation
- Temperature-dependent SMA constitutive behaviour
- Composite beam–SMA equivalent flexural rigidity
- Equivalent thermal actuation moment
- Piecewise analytical solution inside and outside the SMA region

The governing equations are solved analytically to obtain

- Shear force
- Bending moment
- Curvature
- Rotation
- Transverse displacement

The analytical expressions explicitly retain

- actuator location ($x_1$)
- actuator length ($l$)

as symbolic variables.

---

## Optimization Problem

The optimization framework determines

- Optimal actuator location
- Optimal actuator length

such that the analytical beam curvature matches a prescribed target curvature distribution.

The optimization objective is formulated as a curvature matching problem.

---

## Running the Code

1. Open the project in MATLAB.
2. Ensure all `.m` files are in the MATLAB path.
3. Run

```matlab
Main
```

The program automatically

- initializes beam parameters,
- computes the analytical solution,
- solves the optimization problem,
- displays the results.

---

## Output

The code produces

- Beam curvature
- Rotation
- Displacement
- Internal forces
- Optimal actuator location
- Optimal actuator length

and stores the results in

- `AnalyticalResults.mat`
- `OptimizationResults.mat`

---

## Applications

This framework is applicable to

- Smart structures
- Shape Memory Alloy actuators
- Adaptive structures
- Morphing aerospace structures
- Structural optimization
- Analytical beam modelling

---

## Future Work

Possible extensions include

- Multiple SMA actuators
- Non-uniform temperature fields
- Timoshenko beam theory
- Dynamic analysis
- Finite element implementation
- Multi-objective optimization
- Experimental validation

---

## Author

**Abhivardhan**  
Department of Aerospace Engineering  
Indian Institute of Technology Kanpur

---

## License

This repository is intended for academic and research purposes.
