function J = ObjectiveFunction(P,Curvature)

x = P.x;

L = P.L;

x1 = P.x1;

l = P.l;

k0 = P.k0;

kappa1 = Curvature.kappa1;
kappa2 = Curvature.kappa2;
kappa3 = Curvature.kappa3;

J1 = int((kappa1-k0)^2,x,0,x1);

J2 = int((kappa2-k0)^2,x,x1,x1+l);

J3 = int((kappa3-k0)^2,x,x1+l,L);

J = expand((J1 + J2 + J3)/L);

end