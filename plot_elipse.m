function  plot_elipse(C, corners, K, step, flag)

caseM = 0;
if (strcmp(flag,'major'))
    caseM = 1;
else
    if(strcmp(flag,'minor'))
        caseM = 0;
    else
        display('Bad flag, verify function call')
    end
end
    

xu=round(corners(1,1)):round(corners(2,1)); %Upper line
mu=(round(corners(2,2))-round(corners(1,2)))/(round(corners(2,1))-round(corners(1,1)));
bu=((round(corners(2,2))+round(corners(1,2)))-mu*(round(corners(2,1))+round(corners(1,1))))/2;
yu=xu*mu+bu;
pntu=[xu', yu'];

for i=1:step:length(pntu)
    pnt=pntu(i,:);
    pnt=[pnt(1);pnt(2);1];
    pnt1=K^-1*pnt;
    rps=solve([pnt1(1,1) sym('y') 1]*C*[pnt1(1,1); sym('y'); 1]);
    pntellipse(1,1)=pnt1(1,1);
    if (caseM)
       pntellipse(2,1)=double(rps(1));     % Arc superieur
    else
       pntellipse(2,1)=double(rps(2));     % Arc inferieur
    end
    pntellipse(3,1)=pnt1(3,1);
    pntellipse=K*pntellipse;
    points(i,:)=pntellipse(1:2,1);
end

plot(points(1:step:end,1), points(1:step:end,2), 'LineWidth',2,'Color','g')