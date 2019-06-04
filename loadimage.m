function Img = loadimage(inputstr)
str=strcat('Select "',inputstr,'" image?')
%selecting the image using gui
[filename, pathname] = uigetfile('*.*', str)

if ~ischar(filename); return; end      %if user cancelled

filepath = fullfile(pathname, filename);
Img = imread(filepath);
end

