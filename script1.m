
    % Load an image into Matlab
      pic = imread('westerncelars.JPG');
      imshow(pic);
        
      
      
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
    % Export the positions obtained by the data cursor to the workspace
      for j = 1:num_input
          for i = 1:size(c_info,1)
              positions{i,j} = c_info{i,j}.Position;
          end
      end
      for i = 1:num_input
          % some code that fits your spline function to the data 
      end
      close all
      
    

    
     
% Get the equation of the line
   xA = c_info{1, 1}.Position(1,1);
   yA = c_info{1, 1}.Position(1,2);
   xB = c_info{2, 1}.Position(1,1);
   yB = c_info{2, 1}.Position(1,2);
   xC = c_info{3, 1}.Position(1,1);
   yC = c_info{3, 1}.Position(1,2);
   xD = c_info{4, 1}.Position(1,1);
   yD = c_info{4, 1}.Position(1,2);

  
   A=([xA; yA]);
   B=([xB; yB]);
   C=([xC; yC]);
   D=([xD; yD]);
   
   AO=([xB-xA;yB-yA]);
   BO=([xB-xB;yB-yB]);
   CO=([xC-xB;yB-yC]);
   DO=([xD-xB;yB-yD]);
   
   xO=([AO(2,1)/2]);
   yO=([CO(1,1)/2]);
   
   s=0;
    
   K=([f,s,xO;0,f,yO;0,0,1])
 