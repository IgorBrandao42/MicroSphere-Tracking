
# MicroSphere Tracker  (MiST)
Multi-object detection and tracking  program using Computer Vision for MATLAB

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
This *optional argument* should be a struct with at least one of the fields described below.


### Running Example
In the subfolder ''Video_Input', there is an example of input video the program was developed for. The tracker can find the trajectories for this video through
````MATLAB
MIST('video_example.mp4')
````

## Tunable settings for the program
There are 12 possible properties to be adjusted through
the *optinal parameter*; if none is specified, the default properties are used. 

These properties are to be passed as fields of a single struct to the program, see below:


| Struct field     |                               Desription                                  | Variable type|
|--|--|--|
|     Region       | Region of the input video to be studied (x0, y0, width, height)           |   1x4 array  |
|    BeginTime     | Initial time (in seconds) to start processing the video                   |    double    |
|     EndTime      | Final   time (in seconds) to stop  processing the video  (if you want to do the whole video and don't know its duration just set EndTime to lower than 0) | double |
|    Threshold     | Minimum brightness that an object must have                               |    double    |
|     MaxLife      | Maximum number of frame after a trajectory isn't updated before deletion  |    double    |
|     MaxDist      | Maximum distance between centers of regions in different frames to be considered the same object |  double   |
|   ShowCenters    | If it is to draw the center of each region                                |    logical   |
|    ShowBoxes     | If it is to draw the bounding boxes of each region                        |    logical   |
| ShowTrajectories | If it is to draw the trajectories                                         |    logical   |
|     ShowResult   | If it is to draw anything (if false, override previous logical variables) |    logical   |
|  RegionManually  | Only run the algorithm in a region of the video (which the user chooses by hand) |    logical   |
| RegionAutomatic  | Only run the algorithm in a region of the video (which the user chooses through the field 'Region') (After selection of the region double click it for the algorithm to start!) |    logical   |

## Author
[Igor Brandão](mailto:igorbrandao@aluno.puc-rio.br) - Research assistant in [Thiago Guerreiro](mailto:barbosa@puc-rio.br)'s Quantum Optics Lab at Pontifical Catholic University of Rio de Janeiro, Brazil

## License
This code is made available under the Creative Commons Attribution - Non Commercial 4.0 License. For full details see LICENSE.md.

Cite this toolbox as: 
> Igor Brandão, "MicroSphere Tracker", [https://github.com/IgorBrandao42/MicroSphere-Tracking](https://github.com/IgorBrandao42/MicroSphere-Tracking). Retrieved <*date-you-downloaded*>

## References
Natan (2021). Fast 2D peak finder (https://www.mathworks.com/matlabcentral/fileexchange/37388-fast-2d-peak-finder), MATLAB Central File Exchange. Retrieved May 26, 2021.

## Acknowledgment
The author thanks Professor Thiago Guerreiro for the initial ideia for this program, discussions and the provided videos of his experiments. The author is thankful for support received from FAPERJ Scholarship No. E-26/200.270/2020 and CNPq Scholarship No. 131945/2019-0.
