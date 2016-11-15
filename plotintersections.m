

intersection_1; %E
intersection_2; %E2

nRow = 1;
nCol = 1;
n = nRow*nCol;


figure(1); clf;
for i=1:nRow
    for j=1:nCol
        idx = nCol*(i-1) + j;
        subplot(nRow,nCol,idx); hold on;
        plot([A(1,idx), B(1,idx)],[A(2,idx), B(2,idx)],'k-','LineWidth',2);
        plot([C(1,idx), D(1,idx)],[C(2,idx), D(2,idx)],'k-','LineWidth',2);
        
            plot(intersection_1(1,idx), intersection_1(2,idx),'rs','MarkerSize',10,'LineWidth',3);
            plot(intersection_1(1,idx), intersection_1(2,idx),'go','MarkerSize',10,'LineWidth',3);
            plot(intersection_2(1,idx), intersection_2(2,idx),'rs','MarkerSize',10,'LineWidth',3);
            plot(intersection_2(1,idx), intersection_2(2,idx),'go','MarkerSize',10,'LineWidth',3);
            
        axis equal; 
        title(['intersection: ' num2str(idx)]);
        xlabel('x')
        ylabel('y')
    end
end


