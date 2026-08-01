function Displacement = DisplacementSolution(P,Rotation)

x = P.x;

C6 = P.C6;
C7 = P.C7;
C8 = P.C8;

theta1 = Rotation.theta1;
theta2 = Rotation.theta2;
theta3 = Rotation.theta3;

w1 = simplify(int(theta1,x) + C6);

w2 = simplify(int(theta2,x) + C7);

w3 = simplify(int(theta3,x) + C8);

w = piecewise( ...
        x < P.x1, w1, ...
        x <= P.x1 + P.l, w2, ...
        w3);

Displacement.w1 = w1;
Displacement.w2 = w2;
Displacement.w3 = w3;

Displacement.w = simplify(w);

end