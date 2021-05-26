
# MicroSphere Tracker  (MiST)
Multi-object detection and tracking program using Computer Vision for MATLAB

 * Loads a colored (rgb) video
 * Loops through every frame
 * Transforms every frame to a binary image (every pixel is either 0 or 1 if its brightness is below the Threshold or not)
 * Finds connected regions
 (Possibly draws the regions' centers and/or boudingboxes)
 * Tracks the these regions by finding the center in the
 previous frame closest to each one in the current frame and adding it to
 the corresponding trajectory; if there were no corresponding, create a new
 trajectory; if no trajectory continued, wait MaxLife frames to save it to
 a txt file and destroy it
 * Show the trajectories on top of the original video

## Installation

Clone this repository or download this Toolbox and add its main folder to the MATLAB path:
```MATLAB
addpath('<download-path>/<name-folder>')
```

If the user wishes to use one of the default example, also add the subfolders to the MATLAB path
```MATLAB
addpath(genpath('<download-path>/<name-folder>'))
```

## Usage

The user must provide the name of a video file for the program to read, which must be in a subfolder 'Video_Input', then the program can be called simply as


```MATLAB
MIST('video.mp4');
```


There is also a second *optional parameter* (struct) the user can provide with custom settings for the tracker, e.g., if the programs is to shown the trajectories, the brightness threshold to detect a particle, ... 

```MATLAB
properties.ShowBoxes = true;
properties.Threshold = 50;
MIST('<video-file-name>', properties);
```
This *optional argument* should be a struct with at least one of the fields described at the end of this READ ME.


### Running Example
In the subfolder ''Video_Input', there is an example of input video the program was developed for. The tracker can find the trajectories for this video through
````MATLAB
MIST('video_example.mp4')
````

## Tunable settings for the program
There are 12 possible properties to be adjusted through
a struct; if none is specified, the default properties are used. The properties are:

 * Region             (4-vector) -> Region to be studied (x0, y0, width, height) 
 * BeginTime          (number)  -> Initial time (in seconds) to start processing the video
 * EndTime            (number)  -> Final   time (in seconds) to stop  processing the video  (if you want to do the whole video and don't know its duration just set EndTime to lower than 0)
 * Threshold          (number)  -> Minimum brightness that a microsphere must have
 * MaxLife            (number)  -> Maximum number of frame after a trajectory isn't updated before deletion
 * MaxDist            (number)  -> Maximum distance between centers of regions in different frames to be considered the same object
 * ShowCenters        (logical) -> If it is to draw the center of each region
 * ShowBoxes          (logical) -> If it is to draw the bounding boxes of each region
 * ShowTrajectories   (logical) -> If it is to draw the trajectories
 * ShowResult         (logical) -> If it is to draw anything (override previous variables if set to false)
 * RegionManually     (logical) -> Only run the algorithm in a region of the video (which the user chooses by hand)
 * RegionAutomatic    (logical) -> Only run the algorithm in a region of the video (given by the user on a 4d vector 'Region')   (After selection of the region double click it for the algorithm to start!)

## Author
[Igor Brandão](mailto:igorbrandao@aluno.puc-rio.br) - Research assistant in [Thiago Guerreiro](mailto:barbosa@puc-rio.br)'s Quantum Optics Lab at Pontifical Catholic University of Rio de Janeiro, Brazil

## License
This code is made available under the Creative Commons Attribution - Non Commercial 4.0 License. For full details see LICENSE.md.

Cite this toolbox as: 
> Igor Brandão, "MicroSphere Tracker", [https://github.com/IgorBrandao42/MicroSphere-Tracking](https://github.com/IgorBrandao42/MicroSphere-Tracking). Retrieved <*date-you-downloaded*>

 
## Acknowledgment
The author thanks Professor Thiago Guerreiro for the initial ideia for this program, discussions and the provided videos of his experiments. The author is thankful for support received from FAPERJ Scholarship No. E-26/200.270/2020 and CNPq Scholarship No. 131945/2019-0.
