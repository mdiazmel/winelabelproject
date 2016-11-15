function [E, lambda, gamma, isConvex] = lineIntersection(A,B,C,D)


F1 = B(1,:)-D(1,:);
F2 = B(2,:)-D(2,:);
M11 = B(1,:)-A(1,:);
M21 = B(2,:)-A(2,:);
M12 = C(1,:)-D(1,:);
M22 = C(2,:)-D(2,:);
deter = M11.*M22 - M12.*M21;
lambda = -(F2.*M12-F1.*M22)./deter;
gamma = (F2.*M11-F1.*M21)./deter;

E = ([1;1]*lambda).*A + ([1;1]*(1-lambda)).*B
isConvex = (0 <= lambda & lambda <= 1)  & (0 <= gamma & gamma <= 1) ;

% E_check = ([1;1]*gamma).*C + ([1;1]*(1-gamma)).*D;  % Should match E

end