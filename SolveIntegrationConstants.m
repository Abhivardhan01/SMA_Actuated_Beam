function Constants = SolveIntegrationConstants(P,Rotation,Displacement,BC)

x  = P.x;
L  = P.L;

x1 = P.x1;
l  = P.l;

C3 = P.C3;
C4 = P.C4;
C5 = P.C5;
C6 = P.C6;
C7 = P.C7;
C8 = P.C8;

theta1 = Rotation.theta1;
theta2 = Rotation.theta2;
theta3 = Rotation.theta3;

w1 = Displacement.w1;
w2 = Displacement.w2;
w3 = Displacement.w3;

switch BC

    case 'Cantilever'

        eq1 = subs(theta1,x,0) == 0;

        eq2 = subs(w1,x,0) == 0;

        eq3 = subs(theta1,x,x1) == subs(theta2,x,x1);

        eq4 = subs(w1,x,x1) == subs(w2,x,x1);

        eq5 = subs(theta2,x,x1+l) == subs(theta3,x,x1+l);

        eq6 = subs(w2,x,x1+l) == subs(w3,x,x1+l);

    case 'SimplySupported'

        eq1 = subs(w1,x,0) == 0;

        eq2 = subs(w3,x,L) == 0;

        eq3 = subs(theta1,x,x1) == subs(theta2,x,x1);

        eq4 = subs(w1,x,x1) == subs(w2,x,x1);

        eq5 = subs(theta2,x,x1+l) == subs(theta3,x,x1+l);

        eq6 = subs(w2,x,x1+l) == subs(w3,x,x1+l);

    otherwise

        error('Unknown Boundary Condition.')

end

Eqns = [eq1;eq2;eq3;eq4;eq5;eq6];

Unknowns = [C3 C4 C5 C6 C7 C8];

S = solve(...
    [eq1,eq2,eq3,eq4,eq5,eq6],...
    [C3,C4,C5,C6,C7,C8],...
    'ReturnConditions',false);

Constants.C3 = simplify(S.C3);
Constants.C4 = simplify(S.C4);
Constants.C5 = simplify(S.C5);

Constants.C6 = simplify(S.C6);
Constants.C7 = simplify(S.C7);
Constants.C8 = simplify(S.C8);

end