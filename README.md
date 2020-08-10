# MicroSphere Tracker 1.0

Multi-object detection and tracking program using Computer Vision for MATLAB

## Installation

Just download this Toolbox and move to its download path

## Usage

Call the function MST with up to 2 arguments:

i) First argument: name of the video in subfolder 'Video_Input':

```python
MST('video.mp4');
```

ii) Setings for the Tracker in a struct (Optional):

```python
properties.ShowBoxes = true;
properties.Threshold = 50;
MST('video.mp4', properties);
```

### Tunable settings for the program
Up to now (27/09/2019) there are 12 possible properties to be adjusted through
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
[Igor Brandão](mailto:igorbrandao@aluno.puc-rio.br) - Master's student in [Thiago Guerreiro](mailto:barbosa@puc-rio.br)'s Lab at Pontifícia Universidade Católica do Rio de Janeiro

## Code overview
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