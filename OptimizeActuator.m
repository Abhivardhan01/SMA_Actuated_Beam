function Solution = OptimizeActuator(P,Opt)

x1 = P.x1;
l  = P.l;

J = simplify(Opt.J);

dJdx1 = simplify(diff(J,x1));

dJdl = simplify(diff(J,l));

H = simplify(hessian(J,[x1 l]));

Solution.J = J;

Solution.dJdx1 = dJdx1;
Solution.dJdl = dJdl;

Solution.H = H;

end