classdef trajectory < handle
  properties
    curve
    lifespan
    max_life
    initial_frame
  end
  methods (Static)
    function obj = trajectory(x_, y_, initial_frame_, max_life_)
      if nargin > 0
        if isnumeric(x_) && isnumeric(y_) && isnumeric(initial_frame_)
          obj.curve = [];
          obj.max_life = max_life_;
          obj.lifespan = obj.max_life;
          obj.initial_frame = initial_frame_;
        else
          error('Value must be numeric')
        end
      end
      obj.expand(obj, x_, y_);
    end
    
    function has_died = check_lifetime(obj)
      obj.lifespan = obj.lifespan - 1;
      has_died = (obj.lifespan < 0);
    end
    
    function expand(obj, x_, y_)
      temp = [x_ y_]; %point(x_, y_);
      obj.curve = [obj.curve; temp];
      obj.lifespan = obj.max_life;
    end
    
    function has_printed = txt(obj, file_name)
      has_printed = length(obj.curve) > 2;
      if(has_printed)
        file = fopen(file_name, 'w');
        txt_ = sprintf('Curve beginning at frame %d\n', obj.initial_frame);
        sz = length(obj.curve);
        
        for j = 1:sz
          txt_ = [txt_ sprintf('%d \t %d \n', obj.curve(j,1), obj.curve(j,2))];
        end
        fprintf(file, txt_);
      end
    end
    
  end
end