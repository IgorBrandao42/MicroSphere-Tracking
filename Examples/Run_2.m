% Run 2 of MicroSphere Tracker (MST), a Multi-Object Tracker MATLAB application
% Many clustered objects and use of optional arguments

% Define name of video file you want to study
input_video_name = 'video02.mp4';

% Optional arguments passed as structs
props.RegionManually = true;  % Argument to manually define specific region of the video to look for objects
props.ShowBoxes = false;      % Argument as not to show the bounding boxes in Regions of Interest

% Run MST with optional arguments, saving trajectories on txt files and get the number of trajectories found
number_of_trajectories_found = MST(input_video_name, props)