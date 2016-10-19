
      
      str = 'images/westerncelars.JPG'
      pic = imread(str);
      imshow(pic);
        
      
      
      info = imfinfo(str);
      info.DigitalCamera;
      f=info.DigitalCamera. FocalLengthIn35mmFilm;
 
      
     
      clearvars c_info
   
      % select n number of data points using the data cursor - in this case
      % 4 (points ABCD)
          for i = 1:4
              shg
              dcm_obj = datacursormode(1);
              set(dcm_obj,'DisplayStyle','window',...
                  'SnapToDataVertex','off','Enable','on')
              waitforbuttonpress
              c_info{i,j} = getCursorInfo(dcm_obj);
          end
      
    % Export the positions obtained by the data cursor to the workspace
      
          for i = 1:size(c_info,1)
              positions{i,j} = c_info{i,j}.Position;
         
      end
     
      close all
      
    

    
    
 