classdef MicroSphere < handle
  properties
    trajectory       % Self explanatory
    lifespan         % How many frames the microsphere can still be on the screen before it's deleted
    bounding_box     % Current bounding box for the microsphere
    initial_frame    % Number of the first frame the microsphere was detected
    
    max_step         % Maximum distance the microsphere can walk in a frame (diagonal of the bounding_box)
    max_life         % This shouldn't be here, artifact from my lack of knowledge in MATLAB
    
  end
  methods (Static)
    function obj = MicroSphere(starting_point_, bounding_box_, initial_frame_, max_life_)    % Constructor
      if nargin > 0
        if isnumeric(starting_point_(1)) && isnumeric(starting_point_(2)) && isnumeric(initial_frame_) && isnumeric(max_life_)
          obj.trajectory = [];
          obj.max_life = max_life_;
          obj.initial_frame = initial_frame_;
          obj.expand(obj, starting_point_, bounding_box_);
        else
          error('Value must be numeric')
        end
      end
    end
    
    function has_died = check_lifetime(obj)                                                  % Check if the microsphere sholud continue to exits or be deleted
      obj.lifespan = obj.lifespan - 1;
      has_died = (obj.lifespan < 0);
    end 
    
    function expand(obj, point_, bounding_box_)                                              % Update microsphere properties
      obj.trajectory = [obj.trajectory; point_];
      obj.bounding_box = bounding_box_;
      obj.max_step = sqrt( obj.bounding_box(1)*obj.bounding_box(1) + obj.bounding_box(2)*obj.bounding_box(2) );  %1.5*max([obj.bounding_box(3) obj.bounding_box(4)]);
      obj.lifespan = obj.max_life;
    end
    
    function txt(obj, file_name)                                                             % Print the trajectory in a separate txt file
      if(length(obj.trajectory) > 5)
        file = fopen(file_name, 'w');
        txt_ = sprintf('Curve beginning at frame %d\n', obj.initial_frame);
        sz = length(obj.trajectory);
        
        for j = 1:sz
          txt_ = [txt_ sprintf('%d \t %d \n', obj.trajectory(j,1), obj.trajectory(j,2))];
        end
        fprintf(file, txt_);
      end
    end
    
  end
end