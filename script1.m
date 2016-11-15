%%
    % Load an image into Matlab
      pic = imread('westerncelars.JPG');
      imshow(pic);
        
 %%   user input points  
      
      info = imfinfo('westerncelars.JPG');
      info.DigitalCamera;
      f=info.DigitalCamera.FocalLengthIn35mmFilm;
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
   
   AO=([xB-xA;yB-yA]);   %changement de coordonnées 
   BO=([xB-xB;yB-yB]);   %origine B
   CO=([xC-xB;yB-yC]);
   DO=([xD-xB;yB-yD]);
   
   
   %%
   xO=size(pic,1)/2;
   yO=size(pic,2)/2;
   
   s=1;     % car les ( skew ) pixels sont carres
    
   K= [f,s,xO;
       0,f,yO;
       0,0,1]
   %%
   positions2(:,3)=1;
   q = K^-1 * positions2';
   a = q(:,1);
   b = q(:,2);
   c = q(:,3);
   d = q(:,4);
   
   %%
   v1 = cross(cross(a,b),cross(c,d));
   v2 = cross(cross(a,d),cross(b,c));
   
   v1 = v1/v1(3);
   v2 = v2/v2(3);
   
  
   
   %%
   intersection_1 = lineIntersection(a(1:2),b(1:2),c(1:2),d(1:2));  %E
   intersection_2 = lineIntersection2(a(1:2),b(1:2),c(1:2),d(1:2));  %E2
   
   %%
   
   
   
   
 