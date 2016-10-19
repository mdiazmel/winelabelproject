
    for k = 1:1
    % Load an image into Matlab
      pic = imread('image/westerncelars.JPG');
      imshow(pic);
        
      
      
      info = imfinfo('image/westerncelars.JPG');
      info.DigitalCamera;
      f=info.DigitalCamera. FocalLengthIn35mmFilm;
 
      
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
      
    
    end
    
    
 