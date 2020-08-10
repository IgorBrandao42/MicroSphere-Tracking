close all; clear; clc

num = 150;
time_step = 0.0666666667;

%load('means.mat')

figure('Name', '1', 'units','normalized','outerposition',[0 0 1 1]

subplot(2,3,1)
histfit(means_x ,100,'kernel')
title('Histogram of mean x');

subplot(2,3,4)
histfit(means_y ,100,'kernel')
title('Histogram of mean y');

subplot(2,3,2)
histfit(means_vel_x ,100,'kernel')
title('Histogram of mean x velocity');

subplot(2,3,5)
histfit(means_vel_y ,100,'kernel')
title('Histogram of mean y velocity');

subplot(2,3,3)
h_x = histfit(means_vel_squared_x ,100,'kernel');
title('Histogram of mean x velocity squared');

hold on
local_max_x = islocalmax(h_x(2).YData);
masses_x    = h_x(2).YData( local_max_x );
location_x  = h_x(2).XData( local_max_x );

plot(location_x, masses_x, 'g*');

subplot(2,3,6)
h_y = histfit(means_vel_squared_y ,100,'kernel');
title('Histogram of mean y velocity squared');

hold on
local_max_y = islocalmax(h_y(2).YData);
masses_y    = h_y(2).YData( local_max_y );
location_y  = h_y(2).XData( local_max_y );
plot(location_y, masses_y, 'g*');


% https://www.mathworks.com/help/matlab/ref/islocalmax.html#mw_c1281fb8-0815-4c1e-be56-db29299d7f2f
