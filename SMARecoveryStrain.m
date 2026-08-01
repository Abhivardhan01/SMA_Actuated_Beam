function epsT = SMARecoveryStrain(T,AsTemp,AfTemp,epsL)

if T <= AsTemp

    epsT = 0;

elseif T >= AfTemp

    epsT = epsL;

else

    epsT = epsL*(T-AsTemp)/(AfTemp-AsTemp);

end

end