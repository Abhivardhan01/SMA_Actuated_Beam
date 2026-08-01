function Forces = InternalForces(P)

Forces.Cantilever      = CantileverForces(P);

Forces.SimplySupported = SimplySupportedForces(P);

end

function F = CantileverForces(P)

x  = P.x;
L  = P.L;
q0 = P.q0;

V = q0*(L-x);

M = q0/2*(L-x)^2;

F.V = simplify(V);

F.M = simplify(M);

end

function F = SimplySupportedForces(P)

x  = P.x;
L  = P.L;
q0 = P.q0;

RA = q0*L/2;

V = RA - q0*x;

M = RA*x - q0*x^2/2;

F.V = simplify(V);

F.M = simplify(M);

end
