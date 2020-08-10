%function velocities(input_name, time_step)
close all
tic
num = 1761;
time_step = 0.0666666667;
input_name = [];

input_directory = 'Txt_Output';
addpath(input_directory);

means_x = [];
means_y = [];

means_vel_x = [];
means_vel_y = [];

means_vel_squared_x = [];
means_vel_squared_y = [];

if time_step == 0.0
  print("Tempo entre frame é nulo, impossível calcular velocidades!")
  return
end

for i=1:num
  current_name = sprintf('Curva%i.txt', i);
  % files = dir('Curva*.txt')
  % Deixa obsoleto a necessidade de saber o número de curvas!
  % Precisa mudar para esta pasta !
  
  t = readtable(current_name, 'HeaderLines', 1);
  trajec = table2array(t);
  
  if( length(trajec) < num_size || length(trajec) > 105 )
    continue
  end
  
  future_position  = trajec(2:length(trajec),:);
  current_position = trajec(1:length(trajec)-1,:);
  
  vel = (future_position - current_position)/time_step;
  
  trajec1 = trajec.^2;
  
  mean_x = mean(trajec1(:,1));
  mean_y = mean(trajec1(:,2));
  
  mean_vel_x = mean(vel(:,1));
  mean_vel_y = mean(vel(:,2));
  
  
  means_x = [means_x mean_x];
  means_y = [means_y mean_y];
  
  means_vel_x = [means_vel_x mean_vel_x];
  means_vel_y = [means_vel_y mean_vel_y];
  
  vel_squared = vel.^2;
  
  mean_vel_squared_x = mean(vel_squared(:,1));  %PIOR ESCOLHA DE NOME QUE JA DEI
  mean_vel_squared_y = mean(vel_squared(:,2));
  
  means_vel_squared_x = [means_vel_squared_x mean_vel_squared_x];
  means_vel_squared_y = [means_vel_squared_y mean_vel_squared_y];
  
end

length(means_x)


save('means.mat', 'means_x', 'means_y', 'means_vel_x', 'means_vel_y', 'means_vel_squared_x', 'means_vel_squared_y')

toc
subplot(2,3,1)
histogram(means_x ,100)
title('Histogram of mean x');

subplot(2,3,4)
histogram(means_y ,100)
title('Histogram of mean y');

subplot(2,3,2)
histogram(means_vel_x ,100)
title('Histogram of mean x velocity');

subplot(2,3,5)
histogram(means_vel_y ,100)
title('Histogram of mean y velocity');

subplot(2,3,3)
histogram(means_vel_squared_x ,100)
title('Histogram of mean x velocity squared');

subplot(2,3,6)
histogram(means_vel_squared_y ,100)
title('Histogram of mean y velocity squared');

%end
