function Optimal = SolveOptimalActuator(P,Solution)

x1 = P.x1;
l  = P.l;

dJdx1 = Solution.dJdx1;
dJdl  = Solution.dJdl;

S = solve( ...
    [dJdx1 == 0, dJdl == 0], ...
    [x1, l], ...
    'ReturnConditions', true);

Optimal.Solution = S;

end