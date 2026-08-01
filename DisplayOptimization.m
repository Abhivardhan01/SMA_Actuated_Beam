function DisplayOptimization(Opt,Solution,Optimal)

disp(' ')
disp('======================================')
disp('Optimization Problem')
disp('======================================')

disp(' ')
disp('Objective Function')
pretty(Opt.J)

disp(' ')
disp('dJ/dx1')
pretty(Solution.dJdx1)

disp(' ')
disp('dJ/dl')
pretty(Solution.dJdl)

disp(' ')
disp('Hessian Matrix')

disp(Solution.H)

disp(' ')
disp('Optimal Solution')

disp(Optimal.Solution)

end