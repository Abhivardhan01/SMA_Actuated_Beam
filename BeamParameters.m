function P = BeamParameters()

syms x

syms L

syms q0

syms Eb Ib

syms Es Is As d epsT

syms x1 l

syms k0

syms C3 C4 C5 C6 C7 C8

syms T
syms AsTemp AfTemp epsL

EIeq = Eb*Ib + Es*(Is + As*d^2);

Ma = Es*As*d*epsT;

P.x = x;

P.L = L;

P.q0 = q0;

P.Eb = Eb;
P.Ib = Ib;

P.Es = Es;
P.Is = Is;
P.As = As;

P.d = d;

P.epsT = epsT;

P.x1 = x1;
P.l = l;

P.k0 = k0;

P.EIeq = simplify(EIeq);

P.Ma = simplify(Ma);

P.C3 = C3;
P.C4 = C4;
P.C5 = C5;
P.C6 = C6;
P.C7 = C7;
P.C8 = C8;

end