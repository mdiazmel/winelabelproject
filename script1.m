%% R?cuperation d'etiquettes de bouteilles de vin
clear all   % Nettoyer les variables du workspace (memoire)
close all   % Fermer toutes les fenetres ouvertes


%% Charger l'image en Matlab. Charger aussi information des metadonn?es.
      clear all;
      pic = imread('westerncelars.JPG');
      imshow(pic);
      
      % Metadonn?es
      info = imfinfo('westerncelars.JPG')
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
 %%     
    % Export the positions obtained by the data cursor to the workspace
      for j = 1:num_input
          for i = 1:size(c_info,1)
              positions{i,j} = c_info{i,j}.Position;
          end
      end
      for jj =1:4
          positions2(jj,:) = c_info{jj}.Position;
      end
      %%
      for i = 1:num_input
          % some code that fits your spline function to the data 
      end
      close all
      
%%

    
     
% Get the equation of the line
   xA = c_info{1, 1}.Position(1,1);
   yA = c_info{1, 1}.Position(1,2);
   xB = c_info{2, 1}.Position(1,1);
   yB = c_info{2, 1}.Position(1,2);
   xC = c_info{3, 1}.Position(1,1);
   yC = c_info{3, 1}.Position(1,2);
   xD = c_info{4, 1}.Position(1,1);
   yD = c_info{4, 1}.Position(1,2);

  
   aP=positions2(1,:);
   bP=positions2(2,:);
   cP=positions2(3,:);
   dP=positions2(4,:);
   
   
   
   %% Pas 1. Calcul des points de l'image callibres selon la matrice K
   s=1;     % car les ( skew ) pixels sont carres
    
   K= [f,s,u0;
       0,f,v0;
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
  
   
   %% Clacul de points de fuite 
   % Methode 2
   intersection_1 = lineIntersection(a(1:2),b(1:2),c(1:2),d(1:2));  %E
   intersection_2 = lineIntersection2(a(1:2),b(1:2),c(1:2),d(1:2));  %E2
   
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

x = calculPose(a, b, c, d, R8)
t = x(1:3);
m = x(4);

R = R8;
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

imshow(pic);
hold on;
   
X=positions2(:,1);
Y=positions2(:,2);
X(5,:)=X(1,:);
Y(5,:)= Y(1,:);
X1=q(:,1);
Y1=q(:,2);
plot(X,Y,'*','LineWidth',3,'MarkerSize',20);
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


%%
