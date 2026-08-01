function Data = BeamData()

%% Beam Geometry

Data.L = 1.0;

%% Beam Properties

Data.Eb = 70e9;

Data.Ib = 1.8e-10;

%% SMA Properties

Data.Es = 30e9;

Data.Is = 2.0e-15;

Data.As = 5.0e-8;

Data.d = 3.0e-3;

Data.Temperatures = linspace(30,70,21);

Data.AsTemp = 30;

Data.AfTemp = 50;

Data.epsL = 0.04;

%% External Load

Data.q0 = 200;

%% Desired Curvature

Data.k0 = 0.02;

%% Optimization Bounds

Data.lmin = 0.05;

Data.lmax = 0.30;

%% Initial Guess

Data.x10 = 0.20;

Data.l0 = 0.10;

end