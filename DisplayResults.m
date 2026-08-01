function DisplayResults(Forces,Curvature,Results)

disp(' ')
disp('========================================================')
disp('           ANALYTICAL SOLUTION : CANTILEVER')
disp('========================================================')

disp(' ')
disp('Shear Force')
pretty(Forces.Cantilever.V)

disp(' ')
disp('Bending Moment')
pretty(Forces.Cantilever.M)

disp(' ')
disp('Curvature : Region I')
pretty(Curvature.Cantilever.kappa1)

disp(' ')
disp('Curvature : Region II')
pretty(Curvature.Cantilever.kappa2)

disp(' ')
disp('Curvature : Region III')
pretty(Curvature.Cantilever.kappa3)

disp(' ')
disp('Rotation : Region I')
pretty(Results.Cantilever.theta1)

disp(' ')
disp('Rotation : Region II')
pretty(Results.Cantilever.theta2)

disp(' ')
disp('Rotation : Region III')
pretty(Results.Cantilever.theta3)

disp(' ')
disp('Displacement : Region I')
pretty(Results.Cantilever.w1)

disp(' ')
disp('Displacement : Region II')
pretty(Results.Cantilever.w2)

disp(' ')
disp('Displacement : Region III')
pretty(Results.Cantilever.w3)

disp(' ')
disp('========================================================')
disp('      ANALYTICAL SOLUTION : SIMPLY SUPPORTED')
disp('========================================================')

disp(' ')
disp('Shear Force')
pretty(Forces.SimplySupported.V)

disp(' ')
disp('Bending Moment')
pretty(Forces.SimplySupported.M)

disp(' ')
disp('Curvature : Region I')
pretty(Curvature.SimplySupported.kappa1)

disp(' ')
disp('Curvature : Region II')
pretty(Curvature.SimplySupported.kappa2)

disp(' ')
disp('Curvature : Region III')
pretty(Curvature.SimplySupported.kappa3)

disp(' ')
disp('Rotation : Region I')
pretty(Results.SimplySupported.theta1)

disp(' ')
disp('Rotation : Region II')
pretty(Results.SimplySupported.theta2)

disp(' ')
disp('Rotation : Region III')
pretty(Results.SimplySupported.theta3)

disp(' ')
disp('Displacement : Region I')
pretty(Results.SimplySupported.w1)

disp(' ')
disp('Displacement : Region II')
pretty(Results.SimplySupported.w2)

disp(' ')
disp('Displacement : Region III')
pretty(Results.SimplySupported.w3)

end