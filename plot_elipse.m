function  plot_elipse(C, corners, K, jump)


xu=round(corners(1,1)):round(corners(2,1)); %Up line
mu=(round(corners(2,2))-round(corners(1,2)))/(round(corners(2,1))-round(corners(1,1)));
bu=((round(corners(2,2))+round(corners(1,2)))-mu*(round(corners(2,1))+round(corners(1,1))))/2;
yu=xu*mu+bu;
pntu=[xu', yu'];

for i=1:jump:length(pntu)
    pnt=pntu(i,:);
    pnt=[pnt(1);pnt(2);1];
    pnt1=K^-1*pnt;
    rps=solve([pnt1(1,1) sym('y') 1]*C*[pnt1(1,1); sym('y'); 1]);
    pntellipse(1,1)=pnt1(1,1);
    pntellipse(2,1)=double(rps(1));
    pntellipse(3,1)=pnt1(3,1);
    pntellipse=K*pntellipse;
    points(i,:)=pntellipse(1:2,1);
end

plot(points(1:jump:end,1), points(1:jump:end,2), 'LineWidth',2,'Color','g')