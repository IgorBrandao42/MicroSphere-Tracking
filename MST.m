function count = MST(input_name, properties)
tic
%clearvars -except input_name properties         % Clear memory
%clc                                             % Clear command line
close('all')                                     % Clear figures

% Default parameters for the tracker
global threshold;
threshold = 40;                                  % Minimum brightness that a microsphere must have
MaxLife   = 6;                                   % Maximum number of frame after a trajectory isn't updated before deletion
max_dist  = 6;                                   % Maximum distance between centers of regions in different frames to be considered the same object
show_centers      = false;                       % If it is to draw the center of each region
show_boxes        = true;                        % If it is to draw the bounding boxes of each region
show_trajectories = true;                        % If it is to draw the trajectories
show_result              = true;                 % If it is to draw anything (override previous variables)
Init_time = 0.0;                                 % Initial time to start processing the video
End_time  = 30;                                  % Final   time to stop  processing the video
region = zeros([1 4]);                           % Region of interest
region_automatic = false;                        % If only a portion of the image is to be used (predefined by the user)
region_manually = false;                         % If only a portion of the image is to be used (user choose the region by hand)
program_vision = false;                          % If it is to show what the program actually sees
min_area = 9;                                    % Minimum area that a BoundingBox must have ( make sure its not a false positive)
init_count = 0;                                  % Initial index for txt output
% Confirmation that the input is correct !
if nargin == 0
  disp("Not enough input arguments!")
  return
elseif nargin == 1
  if ~ischar(input_name)
    disp("Input number 1 is not a file name!")
    return
  end
  disp("Using tracker's default properties!")
elseif nargin == 2
  
  if ~ischar(input_name)
    disp("Input number 1 is not a file name!")
    return
  end
  
  if ~isstruct(properties)
    disp("Input number 2 is not a struct!")
    return
  end
  
  if isfield(properties, 'Threshold')
    threshold = properties.threshold
  end
  
  if isfield(properties, 'MaxLife')
    MaxLife = properties.MaxLife
  end
  
  if isfield(properties, 'MaxDist')
    max_dist = properties.MaxDist
  end
  
  if isfield(properties, 'ShowCenters')
    show_centers = properties.ShowCenters
  end
  
  if isfield(properties, 'ShowBoxes')
    show_boxes = properties.ShowBoxes
  end
  
  if isfield(properties, 'ShowTrajectories')
    show_trajectories = properties.ShowTrajectories
  end
  
  if isfield(properties, 'ShowResult')
    show_result = properties.ShowResult
  end
  
  if isfield(properties, 'BeginTime')
    Init_time = properties.BeginTime
  end
  
  if isfield(properties, 'EndTime')
    End_time = properties.EndTime
  end
  
  if isfield(properties, 'RegionManually')
    region_manually = properties.RegionManually
  end
  
  if isfield(properties, 'ShowComputerVision')
    program_vision = properties.ShowComputerVision
  end
  
  if isfield(properties, 'InitialTxtCount')
    init_count = properties.InitialTxtCount
  end

  
  if isfield(properties, 'RegionAutomatic')
    region_automatic = properties.RegionAutomatic
    if isfield(properties, 'Region') && length(properties.Region) == 4 && isnumeric(properties.Region)
      region = properties.Region  % I still have to handle if the region was passed correctly
    else
      disp("User asked for a region of the video, but didn't specify which one!")
      return
    end
  end
  
  if region_automatic && region_manually
    disp("User asked for a manually and automatically defined region of the video! Make up your mind!!")
    return
  end
  
  disp("Using user's properties!")
  
else
  disp("Too any input arguments!")
  return
end

output_directory = 'Txt_Output';
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end

input_directory = 'Video_Input';
addpath(input_directory);
addpath(output_directory);                       % Add path to output's folder
folder = fileparts(which(input_name));           % Name of the folder where the file is
inputFullFileName = fullfile(folder, input_name);% Full address of the file
addpath('Video_Input');
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

inputVideo = VideoReader(inputFullFileName);     % Open up the VideoReader for reading the input video file

if show_result
  figure('Name', '1', 'units','normalized','outerposition',[0 0 1 1])                                      % Create a figure where everything is to be drawn
  h=uicontrol('Style', 'slider', 'Min',0,'Max',250,'Value',threshold,... % Create slider to change threshold
    'Position', [400 20 120 20], 'Callback',{@slider1_Callback});
end

numberOfFrames = inputVideo.NumberOfFrames;      % Number of frames in the video
InputFrame = zeros(inputVideo.Height, inputVideo.Width, 3);
BinaryFrame = zeros(inputVideo.Height, inputVideo.Width, 1);
GrayFrame = zeros(inputVideo.Height, inputVideo.Width, 1);
Duration = inputVideo.Duration;                  % Duration of the video


if Init_time > Duration || Init_time < 0
  Init_time = 0;
end
if End_time > Duration || End_time < Init_time
  End_time = Duration;
end
% disp('Using whole video!')
% End_time = Duration;

framerate = inputVideo.FrameRate;                % Frame Rate
current_time = Init_time;                        % Current video time stamp
frame = floor(current_time*framerate);           % Number of current frame

if frame == 0 
  frame = 1;
end

trajectories = [];                               % Initialize array of trajectories
historical_count = 0;                            % Total number of trajectories found
historical_trajectories = [];                    % Trajectories that have ended

if region_manually
  I = read(inputVideo, frame);
  [~, region] = imcrop(I)
  close
end

while (current_time < End_time)                 % Iterate through all frame of the video
  
  frame = frame + 1;                             % Update the current number of frames
  
  InputFrame = read(inputVideo, frame);          % Extract the current frame from the movie structure
  
  current_time = inputVideo.CurrentTime;         % Current Time
  
  if region_manually || region_automatic
    InputFrame = imcrop(InputFrame, region);
  end
  
  GrayFrame = rgb2gray(InputFrame);            % Transform frame to grayscale (everyframe is 0 or 1)
  BinaryFrame = GrayFrame > threshold;         % Transform frame to binary image (everyframe is 0 or 1)
  
  props = regionprops(BinaryFrame,'BoundingBox'); % Find connected regions
  
  detections = [];
  for i = 1:length(props)
    if props(i).BoundingBox(3)*props(i).BoundingBox(4) < min_area
      continue
    end
    
    img = imcrop(GrayFrame, props(i).BoundingBox );
    p = FastPeakFind(img);
    if size(p) > 0
      temp = [p(1:2:end)+props(i).BoundingBox(1) p(2:2:end)+props(i).BoundingBox(2)];
      detections = [ detections; temp];
    else
      temp = [props(i).BoundingBox(1)+props(i).BoundingBox(3)/2.0 props(i).BoundingBox(2)+props(i).BoundingBox(4)/2.0];
      detections = [ detections; temp];
    end
  end
  
  num_detections  = size(detections,1);          % Number of centers to be matched
  
  num_trajectories = size(trajectories,2);       % Number of trajectories
  
  endings = zeros(num_trajectories, 2);          % Centers added in previous frame
  for i = 1:num_trajectories
    endings(i,:) = trajectories(i).curve(end,:);
  end
  
  if ~isempty(detections)
    
    % Find the distance between every center in the current and previous frame
    cost = zeros(size(endings,1),size(detections,1));
    for i = 1:size(endings, 1)
      diff = detections - repmat(endings(i,:),[size(detections,1),1]);
      cost(i, :) = sqrt(sum(diff .^ 2,2));
    end
    
    [assignment,unassignedTracks,unassignedDetections] = assignDetectionsToTracks(cost, max_dist,max_dist); % Match new regions to trajectories
    
    % Assign the corresponding detections
    for i = 1:size(assignment, 1)
      x  = detections(assignment(i, 2), 1);
      y  = detections(assignment(i, 2), 2);
      trajectories(assignment(i, 1)).expand(trajectories(assignment(i, 1)), x, y);
    end
    
    % Create new trajectories with the new regions that doesn't match any trajectory
    for i = 1:size(unassignedDetections)
      t = trajectory(detections(unassignedDetections(i),1), detections(unassignedDetections(i),2), frame, MaxLife);
      trajectories = [trajectories t];
      historical_count = historical_count + 1;
    end
    j = 0;
    % Decrease lifetime of trajectory if there was no new detetection to assign
    % If there has passed MaxLife frames since last matching
    % save the trajectory as an historical(ended) and delete it
    idx = false(size(trajectories,2));
    for i = 1:size(unassignedTracks)
      j = unassignedTracks(i) - (i-1);
      if trajectories(j).check_lifetime(trajectories(j))
        historical_trajectories = [historical_trajectories trajectories(j)];
        idx(j) = true;
      end
    end
    trajectories(idx) = [];
    
  else
    
    idx = false(size(trajectories,2));
    for j = 1:size(trajectories,2)
      if trajectories(j).check_lifetime(trajectories(j))
        historical_trajectories = [historical_trajectories trajectories(j)];
        idx(j) = true;
      end
    end
    trajectories(idx) = [];
    
  end
  
  if show_result
    hold on
    
    h_frame = findobj(gca,'Type','Image');
    delete(h_frame);                             % Delete previous frame
    
    if program_vision
      subplot(1,2,2);
      imshow(BinaryFrame)
      subplot(1,2,1);
    end
    
    imshow(InputFrame)                           % Show original frame
    
    if show_boxes
      h_boxes = findobj(gca,'Type','rectangle');
      delete(h_boxes);                           % Delete previous frame's bounding boxes
      
      for i = 1:length(props)
        BoundingBox = props(i).BoundingBox;
        rectangle('Position',[BoundingBox(1) BoundingBox(2) BoundingBox(3) BoundingBox(4)], 'EdgeColor','r','LineWidth', 1)       % Draw current frame's bounding boxes
      end
    end
    
    if show_trajectories
      h_line = findobj(gca,'Type','line');
      delete(h_line);                            % Delete previous frame's trajectories
      
      for i = 1:size(trajectories,2)
        if length(trajectories(i).curve) >= 2
          line(trajectories(i).curve(:, 1), trajectories(i).curve(:, 2),'Color','red')  % Draw current frame's trajectories
        end
      end
    end
    
    if show_centers && size(detections,1) > 0
      plot(detections(:,1),detections(:,2),'r*') % Mark center of microspheres
      %xlim([0 1080]);
      %ylim([0 720]);
    end
    
    hold off
  end
  
  drawnow;                                       % Draw everything each frame
end

count = init_count;

% After the video ends, it must write all trajectories that haven't ended yet
for i = 1:size(trajectories,2)
  txt_ = sprintf('Curva%i.txt', count);
  txt_ = fullfile(output_directory, txt_);
  if trajectories(i).txt(trajectories(i), txt_)
    count = count +1;
  end
end

trajectories = [];

% And all that have ended before hand!
for i = 1:size(historical_trajectories,2)
  txt_ = sprintf('Curva%i.txt', count);
  txt_ = fullfile(output_directory, txt_);
  if historical_trajectories(i).txt(historical_trajectories(i), txt_)
    count = count +1;
  end
end

%count = count - 1;

historical_trajectories = [];

fclose('all');                                   % Close all files opened
toc
end

% Function that updates the threshold when you move the slider
function slider1_Callback(hObject, eventdata, handles)
global threshold;
threshold = get(hObject,'Value');
display(threshold);
end





