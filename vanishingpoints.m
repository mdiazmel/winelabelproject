% TEST -- line intersection
%
% [E, lambda, gamma, isConvex] = lineIntersection(A,B,C,D)
%
% Given a line segment AB and another line segment CD, compute the point E
% where the lines intersect.
%
% INPUTS:
%   A = [2,n] = [Ax;Ay] = point in 2D space
%   B = [2,n] = [Bx;By] = point in 2D space
%   C = [2,n] = [Cx;Cy] = point in 2D space
%   D = [2,n] = [Dx;Dy] = point in 2D space
%
% OUTPUTS:
%   E = [2, n] = intersection of lines AB and CD
%   lambda = [1,n]
%       E = lambda*A + (1-lambda)*B
%   gamma = [1,n]
%       E = gamma*C + (1-gamma)*D
%   isConvex = is intersection on both lines?
%       isConvex = (0 <= lambda <= 1)  && (0 <= gamma <= 1)
%
% DERIVATION:
%   E1 = lambda*A + (1-lambda)*B
%   E2 = gamma*C + (1-gamma)*D
%   E1 == E2  --> linear system in [lambda; gamma] --> solve 
%
% IMPLEMENTATION:
%   F = B-D;
%   M = [(B-A), (C-D)]
%   Z = M\F;
%   lambda = Z(1);
%   gamma = Z(2);
%


% Construct a random set of lines and points
nRow = 1;
nCol = 1;
n = nRow*nCol;
  % A = [xA;yA]; 
  % B = [xB;yB];
  %C = [xC;yC];
  %D = [xD;yD];
  AA = [AO(1,1);AO(2,1)];
  BB = [BO(1,1);BO(2,1)];
  CC = [CO(1,1);CO(2,1)];
  DD = [DO(1,1);DO(2,1)];

% Compute the intersections:
[E, lambda, gamma, isConvex] = lineIntersection(AA,BB,CC,DD);
[E2, lambda, gamma, isConvex] = lineIntersection(AA,DD,BB,CC);

% Plot the solution:
figure(1); clf;
for i=1:1
    for j=1:nCol
        idx = nCol*(i-1) + j;
        subplot(nRow,nCol,idx); hold on;
        plot([AA(1,idx), BB(1,idx)],[AA(2,idx), BB(2,idx)],'k-','LineWidth',2);
        plot([CC(1,idx), DD(1,idx)],[CC(2,idx), DD(2,idx)],'k-','LineWidth',2);
        if isConvex(idx)
            plot(E2(1,idx), E2(2,idx),'rs','MarkerSize',10,'LineWidth',3);
        else
            plot(E2(1,idx), E2(2,idx),'go','MarkerSize',10,'LineWidth',3);
        end
        if isConvex(idx)
            plot(E(1,idx), E(2,idx),'rs','MarkerSize',10,'LineWidth',3);
        else
            plot(E(1,idx), E(2,idx),'go','MarkerSize',10,'LineWidth',3);
        end
        
        
        axis equal; axis([-E-10000,E+10000,-E-100000,E+10000]);
        title(['vanishing points']);
        xlabel('x')
        ylabel('y')
    end
end


