%function center_of_intensity(input_name)
close;clear;clc

input_name = 'video01.mp4';

folder = fileparts(which(input_name));           % Name of the folder where the file is
inputFullFileName = fullfile(folder, input_name);% Full address of the file

% Confirm that the video file exits, if not ask for another one
if ~exist(inputFullFileName, 'file')
  strErrorMessage = sprintf('File not found:\n%s\nYou can choose a new one, or cancel', inputFullFileName);
  response = questdlg(strErrorMessage, 'File not found', 'OK - choose a new movie.', 'Cancel', 'OK - choose a new movie.');
  if strcmpi(response, 'OK - choose a new movie.')
    [baseFileName, folderName, FilterIndex] = uigetfile('*.mp4');
    if ~isequal(baseFileName, 0)
      inputFullFileName = fullfile(folderName, baseFileName);
    else
      return;
    end
  else
    return;
  end
end

VideoObj = VideoReader(inputFullFileName);
NumberOfFrames = VideoObj.NumberOfFrames;

height = VideoObj.Height;
width = VideoObj.Width;

Output = zeros(NumberOfFrames, 2);

figure(1)
hold on

for frame = 1 : NumberOfFrames
  InputFrame = read(VideoObj, frame);
  GrayFrame = rgb2gray(InputFrame);
  
  props = regionprops(true(size(GrayFrame)), GrayFrame, 'WeightedCentroid');
  
  Output(frame,1) = props.WeightedCentroid(2);
  Output(frame,2) = props.WeightedCentroid(1);
  
  
  h_frame = findobj(gca,'Type','Image');
  delete(h_frame);
 % h_line = findobj(gca,'Type','line');
  %delete(h_line);
  
  InputFrame(floor(Output(frame,1)), floor(Output(frame,2)), :) = [0 255 0];
  InputFrame(floor(Output(frame,1))-1, floor(Output(frame,2)), :) = [0 255 0];
  InputFrame(floor(Output(frame,1))+1, floor(Output(frame,2)), :) = [0 255 0];
  InputFrame(floor(Output(frame,1)), floor(Output(frame,2))-1, :) = [0 255 0];
  InputFrame(floor(Output(frame,1)), floor(Output(frame,2))+1, :) = [0 255 0];
  
  % Pra para de mostrar o vídeo é só comentar a linha de baixo.
  imshow(InputFrame)
 % hold on
 % plot(Output(frame,1),Output(frame,2),'r*', 'MarkerSize', 15)
 % hold off
end

% https://www.mathworks.com/matlabcentral/answers/323376-video-resize-save-video-from-frame
% https://www.mathworks.com/matlabcentral/answers/363181-center-of-mass-and-total-mass-of-a-matrix


%end