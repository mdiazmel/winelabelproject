%% R?cuperation d'etiquettes de bouteilles de vin
clear all   % Nettoyer les variables du workspace (memoire)
close all   % Fermer toutes les fenetres ouvertes

%filename = 'images/fleurHaut.jpg'
filename = 'westerncelars.JPG'
%% Charger l'image en Matlab. Charger aussi information des metadonn?es.
     
      pic = imread(filename);
      imshow(pic);
      
      % Metadonn?es
      info = imfinfo(filename);
      info.DigitalCamera;
      f_in_mm =info.DigitalCamera.FocalLength;
      
      % Taille de l'image
      v0 = info.Width;
      u0 = info.Height;
      % La distance focal f_in_mm est donnee en milimetres. Il faut la
      % transformer pour une distance focal express?e en pixels :
      
      % Extraction de la taille du capteur en mm
      taille_en_mm = info.DigitalCamera.FocalLength * 35 / info.DigitalCamera.FocalLengthIn35mmFilm;
      
      % focal length in pixels = (image width in pixels) * (focal length in mm) / (CCD width in mm)
      f = u0 * f_in_mm / taille_en_mm;  % Size of the CCD d'un iphone 6, 4.80 x 3.60 mm (d'apr?s Internet...)
        
 %%   user input points  
      
    % Define the number of times you want to repeat the process
    % e.g. if there are multiple lines / shapes that you need to fit to
      num_input = 1; 
      clearvars c_info
      for j = 1:num_input
      % select n number of data points using the data cursor - in this case
      % 4
          for i = 1:4
              shg
              dcm_obj = datacursormode(1);
              set(dcm_obj,'DisplayStyle','window',...
                  'SnapToDataVertex','off','Enable','on')
              waitforbuttonpress
              c_info{i,j} = getCursorInfo(dcm_obj);
          end
      end
    
    % Export the positions obtained by the data cursor to the workspace
      for j = 1:num_input
          for i = 1:size(c_info,1)
              positions{i,j} = c_info{i,j}.Position;
          end
      end
      for jj =1:4
          positions2(jj,:) = c_info{jj}.Position;
      end
   
   
   %% Pas 1. Calcul des points de l'image callibres selon la matrice K
   s=0;     % car les ( skew ) pixels sont carres
    
   K= [f,s,v0/2;
       0,f,u0/2;
       0,0,1]
   
   positions2(:,3)=1;     % Ajout d'un 1 pour creer de coordonees homogenes
   q = K^-1 * positions2';
   a = q(:,1);
   b = q(:,2);
   c = q(:,3);
   d = q(:,4);
   
   %%  Pas 2. Calcule des points de fuite
   % Methode 1
   v1 = cross(cross(a,b),cross(c,d));
   v2 = cross(cross(a,d),cross(b,c));
     
   %% Pas 3. Normalize au vector unit? les vectors v1 et v2
   v1 = v1/norm(v1)
   v2 = v2/norm(v2)
   
   %% Pas 4. Calcule des solutions possibles pour R.
   % Toutes les possibilit?s sont test?s
   
   R1 = [cross(v1,v2) v2 v1]   
   R2 = [cross(v1,v2) -v2 v1];  %%
   R3 = [cross(v1,v2) v2 -v1];  %%
   R4 = [cross(v1,v2) -v2 -v1]; 
   R5 = [-cross(v1,v2) v2 v1];  %%
   R6 = [-cross(v1,v2) -v2 v1]; 
   R7 = [-cross(v1,v2) v2 -v1]; 
   R8 = [-cross(v1,v2) -v2 -v1]; %%
   
  % Nous gardons seulement les matrices de rotation R* ou le determinant
  % est = +1
    det(R1)  
    det(R2)
    det(R3)
    det(R4)
    det(R5)
    det(R6)
    det(R7)
    det(R8)
    
   % On garde R2, R3, R5 et R8
%% Pas 5. Calcul de la pose (t) et de la largeur de l'ettiquette (m)
%R8 et R5 2cart? car m n?gatif 

R = R3;

x = calculPose(a, b, c, d, R)

t = x(1:3);
m = x(4);

P=K*R*[eye(3) -t];

an=P*[0; -m; 1; 1]; 
an=an/an(3,1)

bn=P*[0; -m; -1; 1]; 
bn=bn/bn(3,1)

cn=P*[0; m; -1; 1]; 
cn=cn/cn(3,1)

dn=P*[0; m; 1; 1]; 
dn=dn/dn(3,1)

%%
figure, 
image(pic);
hold on;
   
X=positions2(:,1);
Y=positions2(:,2);
X(5,:)=X(1,:);
Y(5,:)= Y(1,:);
X1=q(:,1);
Y1=q(:,2);
plot(X,Y,'*--','LineWidth',3,'MarkerSize',20);
hold on;
plot(an(1),an(2),'s','Linewidth',3,'MarkerSize',20);
hold on
plot(bn(1),bn(2),'s','Linewidth',3,'MarkerSize',20);
hold on
plot(cn(1),cn(2),'s','Linewidth',3,'MarkerSize',20);
hold on
plot(dn(1),dn(2),'s','Linewidth',3,'MarkerSize',20);
hold on
plot (a,m,'s')


%%  calcul de l'erreur de mod?lisation
A = positions2(1,:);
B = positions2(2,:);
C = positions2(3,:);
D = positions2(4,:);

Err_modA = sqrt(abs((A(1)-an(1))^2 - ((A(2)-an(2))^2)))
Err_modB = sqrt(abs((B(1)-an(1))^2 - ((B(2)-an(2))^2)))
Err_modC = sqrt(abs((C(1)-an(1))^2 - ((C(2)-an(2))^2)))
Err_modD = sqrt(abs((D(1)-an(1))^2 - ((D(2)-an(2))^2)))

Err_moyenne = (Err_modA+Err_modB+Err_modC+Err_modD)/4
% nous obtenons l'erreur moyenne la plus faible avec R3
% ainsi nous gardons la triplette R t m correstpondante

%la diff?rence entre a et a_proj1 est : sqrt((x-w)^2 - (y-x)^2)

%% Definition des matrices c c' et c''

% C prime plus 
cpPlus =    R*[(1-t(3))  0  0; 0  (1-t(3)) 0; t(1) t(2) 1] * ...
            [1  0  0;
             0  1  0;
             0  0  -(m^2)] * ...
            [(1-t(3))  0    t(1); 0  (1-t(3)) t(2); 0  0  1] * R';

% C prime moins
cpMoins =   R*[-1-t(3)  0  0;  0  -1-t(3) 0;  t(1) t(2)   1] * ...
            [1  0  0;
             0  1  0;
             0  0  -(m^2)] * ...
            [-1-t(3)  0    t(1); 0  -1-t(3) t(2); 0  0  1] * R';
    
    
% C seconde plus
cppPlus =   R*[(1-t(3))  0  0; 0  (1-t(3)) 0; t(1) t(2)   1] * ...
            [0  0  -1;
             0  0  0;
            -1  0  0] * ...
            [1-t(3)  0    t(1); 0  1-t(3) t(2); 0  0  1] * R';
                                               
% C seconde moins
cppMoins =  R*[-1-t(3)  0  0; 0  -1-t(3) 0; t(1) t(2)   1] * ...
            [0  0  -1;
             0  0  0;
            -1  0  0] * ...
            [-1-t(3)  0    t(1); 0  -1-t(3) t(2); 0  0  1] * R'; 
%%
 figure;
 imshow(pic);
             
 [ep(1,1) ep(2,1)]= ginput(1)
 [em(1,1) em(2,1)]= ginput(1)
 ep = round(ep);
 em = round(em);
 
 ep(3,1)=1;
 em(3,1)=1;
 
 ep = K^-1 * ep;
 em = K^-1 * em;
 
 hold on,
 
%% Solution du syst?me d'equations
X0 = sym('X0');
eq1= ep' * cpPlus * ep + X0*ep' * cppPlus * ep;
eq2= em' * cpMoins * em + X0*em' * cppMoins * em;

X0m=[fliplr(sym2poly(eq1));fliplr(sym2poly(eq2))];
X0=-X0m(1,1)/X0m(1,2);

r=sqrt((X0)^2+m^2); % Verify!!!!

%t(1)=t(1)-X0; % Change of coordenates


%% Verification
CPlus= R* [1-t(3)     0       0  ;   0     1-t(3)    0  ;   t(1)    t(2)      1   ]*...
          [1          0      -X0 ;   0       1       0  ;   -X0      0       -m^2]*...
          [1-t(3)     0      t(1);   0     1-t(3)   t(2);    0        0       1   ]*R';

CMinus= R* [-1-t(3)     0       0  ;   0    -1-t(3)    0  ;   t(1)    t(2)      1   ]*...
           [ 1          0      -X0 ;   0       1       0  ;   -X0      0       -m^2]*...
           [-1-t(3)     0      t(1);   0    -1-t(3)   t(2);    0        0       1   ]*R';     

        
plot_elipse(CPlus, [positions2(1,1:2);positions2(4,1:2)], K, 100);
plot_elipse(CMinus, [positions2(2,1:2);positions2(3,1:2)], K, 100);
 
 %% Reprojection des points dans l'image synthetis? methode simple
clear imgrec imgrec2
s=500;
w=2*r*asin(m/r);
imgrec=zeros(2*s,round(2*s*w));

t = x(1:3);
t(1)=t(1)-X0; % Change of coordenates
P=K*R*[eye(3) -t]; % New Projection matrix with translation os X0

for y_img=1:size(imgrec,1)
    for x_img=1:size(imgrec,2)
        Z = y_img/s - 1;
        Alpha = 2*x_img/(s*r) - asin(m/r);
        Q = [r*cos(Alpha); r*sin(Alpha); Z; ones(length(Z),1)];
        q = P * Q;
        q = q/q(3);
        %imgrec(abs(l-2*s+1),x_img) = pic(round(q(2)),round(q(1)));
        imgrec(2*s-(y_img-1),round(2*s*w)-(x_img-1)) = pic(round(q(2)),round(q(1)));
    end
end
imgrec2 = imcrop(imgrec, [size(imgrec,2)/2-round(s*w/2) 0 round(s*w) size(imgrec,1)]);

figure, imshow(imgrec,[])
figure, imshow(imgrec2,[])

%figure, image(double(imgrec/255))
%%

[X, Y]=find(imgrec==0);
Z = Y/s - 1;
Alpha = 2*X/(s*r)-asin(x(4)/r);
Q=[r*cos(Alpha), r*sin(Alpha), Z, ones(length(Z),1)];
Q=Q';


for i=1:1:length(Q)
    q=P*Q(:,i); q=q/q(3);
    imgrec3(X(i),abs(Y(i)-(2*s))+1,:)=pic(round(q(2)),round(q(1)),:);
end 
