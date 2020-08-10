% Run 1 of MicroSphere Tracker (MST), a Multi-Object Tracker MATLAB application
% Two distant objects

% Define name of video file you want to study
input_video_name = 'video04.mp4';

% Run MST, saving trajectories on txt files and get the number of trajectories found
number_of_trajectories_found = MST(input_video_name)